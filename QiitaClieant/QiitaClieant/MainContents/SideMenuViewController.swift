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

enum SideMenu:Int{
    case AllFeed
    case MyPost
    case Stock
    case Tags
}

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileLabel: UILabel!
    private var tags:[[String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.userImageView.layer.cornerRadius = CGRectGetHeight(userImageView.frame)/2.0;
        self.userImageView.layer.masksToBounds = true
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerNib(UINib(nibName: "SideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SideMenuTableViewCell")
        self.tableView.registerNib(UINib(nibName: "TagMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "TagMenuTableViewCell")
        
        self.userNameLabel.text = User.sharedUser.url_name
        self.loadUserdata()
        self.loadFollowingTags()
        
    }
    
    func loadUserdata(){
        Alamofire.request(.GET, Const().baseApiUrlString+"users/\(User.sharedUser.url_name)")
            .responseJSON{[weak self] (request, response, json, error) in
                print(request)
            if let weakSelf = self{
                if let j:AnyObject = json{
                    let jsondata = JSON(j)
                    if jsondata["error"] != nil{
                        //取得失敗
                        
                    }else{
                        //取得成功
                        UIImage.loadAsyncFromURL(jsondata["profile_image_url"].string!, callback: {
                            (image: UIImage?) in
                            weakSelf.userImageView.image = image
                        })
                        weakSelf.profileLabel.text = jsondata["description"].string!
                    }
                }
            }
        }
    }
    
    func loadFollowingTags(){
        Alamofire.request(.GET, Const().baseApiUrlString+"users/\(User.sharedUser.url_name)/following_tags")
        .responseJSON{[weak self] (request, response, json, error) in
            if let weakSelf = self{
                if let j:AnyObject = json{
                    let jsondata = JSON(j)

                    if jsondata["error"] != nil{
                        //取得失敗
                        print(jsondata)
                    }else{
                        //取得成功
                        for (index: String, subJson: JSON) in jsondata {
                            let data:[String] = [subJson["name"].string!,subJson["icon_url"].string!]
                            weakSelf.tags.append(data)
                        }
                        weakSelf.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func tapProfileButton(sender: AnyObject) {
        let alert = UIAlertController(title: "ログアウト", message: "ログアウトしますか？", preferredStyle: .Alert)
        let yes = UIAlertAction(title: "YES", style: UIAlertActionStyle.Default){(_) in
            User.sharedUser.cleanUserData()
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let controller: LoginViewController = storyboard.instantiateInitialViewController() as! LoginViewController
            self.presentViewController(controller, animated: true, completion: nil)
        }
        let no = UIAlertAction(title: "NO", style: .Cancel, handler: nil)
        alert.addAction(no)
        alert.addAction(yes)
        dispatch_async(dispatch_get_main_queue()){
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDelegate&DataSource methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 3
        }
        return self.tags.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("SideMenuTableViewCell", forIndexPath: indexPath) as! SideMenuTableViewCell
            cell.selectionStyle = .None
            switch indexPath.row{
                case SideMenu.AllFeed.rawValue:
                    cell.menuTitleLabel.text = "フィード"
                    cell.menuImageView.image = UIImage(named: "user")
                case SideMenu.MyPost.rawValue:
                    cell.menuTitleLabel.text = "自分の投稿"
                    cell.menuImageView.image = UIImage(named: "copy file")
                case SideMenu.Stock.rawValue:
                    cell.menuTitleLabel.text = "ストックした投稿"
                    cell.menuImageView.image = UIImage(named: "folder")
                default:
                    print("error")
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("TagMenuTableViewCell", forIndexPath: indexPath) as! TagMenuTableViewCell
            //タグ別
            let tagdata = self.tags[indexPath.row]
            cell.tagNameLabel.text = tagdata[0]
            UIImage.loadAsyncFromURL(tagdata[1], callback: {
                (image: UIImage?) in
                cell.tagImageView.image = image
            })
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 70.0
        }
        return 40.0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "タグ別"
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0){
            return 0
        }else{
            return 30.0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var dic:Dictionary<String,AnyObject> = [:]
        if indexPath.section == 0{
            switch indexPath.row{
            case SideMenu.AllFeed.rawValue:
                dic["mode"] = SideMenu.AllFeed.rawValue
            case SideMenu.MyPost.rawValue:
                dic["mode"] = SideMenu.MyPost.rawValue
            case SideMenu.Stock.rawValue:
                dic["mode"] = SideMenu.Stock.rawValue
            default:
                break
            }
        }else{
            //タグ別
            dic["tag"] = self.tags[indexPath.row][0]
        }
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "SideMenuNotification", object: self, userInfo: dic))
        self.sidePanelController.showCenterPanelAnimated(true)
        self.tableView.reloadData()
    }
}
