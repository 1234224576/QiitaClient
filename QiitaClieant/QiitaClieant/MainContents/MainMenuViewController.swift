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
    var currentMode = SideMenu.AllFeed
    var currentTag = "" //タグモード時のみ参照される
    var isLoading = false
    var isNextPage = true
    private var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.title = "フィード"
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receptionNotificationFromSideMenu:", name: "SideMenuNotification", object: nil)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = true
        
        // Do any additional setup after loading the view.
        
    }
    override func viewDidAppear(animated: Bool) {
        loadNewArticle()
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
        cell.dateLabel.text = "\(article.createdAtInWords)"
        cell.tagsLabel.text = "\(article.tags)"
        UIImage.loadAsyncFromURL(article.userImageUrl, callback: {
            (image: UIImage?) in
            cell.userImageView.image = image
        })
        return cell
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.tableView.contentOffset.y >= self.tableView.contentSize.height - self.tableView.bounds.size.height{
            if self.isLoading{
                return
            }
            if self.isNextPage{
                self.page+=1
                self.loadArticle()
            }
        }
    }

    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count;
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let article = self.articles[indexPath.row]
        let vc : MainWebViewController = storyboard?.instantiateViewControllerWithIdentifier("MainWebViewController") as! MainWebViewController
        print(article.url)
        vc.url = article.url
        vc.articleTitle = article.title
        if let sv = self.splitViewController{
            if sv.collapsed{
                self.showViewController(vc, sender: self)
            }else{
                self.performSegueWithIdentifier("showDetail", sender: self)
            }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let indexPath = self.tableView.indexPathForSelectedRow()
            if let row = indexPath?.row{
                let article = self.articles[row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! MainWebViewController
                controller.url = article.url
                controller.articleTitle = article.title
                controller.navigationItem.leftBarButtonItem = self.splitViewController!.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openSideMenu(){
        self.sidePanelController.showLeftPanelAnimated(true)
    }

    func setupNavigationBar(){
        self.navigationController?.navigationBar.barTintColor = Const().baseColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = .Default
        let menuButton = UIBarButtonItem(image:UIImage(named: "icon_menu")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), style: .Plain, target: self, action: "openSideMenu")
        self.navigationItem.leftBarButtonItem = menuButton
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }
    
    //通知を受け取る
    func receptionNotificationFromSideMenu(notification: NSNotification){
        if let userInfo = notification.userInfo {
            self.page = 1
            self.isNextPage = true
            if let mode = userInfo["mode"] as? Int{
                switch mode{
                case SideMenu.AllFeed.rawValue:
                    self.currentMode = SideMenu.AllFeed
                case SideMenu.MyPost.rawValue:
                    self.currentMode = SideMenu.MyPost
                case SideMenu.Stock.rawValue:
                    self.currentMode = SideMenu.Stock
                default:
                    break
                }

            }else{
                self.currentMode = SideMenu.Tags
                self.currentTag = userInfo["tag"] as! String
            }
            self.loadArticle()
        }
    }
    
    private func loadArticle(){
        SVProgressHUD.show()
        self.isLoading = true
        if self.currentMode != .Tags{
            switch self.currentMode{
            case SideMenu.AllFeed:
                self.loadNewArticle()
            case SideMenu.MyPost:
                self.loadMyPostArticle()
            case SideMenu.Stock:
                self.loadStockArticle()
            default:
                break
            }
        }else{
            //タグ別
            self.loadTagArticle(self.currentTag)
        }
    }

    private func loadNewArticle(){
        Alamofire.request(.GET, Const().baseApiUrlString+"items",parameters: ["page":self.page])
            .responseJSON{ [weak self] (request, response, json, error) in
            if let weakSelf = self{
                print(response)
                if (response?.allHeaderFields["Link"] == nil){
                    weakSelf.isNextPage = false
                }
                
                if let j:AnyObject = json{
                    let jsondata = JSON(j)
                    if jsondata["error"] != nil{
                        //取得失敗
                        weakSelf.technicalError()
                        SVProgressHUD.dismiss()
                        
                    }else{
                        //取得成功
                        weakSelf.title = "フィード"
                        weakSelf.insertArticleData(jsondata)
                    }
                }else{
                    weakSelf.networkError()
                }
            }
        }

    }
    private func loadMyPostArticle(){
        Alamofire.request(.GET, Const().baseApiUrlString+"users/\(User.sharedUser.url_name)/items",parameters: ["page":self.page])
            .responseJSON{[weak self] (request, response, json, error) in
            if let weakSelf = self{
                if (response?.allHeaderFields["Link"] == nil){
                    weakSelf.isNextPage = false
                }
                print(response)
                if let j:AnyObject = json{
                    let jsondata = JSON(j)
                    if jsondata["error"] != nil{
                        //取得失敗
                        weakSelf.technicalError()
                        SVProgressHUD.dismiss()
                    }else{
                        //取得成功
                        weakSelf.title = "自分の記事"
                        weakSelf.insertArticleData(jsondata)
                    }
                }else{
                    weakSelf.networkError()
                }
            }
        }
    }
    private func loadStockArticle(){
        Alamofire.request(.GET, Const().baseApiUrlString+"users/\(User.sharedUser.url_name)/stocks",parameters: ["page":self.page,"per_page":20])
            .responseJSON{[weak self] (request, response, json, error) in
            if let weakSelf = self{
                if (response?.allHeaderFields["Link"] == nil){
                    weakSelf.isNextPage = false
                }
                if let j:AnyObject = json{
                    let jsondata = JSON(j)
                    if jsondata["error"] != nil{
                        //取得失敗
                        weakSelf.technicalError()
                        SVProgressHUD.dismiss()
                    }else{
                        //取得成功
                        weakSelf.title = "ストック"
                        weakSelf.insertArticleData(jsondata)
                    }
                }else{
                    weakSelf.networkError()
                }
            }
        }
    }
    private func loadTagArticle(tag:String){
        Alamofire.request(.GET, Const().baseApiUrlString+"tags/\(tag)/items",parameters: ["page":self.page])
            .responseJSON{[weak self] (request, response, json, error) in
            if let weakSelf = self{
                if (response?.allHeaderFields["Link"] == nil){
                    weakSelf.isNextPage = false
                }
                if let j:AnyObject = json{
                    let jsondata = JSON(j)
                    if jsondata["error"] != nil{
                        //取得失敗
                        weakSelf.technicalError()
                        SVProgressHUD.dismiss()
                    }else{
                        //取得成功
                        weakSelf.title = tag
                        weakSelf.insertArticleData(jsondata)
                    }
                }else{
                    weakSelf.networkError()
                }
            }
        }
    }
    
    private func insertArticleData(jsondata:JSON){
        if self.page == 1{
            articles.removeAll(keepCapacity: false)
        }
        for var i=0;i<jsondata.count;i+=1{
            let article = Article()
            article.title = jsondata[i]["title"].string!
            article.stock = jsondata[i]["stock_count"].int!
            article.username = jsondata[i]["user"]["url_name"].string!
            article.userImageUrl = jsondata[i]["user"]["profile_image_url"].string!
            article.commentNum = jsondata[i]["comment_count"].int!
            article.url = jsondata[i]["url"].string!
            article.tags = createTagsString(jsondata[i]["tags"])
            article.createdAtInWords = self.exchangeCreatedAtInWordsString(jsondata[i]["created_at_in_words"].string!)
            articles.append(article)
        }
        self.isLoading = false
        SVProgressHUD.dismiss()
        self.tableView.reloadData()
    }
    
    private func networkError(){
        let alert = UIAlertController(title: "エラー", message: "ネットワークに接続されていないか、何らかの障害のためデータの読み込みに失敗しました。", preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(cancel)
        dispatch_async(dispatch_get_main_queue()){
            self.presentViewController(alert, animated: true, completion: nil)
        }
    
    }
    private func technicalError(){
        let alert = UIAlertController(title: "エラー", message: "APIのレスポンスが上限に達したため記事データを読みこめません。暫くしてから再度接続をお願いします。", preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(cancel)
        dispatch_async(dispatch_get_main_queue()){
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func createTagsString(tagsData:JSON)->String{
        print(tagsData)
        var tagstring = ""
        for var i=0;i<tagsData.count;i+=1{
            tagstring += tagsData[i]["name"].string!
            tagstring += " "
        }
        return tagstring
    }
    
    func exchangeCreatedAtInWordsString(createdAtInWords:String)->String{
        var resultword = createdAtInWords
        resultword = resultword.stringByReplacingOccurrencesOfString("about", withString: "", options: nil, range: nil)
        resultword = resultword.stringByReplacingOccurrencesOfString("months", withString: "ヶ月前", options: nil, range: nil)
        resultword = resultword.stringByReplacingOccurrencesOfString("days", withString: "日前", options: nil, range: nil)
        resultword = resultword.stringByReplacingOccurrencesOfString("hours", withString: "時間前", options: nil, range: nil)
        resultword = resultword.stringByReplacingOccurrencesOfString("minutes", withString: "分前", options: nil, range: nil)
        resultword = resultword.stringByReplacingOccurrencesOfString("month", withString: "ヶ月前", options: nil, range: nil)
        resultword = resultword.stringByReplacingOccurrencesOfString("day", withString: "日前", options: nil, range: nil)
        resultword = resultword.stringByReplacingOccurrencesOfString("hour", withString: "時間前", options: nil, range: nil)
        resultword = resultword.stringByReplacingOccurrencesOfString("minute", withString: "分前", options: nil, range: nil)
        resultword = resultword.stringByReplacingOccurrencesOfString("over", withString: "", options: nil, range: nil)
        resultword = resultword.stringByReplacingOccurrencesOfString("years", withString: "年前", options: nil, range: nil)
        resultword = resultword.stringByReplacingOccurrencesOfString("year", withString: "年前", options: nil, range: nil)
        return resultword
    }
    
    
}
