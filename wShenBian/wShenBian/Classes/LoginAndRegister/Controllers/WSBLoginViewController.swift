//
//  WSBLoginViewController.swift
//  wShenBian
//
//  Created by tarena on 16/3/28.
//  Copyright © 2016年 tarena. All rights reserved.
//

import UIKit

class WSBLoginViewController: UIViewController , WSBXMPPLoginDelegate{

    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var userPasswordFeild: UITextField!
    
    @IBAction func loginBtnClick(sender: AnyObject) {
        // 说明这是登录
        WSBUserInfo.getShareInstance().isLogin = true
        print("用户名:\(userNameField.text!)")
        WSBUserInfo.getShareInstance().userName = userNameField.text!
        WSBUserInfo.getShareInstance().userPasswd = userPasswordFeild.text!
        // 调用XMPP 工具类 完成登录
//        WSBXMPPTool.getShraeInstance().loginDelegate = self
        // 使用闭包完成注册 
        weak var weakVc = self
        WSBXMPPTool.getShraeInstance().userLogin { (result) -> Void in
            weakVc?.handleLoginResult(result)
        }
        
    }
    // 处理登录的结果
    func  handleLoginResult(type :XMPPResultType){
        switch type {
        case .XMPPResultTypeLoginSuccess:
            print("login success")
            // 切换到主界面
            let storyBoard =  UIStoryboard.init(name: "Main", bundle: nil)
            UIApplication.sharedApplication().keyWindow?.rootViewController = storyBoard.instantiateInitialViewController()
        case .XMPPResultTypeLoginFailed:
            print("login failed")
       case .XMPPResultTypeLoginNetError:
            print("login net error")
        default:
            print("其他问题")
        }
    }
    // 登录成功
    func loginSuccess() {
        print("---登录成功")
        // 切换到主界面
        let storyBoard =  UIStoryboard.init(name: "Main", bundle: nil)
        UIApplication.sharedApplication().keyWindow?.rootViewController = storyBoard.instantiateInitialViewController()
    }
    // 登录失败
    func loginFailed() {
        print("---登录失败")
    }
    // 网络错误
    func loginNetError() {
        print("---登录时网络错误")
    }
    deinit{
        print("deinit:\(self)")
    }
}









