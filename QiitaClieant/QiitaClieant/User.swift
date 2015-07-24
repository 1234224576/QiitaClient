//
//  User.swift
//  QiitaClieant
//
//  Created by 曽和修平 on 2015/07/24.
//  Copyright (c) 2015年 曽和修平. All rights reserved.
//

import Foundation
import UIKit

final class User{
    static let sharedUser = User()
    
    var userName : String = ""
    
    var url_name : String{
        get{
            return NSUserDefaults.standardUserDefaults().objectForKey("url_name") as! String
        }
        set(newValue){
            NSUserDefaults.standardUserDefaults().setObject(newValue as String, forKey: "url_name")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    var password : String {
        get{
            return NSUserDefaults.standardUserDefaults().objectForKey("password") as! String
        }
        set(newValue){
            NSUserDefaults.standardUserDefaults().setObject(newValue as String, forKey: "password")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    var token = ""
}