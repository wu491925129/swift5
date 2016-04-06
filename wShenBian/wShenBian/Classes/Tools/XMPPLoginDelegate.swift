//
//  XMPPLoginDelegate.swift
//  wShenBian
//
//  Created by tarena on 16/3/28.
//  Copyright © 2016年 tarena. All rights reserved.
//

import Foundation
// 登录协议 
protocol  WSBXMPPLoginDelegate : NSObjectProtocol{
    // 登录成功
    func  loginSuccess()
    // 登录失败
    func  loginFailed()
    // 网络错误
    func  loginNetError()
}













