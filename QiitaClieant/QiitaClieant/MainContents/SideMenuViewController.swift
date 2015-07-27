//
//  SideMenuViewController.swift
//  QiitaClieant
//
//  Created by 曽和修平 on 2015/07/27.
//  Copyright (c) 2015年 曽和修平. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    // data
    let segues = ["option 1", "option 2", "option 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerNib(UINib(nibName: "MainArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "MainArticleTableViewCell")
        // Do any additional setup after loading the view.
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
