//
//  Utility.swift
//  MySwiftTest
//
//  Created by ZeroDY on 2018/11/26.
//  Copyright © 2018 ZeroDY. All rights reserved.
//

import Foundation
import UIKit
//
func dPrint<T>(_ message: T,
                 file: String = #file,
                 method: String = #function,
                 line: Int = #line)
{
    #if DEBUG
    let now = Date()
    let dformatter = DateFormatter()
    dformatter.dateFormat = "MM-dd HH:mm:ss.SSS"
    print("✅ \(dformatter.string(from: now)) ⇨ \((file as NSString).lastPathComponent)[\(line)] ⇨ \(method):\n \(message)")
    #endif
}



/// 获取沙盒Document路径
let kDocumentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
/// 获取沙盒Cache路径
let kCachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
/// 获取沙盒temp路径
let kTempPath = NSTemporaryDirectory()

/// 颜色
func kRGBAColor(_ r: CGFloat,_ g: CGFloat,_ b: CGFloat,_ a: CGFloat) -> UIColor {
    return UIColor.init(red: r, green: g, blue: b, alpha: a)
}
func kRGBColor(_ r: CGFloat,_ g: CGFloat,_ b: CGFloat) -> UIColor {
    return UIColor.init(red: r, green: g, blue: b, alpha: 1.0)
}
func kHexColorA(_ HexString: String,_ a: CGFloat) ->UIColor {
    return UIColor.init(hexString: HexString, alpha: a)
}
func kHexColor(_ HexString: String) ->UIColor {
    return UIColor.init(hexString: HexString)
}

let kColor_clear = UIColor.clear
let kColor_000000 = kHexColor("000000")
let kColor_111111 = kHexColor("111111")
let kColor_222222 = kHexColor("222222")
let kColor_333333 = kHexColor("333333")
let kColor_444444 = kHexColor("444444")
let kColor_555555 = kHexColor("555555")
let kColor_666666 = kHexColor("666666")
let kColor_777777 = kHexColor("777777")
let kColor_888888 = kHexColor("888888")
let kColor_999999 = kHexColor("999999")
let kColor_aaaaaa = kHexColor("aaaaaa")
let kColor_bbbbbb = kHexColor("bbbbbb")
let kColor_cccccc = kHexColor("cccccc")
let kColor_dddddd = kHexColor("dddddd")
let kColor_eeeeee = kHexColor("eeeeee")
let kColor_ffffff = kHexColor("ffffff")
let kColor_ff0000 = kHexColor("ff0000")     //大红
let kColor_00ff00 = kHexColor("00ff00")     //大黄
let kColor_0000ff = kHexColor("0000ff")     //大蓝


// UserDefaults 操作
let kUserDefaults = UserDefaults.standard
func kUserDefaultsRead(_ KeyStr: String) -> String {
    return kUserDefaults.string(forKey: KeyStr)!
}
func kUserDefaultsWrite(_ obj: Any, _ KeyStr: String) {
    kUserDefaults.set(obj, forKey: KeyStr)
}
func kUserValue(_ A: String) -> Any? {
    return kUserDefaults.value(forKey: A)
}

//获取屏幕大小
let kUIScreenSize = UIScreen.main.responds(to: #selector(getter: UIScreen.nativeBounds)) ? CGSize(width: UIScreen.main.nativeBounds.size.width / UIScreen.main.nativeScale, height: UIScreen.main.nativeBounds.size.height / UIScreen.main.nativeScale) : UIScreen.main.bounds.size
let kUIScreenWidth = kUIScreenSize.width
let kUIScreenHeight = kUIScreenSize.height
let kUIScreenBounds = UIScreen.main.bounds

//APP版本号
let kAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
//当前系统版本号
let kSystemVersion = (UIDevice.current.systemVersion as NSString).floatValue
//检测用户版本号
let kiOS12 = (kSystemVersion >= 12.0)
let kiOS11 = (kSystemVersion >= 11.0 && kSystemVersion < 12.0)
let kiOS10 = (kSystemVersion >= 10.0 && kSystemVersion < 11.0)
let kiOS9 = (kSystemVersion >= 9.0 && kSystemVersion < 10.0)
let kiOS8 = (kSystemVersion >= 8.0 && kSystemVersion < 9.0)
let kiOS12Later = (kSystemVersion >= 12.0)
let kiOS11Later = (kSystemVersion >= 11.0)
let kiOS10Later = (kSystemVersion >= 10.0)
let kiOS9Later = (kSystemVersion >= 9.0)
let kiOS8Later = (kSystemVersion >= 8.0)


//获取当前语言
let kAppCurrentLanguage = Locale.preferredLanguages[0]
//判断是否为iPhone
let kDeviceIsiPhone = (UI_USER_INTERFACE_IDIOM() == .phone)
//判断是否为iPad
let kDeviceIsiPad = (UI_USER_INTERFACE_IDIOM() == .pad)

//判断 iPhone 的屏幕尺寸
let kSCREEN_MAX_LENGTH = max(kUIScreenWidth, kUIScreenHeight)
let kSCREEN_MIN_LENGTH = min(kUIScreenWidth, kUIScreenHeight)

//适配 350 375 414       568 667 736
func kAutoLayoutWidth(_ width: CGFloat) -> CGFloat {
    return width*kUIScreenWidth / 375
}
func kAutoLayoutHeigth(_ height: CGFloat) -> CGFloat {
    return height*kUIScreenHeight / 667
}

//机型判断
let kUI_IPHONE = (UIDevice.current.userInterfaceIdiom == .phone)
let kUI_IPHONE5 = (kUI_IPHONE && kSCREEN_MAX_LENGTH == 568.0)
let kUI_IPHONE6 = (kUI_IPHONE && kSCREEN_MAX_LENGTH == 667.0)
let kUI_IPHONEPLUS = (kUI_IPHONE && kSCREEN_MAX_LENGTH == 736.0)
let kUI_IPHONEX = (kUI_IPHONE && kSCREEN_MAX_LENGTH > 780.0)

//获取状态栏、标题栏、导航栏高度
let kUIStatusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
let kUINavigationBarHeight: CGFloat =  kUI_IPHONEX ? 88 : 44
let kUITabBarHeight: CGFloat = kUI_IPHONEX ? 83 : 49
//navigationBarHeight默认高度44 （iPhoneX 88）
//tabBarHeight默认高度49     （iPhoneX 83）

// 注册通知
func kNOTIFY_ADD(observer: Any, selector: Selector, name: String) {
    return NotificationCenter.default.addObserver(observer, selector: selector, name: Notification.Name(rawValue: name), object: nil)
}
// 发送通知
func kNOTIFY_POST(name: String, object: Any) {
    return NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: object)
}
// 移除通知
func kNOTIFY_REMOVE(observer: Any, name: String) {
    return NotificationCenter.default.removeObserver(observer, name: Notification.Name(rawValue: name), object: nil)
}

//代码缩写
let kApplication = UIApplication.shared
let kAPPKeyWindow = kApplication.keyWindow
let kAppDelegate = kApplication.delegate
let kAppNotificationCenter = NotificationCenter.default
let kAppRootViewController = kAppDelegate?.window??.rootViewController

//字体 字号
func kFontSize(_ a: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: a)
}
func kFontBoldSize(_ a: CGFloat) -> UIFont {
    return UIFont.boldSystemFont(ofSize: a)
}
func kFontForIPhone5or6Size(_ a: CGFloat, _ b: CGFloat) -> UIFont {
    return kUI_IPHONE5 ? kFontSize(a) : kFontSize(b)
}

