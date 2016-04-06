//
//  WSBFriendsViewController.swift
//  wShenBian
//
//  Created by tarena on 16/3/29.
//  Copyright © 2016年 tarena. All rights reserved.
//

import UIKit

class WSBFriendsViewController: UITableViewController,NSFetchedResultsControllerDelegate {
    // 结果集控制器
    var resultController : NSFetchedResultsController!
    override func viewDidLoad() {
        self.loadFriend()
    }
    // 数据变化刷新界面
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }
    /** 加载好友列表 */
    func  loadFriend(){
        // 获取上下文
        let context = WSBXMPPTool.getShraeInstance().xmppRoserStore.mainThreadManagedObjectContext
        // 关联实体
        let request = NSFetchRequest(entityName: "XMPPUserCoreDataStorageObject")
        // 设置谓词
        let jidStr = WSBUserInfo.getShareInstance().userName! + "@" + XMPPDOMAIN
        let pre = NSPredicate(format: "streamBareJidStr = %@", jidStr)
        request.predicate = pre
        // 设置排序
        let sort = NSSortDescriptor(key: "displayName", ascending: true)
        request.sortDescriptors = [sort]
        // 获取数据
        resultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        // 设置代理
        resultController.delegate = self
        do{
            try resultController.performFetch()
        }catch{
            print("获取好友数据出错")
        }
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.resultController.fetchedObjects?.count)!
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : WSBFriendTableViewCell = tableView.dequeueReusableCellWithIdentifier("friendCell") as! WSBFriendTableViewCell
        let friend : XMPPUserCoreDataStorageObject = self.resultController.fetchedObjects![indexPath.row] as! XMPPUserCoreDataStorageObject
//        cell.textLabel?.text = friend.displayName
        cell.friendNameLabel.text = friend.displayName
        switch friend.sectionNum.intValue {
        case 0:
            cell.friendStatusLabel.text = "在线"
        case 1:
            cell.friendStatusLabel.text = "离开"
        case 2:
            cell.friendStatusLabel.text
                = "离线"
        default:
            cell.friendStatusLabel.text = ""
        }
        cell.headImageView.image = UIImage.init(named: "微信")
        return  cell
    }
    // 向左滑 删除好友
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let friend = self.resultController.fetchedObjects![indexPath.row] as! XMPPUserCoreDataStorageObject
        if editingStyle == .Delete{
            WSBXMPPTool.getShraeInstance().xmppRoser.removeUser(friend.jid)
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 获取这一行对应的好友
        let friend : XMPPUserCoreDataStorageObject = self.resultController.fetchedObjects![indexPath.row] as! XMPPUserCoreDataStorageObject
    self.performSegueWithIdentifier("chatSegue", sender: friend.jid)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destViewController = segue.destinationViewController
        if  destViewController is WSBChatViewController {
         let destVc : WSBChatViewController = segue.destinationViewController as!
            WSBChatViewController
         destVc.fjid = sender as! XMPPJID
        }
    }
}












