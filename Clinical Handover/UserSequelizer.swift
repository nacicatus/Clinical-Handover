//
//  UserSequelizer.swift
//  Clinical Handover
//
//  Created by Saurabh Sikka on 09/09/16.
//  Copyright (c) 2016 Saurabh Sikka. All rights reserved.
//

import Foundation
//
protocol UserSequelizerProtocol: class {
    func userItemsDownloaded(items: NSArray)
}

class UserSequelizer: NSObject, NSURLSessionDelegate {
    //properties
    weak var userDelegate: UserSequelizerProtocol!
    var userData : NSMutableData = NSMutableData()
    
    var urlPath = "http://einthoven.local/user-query.php"
    
    func downloadItems() {
        let url: NSURL = NSURL(string: urlPath)!
        var session: NSURLSession!
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        let task = session.dataTaskWithURL(url)
        task.resume()
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        self.userData.appendData(data);
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if error != nil {
            print("Failed to download user data")
        } else {
            print("User Data downloaded\n")
            self.parseJSON()
            print("JSON parsed!\n")
        }
    }
    
    
    func parseJSON() {
        
        var jsonResult: NSMutableArray = NSMutableArray()
        var someErrorPointer = NSErrorPointer()
        
        if let result: AnyObject = NSJSONSerialization.JSONObjectWithData(self.userData, options: NSJSONReadingOptions.AllowFragments, error: someErrorPointer)  {
            jsonResult = result as! NSMutableArray
        }
        
        var jsonElement: NSDictionary = NSDictionary()
        let users: NSMutableArray = NSMutableArray()
        
        for(var i = 0; i < jsonResult.count; i++)
        {
            jsonElement = jsonResult[i] as! NSDictionary
            let user = User()
            if let loginName = jsonElement["Login"] as? String,
                let realName = jsonElement["Name"] as? String,
                let password = jsonElement["Password"] as? String,
                let userType = jsonElement["User Type"] as? String
            {
                user.loginName = loginName
                user.realName = realName
                user.password = password
                user.userType = userType
            }
            users.addObject(user)
            
        }
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.userDelegate.userItemsDownloaded(users)
            print("user data stored in userItemsDownloaded\n")
        })
    }
    
}