/**
 字符串是否为空
 @param str NSString 类型 和 子类
 @return  BOOL类型 true or false
 */
func kStringIsEmpty(_ str: String!) -> Bool {
    if str.isEmpty {
        return true
    }
    if str == nil {
        return true
    }
    if str.count < 1 {
        return true
    }
    if str == "(null)" {
        return true
    }
    if str == "null" {
        return true
    }
    return false
}
// 字符串判空 如果为空返回@“”
func kStringNullToempty(_ str: String) -> String {
    let resutl = kStringIsEmpty(str) ? "" : str
    return resutl
}
func kStringNullToReplaceStr(_ str: String,_ replaceStr: String) -> String {
    let resutl = kStringIsEmpty(str) ? replaceStr : str
    return resutl
}

/**
 数组是否为空
 @param array NSArray 类型 和 子类
 @return BOOL类型 true or false
 */
func kArrayIsEmpty(_ array: [String]) -> Bool {
    let str: String! = array.joined(separator: "")
    if str == nil {
        return true
    }
    if str == "(null)" {
        return true
    }
    if array.count == 0 {
        return true
    }
    if array.isEmpty {
        return true
    }
    return false
}
/**
 字典是否为空
 @param dic NSDictionary 类型 和子类
 @return BOOL类型 true or false
 */
func kDictIsEmpty(_ dict: NSDictionary) -> Bool {
    let str: String! = "\(dict)"
    if str == nil {
        return true
    }
    if str == "(null)" {
        return true
    }
    if dict .isKind(of: NSNull.self) {
        return true
    }
    if dict.allKeys.count == 0 {
        return true
    }
    return false
}

