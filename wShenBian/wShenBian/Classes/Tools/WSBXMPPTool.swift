//
//  WSBXMPPTool.swift
//  wShenBian
//
//  Created by tarena on 16/3/28.
//  Copyright © 2016年 tarena. All rights reserved.
//

import UIKit
/** 桥接文件 项目 -- buildSettings  --> 搜索 Objective-c Bridge 设置位置即可 */
// 定义一个枚举代表登录 和注册的状态
enum  XMPPResultType{
    case XMPPResultTypeLoginSuccess,
    XMPPResultTypeLoginFailed,
    XMPPResultTypeLoginNetError,
    XMPPResultTypeRegisterNetError,
    XMPPResultTypeRegisterFaild,
    XMPPResultTypeRegisterSuccess
}
// 定义一个闭包类型 
typealias XMPPClosureType = (result : XMPPResultType) -> Void
class WSBXMPPTool: NSObject, XMPPStreamDelegate,XMPPRosterDelegate,UIActionSheetDelegate {
    var  xmppStream : XMPPStream!
    // 增加好友列表模块 和 对应的存储
    var xmppRoser : XMPPRoster!
    var xmppRoserStore : XMPPRosterCoreDataStorage!
    // 增加电子名片模块
    var xmppvCard : XMPPvCardTempModule!
    // 电子名片模块对应的存储
    var xmppvCardStore : XMPPvCardCoreDataStorage!
    // 头像模块
    var xmppvCardAvata : XMPPvCardAvatarModule!
    // 增加消息模块 和 对应的存储
    var xmppMsgArch : XMPPMessageArchiving!
    var xmppMsgArchStore : XMPPMessageArchivingCoreDataStorage!
    // 增加一个属性 代表要加谁为好友
    var fjid : XMPPJID!
    // 接收传入的闭包
    var  resultClosure : XMPPClosureType!
    // 登录的代理
//    weak var  loginDelegate : WSBXMPPLoginDelegate?
    // 注册的代理
//    weak var  registerDelegate :
//        WSBXMPPRegisterDelegate?
    // init 方法中调用 保证流不为空
    override init(){
        super.init()
        setupXmppStream()
    }
    class  func getShraeInstance() -> WSBXMPPTool {
        struct Singleton{
            static var predicate : dispatch_once_t = 0
            static var instance : WSBXMPPTool? = nil
        }
        dispatch_once(&Singleton.predicate) { () -> Void in
            Singleton.instance = WSBXMPPTool()
        }
        return  Singleton.instance!
    }
    // 设置流 设置代理
    func setupXmppStream(){
        xmppStream = XMPPStream()
        xmppStream.addDelegate(self, delegateQueue: dispatch_get_main_queue())
        // 给好友列表模块 和 对应的存储赋值
        self.xmppRoserStore = XMPPRosterCoreDataStorage.sharedInstance()
        self.xmppRoser = XMPPRoster.init(rosterStorage: self.xmppRoserStore)
        // 花名册模块 设置代理
       self.xmppRoser.addDelegate(self , delegateQueue: dispatch_get_main_queue())
        // 激活好友列表模块
        self.xmppRoser.activate(self.xmppStream)
        // 设置电子名片模块 
        self.xmppvCardStore = XMPPvCardCoreDataStorage.sharedInstance()
        self.xmppvCard = XMPPvCardTempModule.init(withvCardStorage: self.xmppvCardStore)
        // 设置头像模块
        self.xmppvCardAvata = XMPPvCardAvatarModule.init(withvCardTempModule: self.xmppvCard)
        // 激活电子名片模块 和 头像模块
        self.xmppvCard.activate(self.xmppStream)
        self.xmppvCardAvata.activate(self.xmppStream)
        // 给消息模块赋值 并激活
        self.xmppMsgArchStore = XMPPMessageArchivingCoreDataStorage.sharedInstance()
        self.xmppMsgArch = XMPPMessageArchiving.init(messageArchivingStorage: self.xmppMsgArchStore)
        self.xmppMsgArch.activate(self.xmppStream)
    }
    // 连接服务器 
    func connectToHost(){
        // 先断开上一次连接 不断开无法再次实现注册或者登陆
        xmppStream.disconnect()
        // 如果流是空 就设置流
        if self.xmppStream == nil {
            self.setupXmppStream()
        }
        var  userName : String? = nil
        if WSBUserInfo.getShareInstance().isLogin! {
            userName = WSBUserInfo.getShareInstance().userName!
        }else{
            userName = WSBUserInfo.getShareInstance().userRegisteName
        }
        // 构建jid
        xmppStream.myJID = XMPPJID.jidWithUser(userName, domain: XMPPDOMAIN, resource: "iphone")
        xmppStream.hostName = XMPPHOSTNAME
        xmppStream.hostPort = XMPPPORT
        do {
            try xmppStream.connectWithTimeout(XMPPStreamTimeoutNone)
        }catch let error as NSError{
            print(error.description)
        }
    }
    // 连接成功 (代理方法)
    func xmppStreamDidConnect(sender: XMPPStream!) {
        // 连接成功
        print("连接成功")
        
        // 如果是登录就发送密码 请求授权
        if WSBUserInfo.getShareInstance().isLogin!{
            self.sendLoginPassword()
        }else{
        // 如果是注册 就发送密码 完成注册 
            self.sendRegisterPassword()
        }
    }
    // 发送密码 完成注册
    func sendRegisterPassword(){
        do {
            try xmppStream.registerWithPassword(WSBUserInfo.getShareInstance().userRegiserPasswd)
        }catch let error as NSError{
            print(error.description)
        }
    }
    // 发送密码 请求授权的方法
    func sendLoginPassword(){
        do {
        try xmppStream.authenticateWithPassword(WSBUserInfo.getShareInstance().userPasswd!)
        }catch let error as NSError{
            print(error.description)
        }
    }
    // 注册成功 还是注册失败 (代理方法)
    func xmppStreamDidRegister(sender: XMPPStream!) {
        print("注册成功")
        //registerDelegate?.registerSuccess()
        resultClosure(result : .XMPPResultTypeRegisterSuccess)
    }
    func xmppStream(sender: XMPPStream!, didNotRegister error: DDXMLElement!) {
        print("注册失败")
        print("\(error.description)")
        //registerDelegate?.registerFailed()
        resultClosure(result : .XMPPResultTypeRegisterFaild)
    }
    //授权成功 (代理方法 )
    func xmppStreamDidAuthenticate(sender: XMPPStream!) {
        print("授权成功")
        // 这里代表登录成功 就让代理完成登录成功的逻辑
        //loginDelegate?.loginSuccess()
        // 发送在线消息
        resultClosure(result :XMPPResultType.XMPPResultTypeLoginSuccess)
        self.sendOnLine()
    }
    // 发送在线消息
    func sendOnLine(){
        xmppStream.sendElement(XMPPPresence())
    }
    // 授权失败
    func xmppStream(sender: XMPPStream!, didNotAuthenticate error: DDXMLElement!) {
        print(error.description)
        // 让代理完成登录失败的逻辑
        //loginDelegate?.loginFailed()
        resultClosure(result :XMPPResultType.XMPPResultTypeLoginFailed)
    }
    // 如何判断出现网络问题?(代理方法)
    func xmppStreamDidDisconnect(sender: XMPPStream!, withError error: NSError!) {
        if error != nil {
             // 登录时 网络出错
            if WSBUserInfo.getShareInstance().isLogin!{
                //loginDelegate?.loginNetError()
               resultClosure(result :XMPPResultType.XMPPResultTypeLoginNetError)
            }else{
                // 注册时 网络出错 
                //registerDelegate?.registerNetError()
                resultClosure(result : XMPPResultType.XMPPResultTypeRegisterNetError)
            }
        }
    }
    // 提供用户登录的接口 
    func userLogin(function : XMPPClosureType){
        resultClosure = function
        self.connectToHost()
    }
    // 提供用户注册的接口
    func userRegister(function : XMPPClosureType){
        resultClosure = function
        self.connectToHost()
    }
    // 处理加好友的请求 花名册模块
    // 处理在线 加好友请求
    func xmppRoster(sender: XMPPRoster!, didReceivePresenceSubscriptionRequest presence: XMPPPresence!) {
        // 请求的用户的字符串
        let presentUserStr = presence.fromStr()
        print("present User is \(presentUserStr)")
        self.fjid = presence.from()
        let actionSheet = UIActionSheet.init(title: presentUserStr + "申请加好友", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "同意", otherButtonTitles: "同意并添加对方为好友" )
        actionSheet.showInView(UIApplication.sharedApplication().keyWindow!)
    }
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        print("index == \(buttonIndex)")
        
        if 0 == buttonIndex {
            // 同意对方 但不给对方发请求
            self.xmppRoser.acceptPresenceSubscriptionRequestFrom(self.fjid, andAddToRoster: false)
        }else if 1 == buttonIndex {
            self.xmppRoser.rejectPresenceSubscriptionRequestFrom(self.fjid)
        }else{
            // 同意并加对方为好友
            self.xmppRoser.acceptPresenceSubscriptionRequestFrom(self.fjid, andAddToRoster: true)
        }
    }
    // 处理离线加好友(加你的时候你不在线 过了一段时间 你又上线了)
    func xmppStream(sender: XMPPStream!, didReceivePresence presence: XMPPPresence!) {
        // 如果是订阅请求就处理
        print("presence type = \(presence.type())")
        // presence type = subscribe
    }
    
}










