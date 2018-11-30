//
//  ZhNewsModel.swift
//  MySwiftTest
//
//  Created by ZeroDY on 2018/11/30.
//  Copyright © 2018 ZeroDY. All rights reserved.
//

import Foundation
import ObjectMapper
import HandyJSON

class Story: HandyJSON {
    var id: String?
    var title: String?
    var ga_prefix: String?
    var image: String?
    var images: [String]?
    
    required init() {
        
    }
//    init(){
//    }
//
//    required init?(map: Map) {
//    }
//
//    // Mappable
//    func mapping(map: Map) {
//        id              <- map["id"]
//        title           <- map["title"]
//        ga_prefix       <- map["ga_prefix"]
//        images          <- map["images"]
//    }
}

class TopStory: HandyJSON {
    var id: String?
    var title: String?
    var ga_prefix: String?
    var images: [String]?
    
    required init() {
        
    }
//    init(){
//    }
//
//    required init?(map: Map) {
//    }
//
//    // Mappable
//    func mapping(map: Map) {
//        id            <- map["id"]
//        title         <- map["title"]
//        ga_prefix     <- map["ga_prefix"]
//        images        <- map["images"]
//    }
}

