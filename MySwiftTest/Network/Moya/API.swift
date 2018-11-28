//
//  API.swift
//  MySwiftTest
//
//  Created by ZeroDY on 2018/11/28.
//  Copyright © 2018 ZeroDY. All rights reserved.
//

import Foundation
import Moya

enum API {
    case testApi
    case testApiPara(para1:String, para2:String)
    case testApiDict(dict:[String:Any])
}

extension API:TargetType{
    //baseURL 也可以用枚举来区分不同的baseURL，不过一般也只有一个BaseURL
    var baseURL: URL {
//        return URL.init(string: "http://news-at.zhihu.com/api/")!
        switch self {
        case .testApi:
            return URL.init(string: "http://news-at.zhihu.com/api/")!
        case .testApiPara:
            return URL.init(string: "http://news-at.zhihu.com/api/")!
        case .testApiDict:
            return URL.init(string: "http://news-at.zhihu.com/api/")!
        }
    }
    
    var path: String {
        switch self {
        case .testApi:
            return "4/news/latest"
        case let .testApiPara(para1, _):
            return "\(para1)/news/latest"
        case .testApiDict:
            return "4/news/latest"
//        default:
//            return "4/news/latest"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .testApi:
            return .get
        default:
            return .post
        }
    }
    
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case .testApi:
            return .requestPlain
        case let .testApiPara(para1, _)://这里的缺点就是多个参数会导致parameters拼接过长
            //后台的content-Type 为application/x-www-form-urlencoded时选择URLEncoding
            return .requestParameters(parameters: ["key":para1], encoding: URLEncoding.default)
        case let .testApiDict(dict)://所有参数当一个字典进来完事。
            //后台可以接收json字符串做参数时选这个
            return .requestParameters(parameters: dict, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        //同task，具体选择看后台 有application/x-www-form-urlencoded 、application/json
        return ["Content-Type":"application/x-www-form-urlencoded"]
    }
    
    
}
