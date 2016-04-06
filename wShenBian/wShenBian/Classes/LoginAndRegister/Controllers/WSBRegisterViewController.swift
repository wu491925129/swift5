//
//  WSBRegisterViewController.swift
//  wShenBian
//
//  Created by tarena on 16/3/28.
//  Copyright © 2016年 tarena. All rights reserved.
//

import UIKit
/**  参考登录的实现 完成注册的逻辑 
     实现注册界面 
     区分登录还是注册的逻辑 存储注册信息
     XMPP工具类中完成注册的的逻辑
     在注册控制器中 处理注册的结果 
        注册成功转到登录界面 
     如果这个也做完了 可以增加MBProgressHUD 提示 */
class WSBRegisterViewController: UIViewController ,WSBXMPPRegisterDelegate{
 @IBOutlet weak var userRegisterPasswdFeild: UITextField!
 @IBOutlet weak var userRegisterNameFeild: UITextField!
   
 @IBAction func registerBtnClick(sender: AnyObject) {
     // 说明这是注册
     WSBUserInfo.getShareInstance().isLogin = false
     WSBUserInfo.getShareInstance().userRegisteName = self.userRegisterNameFeild.text!
     WSBUserInfo.getShareInstance().userRegiserPasswd = self.userRegisterPasswdFeild.text!
    // 调用XMPPTool 的注册方法
    // 先设置代理
//    WSBXMPPTool.getShraeInstance().registerDelegate = self
    weak  var weakVc = self
    WSBXMPPTool.getShraeInstance().userRegister { (result) -> Void in
        weakVc?.handleRegisterResult(result)
    }
 }
  // 处理注册的结果
    func  handleRegisterResult(type :XMPPResultType){
        switch type{
        case  .XMPPResultTypeRegisterSuccess:
            print("注册成功")
            MBProgressHUD.showSuccess("注册成功")
            self.dismissViewControllerAnimated(true, completion: nil)
       case .XMPPResultTypeRegisterFaild:
            print("注册失败")
            MBProgressHUD.showError("注册失败")
        case .XMPPResultTypeRegisterNetError:
            print("注册时网络错误")
            MBProgressHUD.showError("注册时网络错误")
        default:
            print("注册的其它问题")
        }
    }
  @IBAction func backBtnClick(sender: AnyObject) {
       
        self.dismissViewControllerAnimated(true , completion: nil)
    }
 // 注册成功
    func registerSuccess() {
        print("---注册成功")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
 // 注册失败
    func registerFailed() {
        print("---注册失败")
    }
 // 注册时网络错误
    func registerNetError() {
        print("---注册时网络错误")
    }
    deinit{
        print("deinit\(self)")
    }
}






