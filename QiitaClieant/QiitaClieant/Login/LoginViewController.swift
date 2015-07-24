//
//  LoginViewController.swift
//  QiitaClieant
//
//  Created by 曽和修平 on 2015/07/24.
//  Copyright (c) 2015年 曽和修平. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class LoginViewController: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameField.delegate = self
        passwordField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func tapLoginButton(sender: AnyObject) {
        SVProgressHUD.show()
        Alamofire.request(.POST, Const().baseApiUrlString+"auth",parameters: ["url_name":userNameField.text,"password":passwordField.text])
            .responseJSON{[weak self] (request, response, json, error) in
            if let weakSelf = self{
                SVProgressHUD.dismiss()
                if let j:AnyObject = json{
                    let jsondata = JSON(j)
                    print(jsondata)
                    if jsondata["error"] != nil{
                        //ログイン失敗
                        let alert = UIAlertController(title: "", message: "ログインに失敗しました", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .Default,handler:nil))
                        weakSelf.presentViewController(alert, animated: true, completion: nil)
                    }else{
                        //ログイン成功
                        User.sharedUser.token = jsondata["token"].string!
                        User.sharedUser.userName = jsondata["url_name"].string!
                        User.sharedUser.url_name = weakSelf.userNameField.text
                        User.sharedUser.password = weakSelf.passwordField.text
                    }
                }
            }
        }
    }
}
