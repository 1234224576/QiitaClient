//
//  SideMenuViewController.swift
//  QiitaClieant
//
//  Created by 曽和修平 on 2015/07/27.
//  Copyright (c) 2015年 曽和修平. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var contributionLabel: UILabel!
    
    // data
    let segues = ["option 1", "option 2", "option 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userImageView.layer.cornerRadius = CGRectGetHeight(userImageView.frame)/2.0;
        self.userImageView.layer.masksToBounds = true
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerNib(UINib(nibName: "MainArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "MainArticleTableViewCell")
        self.userNameLabel.text = User.sharedUser.url_name
        // Do any additional setup after loading the view.
        self.loadUserdata()
        
    }
    
    func loadUserdata(){
        Alamofire.request(.GET, Const().baseApiUrlString+"users/\(User.sharedUser.url_name)")
            .responseJSON{[weak self] (request, response, json, error) in
                print(request)
            if let weakSelf = self{
                if let j:AnyObject = json{
                    let jsondata = JSON(j)
                    print(jsondata)
                    if jsondata["error"] != nil{
                        //取得失敗
                        print(jsondata)
                    }else{
                        //取得成功
                        print(jsondata["profile_image_url"])
                        UIImage.loadAsyncFromURL(jsondata["profile_image_url"].string!, callback: {
                            (image: UIImage?) in
                            weakSelf.userImageView.image = image
                        })
//
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDelegate&DataSource methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return segues.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MainArticleTableViewCell", forIndexPath: indexPath) as! MainArticleTableViewCell
        cell.textLabel?.text = segues[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        let nvc = self.mainNavigationController()
//        if let hamburguerViewController = self.findHamburguerViewController() {
//            hamburguerViewController.hideMenuViewControllerWithCompletion({ () -> Void in
//                nvc.visibleViewController.performSegueWithIdentifier(self.segues[indexPath.row], sender: nil)
//                hamburguerViewController.contentViewController = nvc
//            })
//        }
    }
    
    // MARK: - Navigation
    
//    func mainNavigationController() -> DLHamburguerNavigationController {
//        return self.storyboard?.instantiateViewControllerWithIdentifier("MainNavigationController") as! DLHamburguerNavigationController
//    }


}
