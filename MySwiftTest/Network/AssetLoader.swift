//
//  AssetLoader.swift
//  MySwiftTest
//
//  Created by ZeroDY on 2018/11/28.
//  Copyright © 2018 ZeroDY. All rights reserved.
//

import Moya
import Alamofire

//默认下载保存地址（用户文档目录）
fileprivate let assetDir: URL = {
    let directoryURLs = FileManager.default.urls(for: .documentDirectory,
                                                 in: .userDomainMask)
    return directoryURLs.first ?? URL(fileURLWithPath: NSTemporaryDirectory())
}()

//资源分类
public enum Asset {
    case logo  //logo图标
    case star  //星形图标
    case checkmark  //勾选图标
}

//资源配置
extension Asset: TargetType {
    
    //根据枚举值获取对应的资源文件名
    var assetName: String {
        switch self {
        case .logo: return "0ff41bd5ad6eddc4802878ba34dbb6fd536633a0.jpg"
        case .star: return "c7cf816776f40ad10ae4c1e3672d1151/d439b6003af33a8724e4b645cb5c10385243b5e0.jpg"
        case .checkmark: return "checkmark.png"
        }
    }
    
    //获取对应的资源文件本地存放路径
    var localLocation: URL {
        return assetDir.appendingPathComponent(assetName)
    }
    
    //服务器地址
    public var baseURL: URL {
        return URL(string: "http://g.hiphotos.baidu.com")!
    }
    
    //各个请求的具体路径
    public var path: String {
        switch self {
        case .logo:
            return "/image/pic/item/\(assetName)"
        case .star:
            return "/image/h%3D300/sign=\(assetName)"
        case .checkmark:
            return "/image/h%3D300/sign=\(assetName)"
        }
    }
    
    //请求类型
    public var method: Moya.Method {
        return .get
    }
    
    //定义一个DownloadDestination
    var downloadDestination: DownloadDestination {
        return { _, _ in return (self.localLocation, .removePreviousFile) }
    }
    
    //请求任务事件
    public var task: Task {
        return .downloadDestination(downloadDestination)
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

//资源下载器
final class AssetLoader {
    let provider = MoyaProvider<Asset>()
    
    init() { }
    
    func load(asset: Asset, completion: ((Result<Any>) -> Void)? = nil) {
        if FileManager.default.fileExists(atPath: asset.localLocation.path) {
            completion?(.success(asset.localLocation))
            return
        }
        
        provider.request(asset) { result in
            switch result {
            case .success:
                completion?(.success(asset.localLocation))
            case let .failure(error):
                completion?(.failure(error))
            }
        }
    }
}
