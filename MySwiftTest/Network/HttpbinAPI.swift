//
//  HttpbinAPI.swift
//  MySwiftTest
//
//  Created by ZeroDY on 2018/11/27.
//  Copyright © 2018 ZeroDY. All rights reserved.
//

import Moya

//初始化Httpbin.org请求的provider
let HttpbinProvider = MoyaProvider<Httpbin>()

//请求分类
public enum Httpbin {
    case ip
    case anything(String, String)  //请求数据
}

//请求配置
extension Httpbin: TargetType {
    //服务器地址
    public var baseURL: URL {
        return URL(string: "http://httpbin.org")!
    }
    
    //各个请求的具体路径
    public var path: String {
        switch self {
        case .ip:
            return "/ip"
        case .anything(_):
            return "/anything"
        }
    }
    
    //请求类型
    public var method: Moya.Method {
        return .post
    }
    
    //请求任务事件（这里附带上参数）
    public var task: Task {
        switch self {
        case .anything(let param1, let param2):
            var params: [String: Any] = [:]
            params["param1"] = param1
            params["param2"] = param2
            params["param3"] = nil
            return .requestParameters(parameters: params,
                                      encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    //是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
    
    //这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    //请求头
    public var headers: [String: String]? {
        return nil
    }
}
