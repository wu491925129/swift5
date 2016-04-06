//
//  WSBMyInfoViewController.swift
//  wShenBian
//
//  Created by tarena on 16/3/29.
//  Copyright © 2016年 tarena. All rights reserved.
//

import UIKit

class WSBMyInfoViewController: UIViewController {

    @IBOutlet weak var headImageView: UIImageView!
    
    @IBOutlet weak var nikeNameLabel: UILabel!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let tempvCard = WSBXMPPTool.getShraeInstance().xmppvCard.myvCardTemp
        if let p =  tempvCard.photo{
            self.headImageView.image = UIImage.init(data: p)
        }else{
            self.headImageView.image =
                UIImage.init(named: "微信")
        }
       self.headImageView.setRoundLayer()
        self.nikeNameLabel.text = tempvCard.nickname
        // 实现修改个人信息和聊天
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
