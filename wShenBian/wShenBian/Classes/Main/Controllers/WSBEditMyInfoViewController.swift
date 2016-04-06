//
//  WSBEditMyInfoViewController.swift
//  wShenBian
//
//  Created by tarena on 16/3/30.
//  Copyright © 2016年 tarena. All rights reserved.
//

import UIKit

class WSBEditMyInfoViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet weak var headImageView: UIImageView!
    
    @IBOutlet weak var nikeNameLabel: UITextField!
    
    // 修改个人信息按钮被点击
    @IBAction func updateMyInfoBtnClick(sender: AnyObject) {
        let vCardTemp = WSBXMPPTool.getShraeInstance().xmppvCard.myvCardTemp
        vCardTemp.photo = UIImagePNGRepresentation(self.headImageView.image!)
        vCardTemp.nickname = self.nikeNameLabel.text
        WSBXMPPTool.getShraeInstance().xmppvCard.updateMyvCardTemp(vCardTemp)
        //self.dismissViewControllerAnimated(true , completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // 获取电子名片信息
        let tempvCard = WSBXMPPTool.getShraeInstance().xmppvCard.myvCardTemp
        if let p =  tempvCard.photo{
            self.headImageView.image = UIImage.init(data: p)
        }else{
            self.headImageView.image =
                UIImage.init(named: "微信")
        }
        self.nikeNameLabel.text = tempvCard.nickname
       self.headImageView.setRoundLayer()
        // 增加手势
        self.headImageView.userInteractionEnabled = true
        self.headImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: "headImageTap"))
        
    }
    func headImageTap(){
        print("head image tap")
        let pc = UIImagePickerController.init()
        pc.allowsEditing = true
        pc.sourceType = .PhotoLibrary
        pc.delegate = self
        self.presentViewController(pc , animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // 注意类型转换
        let image : UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        self.headImageView.image = image
        self.dismissViewControllerAnimated(true , completion: nil)
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
