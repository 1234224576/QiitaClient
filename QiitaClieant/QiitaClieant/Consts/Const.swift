//
//  DeviceConst.swift
//  QiitaClieant
//
//  Created by 曽和修平 on 2015/07/24.
//  Copyright (c) 2015年 曽和修平. All rights reserved.
//

import Foundation
import UIKit

final class Const {
    let osName          = "iOS"
    lazy var osVersion  = UIDevice.currentDevice().systemVersion
    lazy var appVersion = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    lazy var appName    = NSBundle.mainBundle().infoDictionary?["CFBundleName"] as? String ?? ""
    lazy var appId      = NSBundle.mainBundle().infoDictionary?["CFBundleIdentifier"] as? String ?? ""
    // 定数といいつつvarじゃないかとツッコまれそうですが、lazy let は書けないので苦し紛れに。。。
    
    // NOTE: クラスインスタンスの作成を避けたい場合
    static let hoge = "bar"
    
   
    var spec: String {
        return join("/", [self.osName, self.osVersion, self.appVersion])
    }
    
    let baseApiUrlString = "https://qiita.com/api/v1/" //QiitaAPIのbaseURL
    let priveteAccessToken = "11bf1797be2450ed498fa7e773f8ecb836f10929";//Qiitaから発行された個人用トークン
    
    
}