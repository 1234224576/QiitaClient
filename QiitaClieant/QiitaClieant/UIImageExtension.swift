//
//  UIImageExtension.swift
//  QiitaClieant
//
//  Created by 曽和修平 on 2015/07/30.
//  Copyright (c) 2015年 曽和修平. All rights reserved.
//

import Foundation
extension UIImage {
    class func loadAsyncFromURL(urlString: String, callback: (UIImage?) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let url = NSURL(string: urlString)
            var err: NSError?
            let imageData = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)
            var image: UIImage?
            if let _data = imageData {
                image = UIImage(data: _data)
                
                dispatch_async(dispatch_get_main_queue(), {
                    callback(image)
                })
            }
        })
    }
}
