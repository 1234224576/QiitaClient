//
//  MasterViewController.swift
//  QiitaClieant
//
//  Created by 曽和修平 on 2015/07/27.
//  Copyright (c) 2015年 曽和修平. All rights reserved.
//

import UIKit

class MasterViewController:JASidePanelController{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func awakeFromNib() {
        self.centerPanel = self.storyboard?.instantiateViewControllerWithIdentifier("MainNavigationController") as! UIViewController
        self.leftPanel = self.storyboard?.instantiateViewControllerWithIdentifier("SideMenuViewController") as! UIViewController
        self.rightPanel = nil;
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
