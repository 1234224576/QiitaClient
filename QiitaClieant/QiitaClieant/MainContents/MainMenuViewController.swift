//
//  MainMenuViewController.swift
//  QiitaClieant
//
//  Created by 曽和修平 on 2015/07/25.
//  Copyright (c) 2015年 曽和修平. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class MainMenuViewController: MenuTableBaseViewController ,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var articles:[Article] = []
    var mode = MenuType.New
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.title = "あおい"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        loadArticle()
        
        // Do any additional setup after loading the view.
        
    }
    //MARK: -UITableViewDelegate,Datasorce
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        self.tableView.registerNib(UINib(nibName: "MainArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "MainArticleTableViewCell\(indexPath.row)")
        let cell = tableView.dequeueReusableCellWithIdentifier("MainArticleTableViewCell\(indexPath.row)", forIndexPath: indexPath) as! MainArticleTableViewCell
        
        if(indexPath.row % 2 == 0){
            cell.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        }else{
            cell.backgroundColor = UIColor.whiteColor()
        }
        let article = articles[indexPath.row]
        cell.titleLabel.text = article.title
        cell.stockLabel.text = "\(article.stock)"
        cell.userNameLabel.text = article.username
        cell.commentLabel.text = "\(article.commentNum)"
        UIImage.loadAsyncFromURL(article.userImageUrl, callback: {
            (image: UIImage?) in
            cell.userImageView.image = image
        })
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
        return articles.count;
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
    
    //LoadArticle
    func loadArticle(){
        switch mode{
            case .New:
                loadNewArticle()
            case .Pop:
                loadPopArticle()
            case .Stock:
                loadStockArticle()
            case .Tag:
                loadTagArticle()
            default:
                break
        }
    }
    private func loadNewArticle(){
        Alamofire.request(.GET, Const().baseApiUrlString+"items")
            .responseJSON{[weak self] (request, response, json, error) in
            if let weakSelf = self{
                if let j:AnyObject = json{
                    let jsondata = JSON(j)
                    if jsondata["error"] != nil{
                        //取得失敗
                        print(jsondata)
                    }else{
                        //取得成功
                        weakSelf.insertArticleData(jsondata)
                    }
                }
            }
        }

    }
    private func loadPopArticle(){
        
    }
    private func loadStockArticle(){
        
    }
    private func loadTagArticle(){
        
    }
    
    private func insertArticleData(jsondata:JSON){

        for var i=0;i<jsondata.count;i+=1{
            let article = Article()
            article.title = jsondata[i]["title"].string!
            article.stock = jsondata[i]["stock_count"].int!
            article.username = jsondata[i]["user"]["url_name"].string!
            article.userImageUrl = jsondata[i]["user"]["profile_image_url"].string!
            article.commentNum = jsondata[i]["comment_count"].int!
            article.url = jsondata[i]["url"].string!
            articles.append(article)
            
            print(jsondata[i]["title"].string!)
            print("\n")
            print(jsondata[i]["user"]["url_name"].string!)
            print("\n")
            
        }
        self.tableView.reloadData()
    }

}
