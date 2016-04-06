//
//  WSBAddFriendViewController.swift
//  wShenBian
//
//  Created by tarena on 16/3/29.
//  Copyright © 2016年 tarena. All rights reserved.
//

import UIKit

class WSBAddFriendViewController: UIViewController {

    @IBOutlet weak var friendNameField: UITextField!
    
    @IBAction func addFriendBtnClick(sender: AnyObject) {
        let friendName = self.friendNameField.text!
        let jidStr = friendName + "@" + XMPPDOMAIN
        let fjid = XMPPJID.jidWithString(jidStr)
        if WSBXMPPTool.getShraeInstance().xmppRoserStore .userExistsWithJID(fjid, xmppStream: WSBXMPPTool.getShraeInstance().xmppStream) {
            MBProgressHUD.showError("已经是你的好友了")
            return;
        }
        if friendName == WSBUserInfo.getShareInstance().userName! {
            MBProgressHUD.showError("不能添加自己")
                return
        }
        // 添加好友
        WSBXMPPTool.getShraeInstance().xmppRoser.subscribePresenceToUser(fjid)
//        self.dismissViewControllerAnimated(true , completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
