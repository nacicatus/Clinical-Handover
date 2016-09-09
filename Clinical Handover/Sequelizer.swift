//
//  Sequelizer.swift
//  Clinical Handover
//
//  Created by Saurabh Sikka on 08/09/16.
//  Copyright (c) 2016 Saurabh Sikka. All rights reserved.
//

import Foundation

protocol SequelizerProtocol: class {
    func itemsDownloaded(items: NSArray)
}

class Sequelizer: NSObject, NSURLSessionDelegate {
    //properties
    weak var delegate: SequelizerProtocol!
    var data : NSMutableData = NSMutableData()
    let websiteBaseURL: String = "http://einthoven.local/"
    var urlPath: String = String()
    
    func phpQueryFile(filename: String) -> String {
        urlPath = websiteBaseURL + filename
        return urlPath
    }
    
    
    func downloadItems() {
        
        phpQueryFile("service.php")
        
        let url: NSURL = NSURL(string: urlPath)!
        var session: NSURLSession!
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        let task = session.dataTaskWithURL(url)
        
        task.resume()
        
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        self.data.appendData(data);
        
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if error != nil {
            print("Failed to download data")
        } else {
            print("Data downloaded")
            self.parseJSON()
        }
        
    }
    
    func parseJSON() {
        
        var jsonResult: NSMutableArray = NSMutableArray()
        var someErrorPointer = NSErrorPointer()
        
        if let result: AnyObject = NSJSONSerialization.JSONObjectWithData(self.data, options: NSJSONReadingOptions.AllowFragments, error: someErrorPointer)  {
            jsonResult = result as! NSMutableArray
        }
        
        
        var jsonElement: NSDictionary = NSDictionary()
        let consultants: NSMutableArray = NSMutableArray()
        
        for(var i = 0; i < jsonResult.count; i++)
        {
            
            jsonElement = jsonResult[i] as! NSDictionary
            
            let consultant = ConsultantModel()
            
            //the following insures none of the JsonElement values are nil through optional binding
            if let name = jsonElement["Consultant"] as? String,
                let department = jsonElement["Department"] as? String
            {
                consultant.name = name
                consultant.department = department
            }
            
            consultants.addObject(consultant)
            
        }
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            self.delegate.itemsDownloaded(consultants)
            
        })
    }

}