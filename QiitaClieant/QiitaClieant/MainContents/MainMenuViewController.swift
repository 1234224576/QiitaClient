//
//  MainMenuViewController.swift
//  QiitaClieant
//
//  Created by 曽和修平 on 2015/07/25.
//  Copyright (c) 2015年 曽和修平. All rights reserved.
//

import UIKit

class MainMenuViewController: MenuTableBaseViewController ,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.title = "あおい"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        self.tableView.registerNib(UINib(nibName: "MainArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "MainArticleTableViewCell")
        // Do any additional setup after loading the view.
        
    }
    //MARK: -UITableViewDelegate,Datasorce
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MainArticleTableViewCell", forIndexPath: indexPath) as! MainArticleTableViewCell
        if(indexPath.row % 2 == 0){
            cell.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        }else{
            cell.backgroundColor = UIColor.whiteColor()
        }
//        if let json = self.responseJsonData{
////            if json[indexPath.row] != nil{
////                cell.titleLabel.text = json[indexPath.row]["title"].string
////                cell.nameLabel.text = json[indexPath.row]["media"].string
////                cell.dateLabel.text = publishedStringToDate(json[indexPath.row]["published"].string!)
////                cell.url = json[indexPath.row]["link"].string
////                cell.articleId = json[indexPath.row]["id"].string?.toInt()
//            }
//        }
        return cell
    }
//    func scrollViewDidScroll(scrollView: UIScrollView) {
////        if self.tableView.contentOffset.y >= self.tableView.contentSize.height - self.tableView.bounds.size.height{
////            if self.isLoading{
////                return
////            }
////            self.page+=1
////            self.loadArticle()
////        }
//    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let json = self.responseJsonData{
//            return min(self.page * kOnceLoadArticle,json.count)
//        }
//        return self.page * kOnceLoadArticle
        return 100;
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openSideMenu(){
        self.sidePanelController.showLeftPanelAnimated(true)
    }

    func setupNavigationBar(){
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 122.0/255.0, green: 188.0/255.0, blue: 46.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = .Default
        let menuButton = UIBarButtonItem(image:UIImage(named: "icon_menu")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: .Plain, target: self, action: "openSideMenu")
        self.navigationItem.leftBarButtonItem = menuButton
    }


}
