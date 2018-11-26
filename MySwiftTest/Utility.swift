//
//  Utility.swift
//  MySwiftTest
//
//  Created by ZeroDY on 2018/11/26.
//  Copyright © 2018 ZeroDY. All rights reserved.
//

import Foundation

//
func dPrint<T>(_ message: T,
                 file: String = #file,
                 method: String = #function,
                 line: Int = #line)
{
    #if DEBUG
    print("✅ \((file as NSString).lastPathComponent)[\(line)] ⇨ \(method):\n \(message)")
    #endif
}

