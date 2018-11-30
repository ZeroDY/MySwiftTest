//
//  NetworkManager.swift
//  MySwiftTest
//
//  Created by 周德艺 on 2018/11/28.
//  Copyright © 2018 ZeroDY. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import SwiftyJSON

/// 超时时长
private var requestTimeOut:Double = 30
/// 成功数据的回调
typealias successBlock = ((JSON) -> (Void))
/// 失败的回调
typealias failureBlock = ((MoyaError) -> (Void))
/// 错误的回调
typealias errorBlock = ((Int) -> (Void))


/// Endpoint 基本设置, 具体到哪个网络请求，做一些设置
private let endpointClosure = { (target: API) -> Endpoint in
    
    /// URL
    // let url = URL(target: target).absoluteString
    // 这里把endpoint重新构造一遍主要为了解决网络请求地址里面含有? 时无法解析的bug https://github.com/Moya/Moya/issues/1198
    let url = target.baseURL.absoluteString + target.path
    
    /// Task
    var task = target.task
    // 附加参数
    let additionalParameters = ["additionalKey1":"Valueeeeeeeeee"]
    let defaultEncoding = URLEncoding.default
    switch target.task {
    case .requestPlain:
        task = .requestParameters(parameters: additionalParameters, encoding: defaultEncoding)
    case .requestParameters(var parameters, let encoding):
        additionalParameters.forEach { parameters[$0.key] = $0.value }
        task = .requestParameters(parameters: parameters, encoding: encoding)
    default:
        // 需要添加的请求方式中做修改，不用的 default 掉
        break
    }
    
    /// Endpoint
    var endpoint = Endpoint(
        url: url,
        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
        method: target.method,
        task: task,
        httpHeaderFields: target.headers
    )
    
    /// RequestTimeOut
    //  每次请求都会调用 endpointClosure 设置超时时长
    switch target {
    case .testApiDict:
        requestTimeOut = 20
    case .testApi:
        requestTimeOut = 5
    default:
        break
    }
    
    return endpoint
}

/// 网络请求的设置
// 用来修改 URLRequest 的指定属性或者提供直到创建request才知道的信息（比如，cookie设置）给request是非常有用的
private let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        // 设置请求时长
        request.timeoutInterval = requestTimeOut
        // 禁用所有请求的cookie
        request.httpShouldHandleCookies = false
        // 打印请求参数
        if let requestData = request.httpBody {
            dPrint("✏️✏️✏️【\(request.httpMethod ?? "")】 ⇨ \(request.url!) \n\(JSON(requestData))")
        }else{
            dPrint("✏️✏️✏️【\(request.httpMethod ?? "")】 ⇨ \(request.url!) ")
        }
        done(.success(request))
    } catch {
        done(.failure(MoyaError.underlying(error, nil)))
    }
}

/*   设置ssl
 let policies: [String: ServerTrustPolicy] = [
 "example.com": .pinPublicKeys(
 publicKeys: ServerTrustPolicy.publicKeysInBundle(),
 validateCertificateChain: true,
 validateHost: true
 )
 ]
 */

// 用Moya默认的Manager还是Alamofire的Manager看实际需求。HTTPS就要手动实现Manager了
//private public func defaultAlamofireManager() -> Manager {
//
//    let configuration = URLSessionConfiguration.default
//
//    configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
//
//    let policies: [String: ServerTrustPolicy] = [
//        "ap.grtstar.cn": .disableEvaluation
//    ]
//    let manager = Alamofire.SessionManager(configuration: configuration,serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies))
//
//    manager.startRequestsImmediately = false
//
//    return manager
//}


/// NetworkActivityPlugin插件用来监听网络请求，界面上做相应的展示
//private let networkPlugin = NetworkActivityPlugin.init { (changeType, targetType) in
//
//    dPrint("networkPlugin \(changeType) -- \(targetType)")
//    //targetType 是当前请求的基本信息
//    switch(changeType){
//    case .began:
//        dPrint("开始请求网络")
//
//    case .ended:
//        dPrint("结束")
//    }
//}


// https://github.com/Moya/Moya/blob/master/docs/Providers.md  参数使用说明
// stubClosure   用来延时发送网络请求


/// Provider
/// 网络请求发送的核心初始化方法，创建网络请求对象
let Provider = MoyaProvider<API>(endpointClosure: endpointClosure, requestClosure: requestClosure, plugins:[RequestActivityPlugin(view: kAPPKeyWindow!)], trackInflights: false)

/// 最常用的网络请求，只需知道正确的结果无需其他操作时候用这个
///
/// - Parameters:
///   - target: 网络请求
///   - success: 请求成功的回调
func NetworkRequest(_ target: API,
                    success successCallback: @escaping successBlock){
    NetworkRequest(target, success: successCallback, error: nil, failure: nil)
}


/// 需要知道成功或者失败的网络请求， 要知道code码为其他情况时候用这个
///
/// - Parameters:
///   - target: 网络请求
///   - success: 成功的回调
///   - error: 报错回调
func NetworkRequest(_ target: API,
                    success successCallback: @escaping successBlock,
                    error errorCallback: errorBlock?) {
    NetworkRequest(target, success: successCallback, error: errorCallback, failure: nil)
}


///  需要知道成功、失败、错误情况回调的网络请求   像结束下拉刷新各种情况都要判断
///
/// - Parameters:
///   - target: 网络请求
///   - success: 成功的回调
///   - error: 报错回调
///   - failed: 请求失败
func NetworkRequest(_ target: API,
                    success successCallback: @escaping successBlock,
                    error errorCallback: errorBlock?,
                    failure failureCallback: failureBlock?) {
    
    if !GlobalNetworkMonitor.sharedInstance.isReachable{
        SwiftNotice.showNoticeWithText(.error, text: "网络似乎出现了问题", autoClear: true, autoClearTime: 1.5)
        return
    }
    
    Provider.request(target) { (result) in
        switch result {
        case let .success(response):
            do {
                // 如果数据返回成功则直接将结果转为JSON
                // try response.filterSuccessfulStatusCodes()
                let json = try JSON(response.mapJSON())
                dPrint("✅✅✅ \(URL(target: target))  \n\(json)")
                successCallback(json)
            }
            catch let error {
                // 如果数据获取失败，则返回错误状态码
                dPrint("❗️❗️❗️ \(URL(target: target))  \n ===>>> \(error)")
                guard let errorCallback = errorCallback else {
                    break
                }
                errorCallback((error as! MoyaError).response!.statusCode)
            }
        case let .failure(error):
            dPrint("❌❌❌ \(URL(target: target))  \n ===>>> \(error)")
            //如果连接异常，则返沪错误信息（必要时还可以将尝试重新发起请求）
            guard let failureCallback = failureCallback else{
                break
            }
            failureCallback(error)
        }
    }
    
}


/// 基于Alamofire,网络是否连接，，这个方法不建议放到这个类中,可以放在全局的工具类中判断网络链接情况
/// 用get方法是因为这样才会在获取isNetworkConnect时实时判断网络链接请求，如有更好的方法可以fork
var isNetworkConnect: Bool {
    get{
        let network = NetworkReachabilityManager()
        return network?.isReachable ?? true //无返回就默认网络已连接
    }
}

/// Demo中并未使用，以后如果有数组转json可以用这个。
struct JSONArrayEncoding: ParameterEncoding {
    static let `default` = JSONArrayEncoding()
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        
        guard let json = parameters?["jsonArray"] else {
            return request
        }
        
        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        
        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        request.httpBody = data
        
        return request
    }
}

