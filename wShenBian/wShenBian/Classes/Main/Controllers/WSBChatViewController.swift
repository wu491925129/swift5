//
//  WSBChatViewController.swift
//  wShenBian
//
//  Created by tarena on 16/3/30.
//  Copyright © 2016年 tarena. All rights reserved.
//

import UIKit

class WSBChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    // 和谁聊天
    var  fjid : XMPPJID!
   // 显示聊天内容
    @IBOutlet weak var tableView: UITableView!
   // 获取输入消息
    @IBOutlet weak var msgField: UITextField!
    // view 距离底部的高度约束
    @IBOutlet weak var heightForBottom: NSLayoutConstraint!
    // 结果集控制器
    var  fetchCtrol : NSFetchedResultsController!
    // 加载聊天信息
    func  loadMsg(){
        // 获取上下文
        let context = WSBXMPPTool.getShraeInstance().xmppMsgArchStore.mainThreadManagedObjectContext
        // 关联实体
        let request = NSFetchRequest(entityName: "XMPPMessageArchiving_Message_CoreDataObject")
        // 设置谓词
        let jidStr = WSBUserInfo.getShareInstance().userName! + "@" + XMPPDOMAIN
        let pre = NSPredicate(format: "streamBareJidStr = %@ and bareJidStr = %@", jidStr,self.fjid.bare())
        request.predicate = pre
        // 设置排序
        let sort = NSSortDescriptor(key: "timestamp", ascending: true)
        request.sortDescriptors = [sort]
        // 获取数据
        self.fetchCtrol = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchCtrol.delegate = self
        do {
          try self.fetchCtrol.performFetch()
        }catch{
           print("获取聊天消息出错")
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return  1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  (self.fetchCtrol.fetchedObjects?.count)!
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let  cell = UITableViewCell()
        let  msgObject : XMPPMessageArchiving_Message_CoreDataObject = self.fetchCtrol.fetchedObjects![indexPath.row] as! XMPPMessageArchiving_Message_CoreDataObject
        cell.textLabel?.text = msgObject.body
        return cell
    }
    @IBAction func sendMsg(sender: AnyObject) {
        // 构建消息
        let msg = XMPPMessage.init(type: "chat", to: self.fjid)
        msg.addBody(self.msgField.text)
        // 发送消息
        WSBXMPPTool.getShraeInstance().xmppStream.sendElement(msg)
    }
    override func viewDidLoad() {
       super.viewDidLoad()
        print("fjid = \(fjid)")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // 加载聊天信息
        self.loadMsg()
    }
    // 数据发生改变
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "openKeyboard:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeKeyboard:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    func openKeyboard(notification :NSNotification){
        let keyFrame = notification.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue
        let options = UIViewAnimationOptions(rawValue: UInt((notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
        let durations = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        self.heightForBottom.constant = (keyFrame?.size.height)!
        UIView.animateWithDuration(durations!, delay: 0, options: options, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    func closeKeyboard(notification : NSNotification){
        let options = UIViewAnimationOptions(rawValue: UInt((notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).integerValue << 16))
        let durations = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        self.heightForBottom.constant = 0
        UIView.animateWithDuration(durations!, delay: 0, options: options, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }, completion: nil)

    }
}








