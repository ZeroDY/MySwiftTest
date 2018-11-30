  //
//  RequestAlertPlugin.swift
//  MySwiftTest
//
//  Created by ZeroDY on 2018/11/28.
//  Copyright © 2018 ZeroDY. All rights reserved.
//

import Foundation

import UIKit
import Moya
import Result

final class RequestActivityPlugin: PluginType {
    
    //当前的视图控制器
    private let containerView: UIView
    
    //活动状态指示器（菊花进度条）
    private var spinner: UIActivityIndicatorView!
    
    //插件初始化的时候传入当前的视图控制器
    init(view: UIView) {
        self.containerView = view
        //初始化活动状态指示器
        self.spinner = UIActivityIndicatorView(style: .gray)
        self.spinner.center = self.containerView.center
    }
    
    //开始发起请求
    func willSend(_ request: RequestType, target: API) {
        if target.showActivityPlugin {
            //请求时在界面中央显示一个活动状态指示器
            containerView.addSubview(spinner)
            spinner.startAnimating()
        }

    }
    
    //收到请求
    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: API) {
        if target.showActivityPlugin {
            //移除界面中央的活动状态指示器
            spinner.removeFromSuperview()
            spinner.stopAnimating()
        }
        //只有请求错误时会继续往下执行
        guard case let Result.failure(error) = result else { return }
        
        //弹出并显示错误信息
        UIAlertController.showAlert(message: "发生错误：\(error)")
    }
}
