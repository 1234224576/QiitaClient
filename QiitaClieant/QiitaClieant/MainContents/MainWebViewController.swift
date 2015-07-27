//
//  MainWebViewController.swift
//  QiitaClieant
//
//  Created by 曽和修平 on 2015/07/25.
//  Copyright (c) 2015年 曽和修平. All rights reserved.
//

import UIKit
import WebKit
class MainWebViewController: UIViewController,UIWebViewDelegate{
    
    var url = "http://iphone-tora.sakura.ne.jp/uiwebview.html"
    
    @IBOutlet weak var webview: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.webview.delegate = self
        self.webview.scrollView.showsHorizontalScrollIndicator = false
        
       
        
        if let u =  NSURL(string: self.url){
            self.webview.loadRequest(NSURLRequest(URL: u))
        }
    }
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
