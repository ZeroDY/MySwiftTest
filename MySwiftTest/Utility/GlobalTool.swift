//
//  GlobalTool.swift
//  MySwiftTest
//
//  Created by ZeroDY on 2018/11/29.
//  Copyright © 2018 ZeroDY. All rights reserved.
//

import Foundation
import Reachability


class GlobalNetworkMonitor{
    
    // 全局变量
    static let sharedInstance = GlobalNetworkMonitor()
    
    private var reachability: Reachability!
    
    private var showHUD = false
    
    
    private init() {
        self.reachability = Reachability()!
    }

    func startNotifier() -> Void {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
        do {
            try reachability.startNotifier()
        } catch {
            dPrint("Unable to start notifier")
        }
    }
    
    func stopNotifier() -> Void {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        let reachability = notification.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            if showHUD {
                SwiftNotice.showNoticeWithText(.info, text: "WiFi 连接", autoClear: true, autoClearTime: 1.5)
            }
        case .cellular:
            if showHUD {
                SwiftNotice.showNoticeWithText(.info, text: "流量连接", autoClear: true, autoClearTime: 1.5)
            }
        case .none:
            self.showHUD = true
            if showHUD {
                SwiftNotice.showNoticeWithText(.error, text: "网络断开", autoClear: true, autoClearTime: 1.5)
            }
        }
    }
    
    
    var isReachable:Bool {
        get{
            return self.reachability.connection != .none
        }
    }
    
    
}

