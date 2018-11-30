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
    case version(version: String)      /** 软件版本查询*/
    case newsLatest     /** 最新消息*/
    case newsDetail(newsId: String)     /** 消息内容获取与离线下载*/
    case newsBefore(date: String)     /** 过往消息*/
    case newsExtra(newsId: String)     /**  新闻额外信息*/
    
    case testApiDict(dict:[String:Any])
    case uploadImage(parameters: [String:Any], imageDate:Data)
}

extension API:TargetType{
    //baseURL 也可以用枚举来区分不同的baseURL，不过一般也只有一个BaseURL
    var baseURL: URL {
        return URL.init(string: "https://news-at.zhihu.com/api/")!
    }
    
    
    var path: String {
        switch self {
        case .version(let v):
            return "4/version/ios/\(v)"
            
        case .newsLatest:
            return "4/news/latest"
            
        case .newsDetail(let newsId):
            return "4/news/\(newsId)"
            
        case .newsBefore(let date):
            return "4/news/before/\(date)"
            
        case .newsExtra(let newsId):
            return "4/story-extra/\(newsId)"
        
        case .testApiDict:
            return "4/news/latest"
        case .uploadImage:
            return "/file/user/upload.jhtml"
        }
    }
    
        
    var method: Moya.Method {
        return .get
    }
    
        
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
        
    var task: Task {
        switch self {
        case .version, .newsLatest, .newsDetail, .newsBefore, .newsExtra:
            return .requestPlain
//        case let .newsLatest(para1, _):
//            //这里的缺点就是多个参数会导致parameters拼接过长
//            //后台的content-Type 为application/x-www-form-urlencoded时选择URLEncoding
//            return .requestParameters(parameters: ["key":para1], encoding: URLEncoding.default)
        case let .testApiDict(dict)://所有参数当一个字典进来完事。
            //后台可以接收json字符串做参数时选这个
            return .requestParameters(parameters: dict, encoding: JSONEncoding.default)
        case let .uploadImage(parameters, imageDate):
            ///name 和fileName 看后台怎么说，   mineType根据文件类型上百度查对应的mineType
            let formData = MultipartFormData(provider: .data(imageDate), name: "file",
                                             fileName: "hangge.png", mimeType: "image/png")
            return .uploadCompositeMultipart([formData], urlParameters: parameters)
        }
    }
    
    var headers: [String : String]? {
        //同task，具体选择看后台 有application/x-www-form-urlencoded 、application/json
        return ["Content-Type":"application/x-www-form-urlencoded"]
    }
    
    
    var showActivityPlugin: Bool {
        switch self {
        case .testApiDict:
            return true
        default:
            return false
        }
    }
    
    
}
