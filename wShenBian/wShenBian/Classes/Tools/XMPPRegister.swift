//
//  XMPPRegister.swift
//  wShenBian
//
//  Created by tarena on 16/3/28.
//  Copyright © 2016年 tarena. All rights reserved.
//

import Foundation
// 注册协议
protocol WSBXMPPRegisterDelegate : NSObjectProtocol{
    // 注册成功
    func  registerSuccess()
    // 注册失败
    func  registerFailed()
    // 注册网络错误
    func  registerNetError()
}












