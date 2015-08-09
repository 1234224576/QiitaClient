//
//  FirstViewController.swift
//  QiitaClieant
//
//  Created by 曽和修平 on 2015/08/09.
//  Copyright (c) 2015年 曽和修平. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.showTutorial()
        self.autologin()
    }
    
    private func showTutorial(){
        
    }
    
    private func autologin(){
        if User.sharedUser.url_name != ""{
            self.presentMainSpilitViewController()
        }else{
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let controller: LoginViewController = storyboard.instantiateInitialViewController() as! LoginViewController
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func presentMainSpilitViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: SplitViewController = storyboard.instantiateInitialViewController() as! SplitViewController
        self.presentViewController(controller, animated: true, completion: nil)
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
