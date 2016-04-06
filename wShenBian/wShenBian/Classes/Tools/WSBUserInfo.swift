//
//  WSBUserInfo.swift
//  wShenBian
//
//  Created by tarena on 16/3/28.
//  Copyright © 2016年 tarena. All rights reserved.
//

import UIKit

class WSBUserInfo: NSObject {
    // 登录的用户名 密码
    var  userName : String?
    var  userPasswd : String?
    // 注册的用户名 密码
    var  userRegisteName : String?
    var  userRegiserPasswd : String?
    // 为了区分登录和注册
    var  isLogin : Bool?
    
    class func getShareInstance() -> WSBUserInfo {
        struct Singleton {
            static var dispatchOne : dispatch_once_t = 0
            static var instance : WSBUserInfo? = nil
        }
        dispatch_once(&Singleton.dispatchOne) { () -> Void in
            Singleton.instance = WSBUserInfo()
        }
        return Singleton.instance!
    }
}

// 考虑如何在Swift项目中使用OC框架代码?






