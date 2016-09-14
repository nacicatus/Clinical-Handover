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
    
    let webURL: String = "http://einthoven.local/patient-query.php"
    //var urlPath: String = String()
    
   
    func downloadItems() {
        let url: NSURL = NSURL(string: webURL)!
        var session: NSURLSession!
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        // create a URL session with the default configuration,
        session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        let task = session.dataTaskWithURL(url)
        // after we set the task, we call it by its resume method
        task.resume()
        
    }
    
    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        // store the data downloaded from the connection using the PHP file into NSMutableData container locally
        self.data.appendData(data)
        
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if error != nil {
            print("Failed to download patient data")
        } else {
            print("Patient Data downloaded")
            // now parse the data (that was downloaded in JSON format)
            self.parseJSON()
        }
        
    }
    
    func parseJSON() {
        
        // first we create a mutable array
        var jsonResult: NSMutableArray = NSMutableArray()
        // and an error pointer
        var someErrorPointer = NSErrorPointer()
        
        // NSJSONSerialization is used to convert back and forth between Foundation objects and JSON
        if let result: AnyObject = NSJSONSerialization.JSONObjectWithData(self.data, options: NSJSONReadingOptions.AllowFragments, error: someErrorPointer)  {
            // put that result obtained from converting JSON to Foundation into the mutable array we created earlier
            jsonResult = result as! NSMutableArray
        }
        
        // create an instance of NSDictionary
        var jsonElement: NSDictionary = NSDictionary()
        // create a mutable array to hold the final information about the patients
        let patients: NSMutableArray = NSMutableArray()
        
        // now we iterate through the jsonResult array...
        for(var i = 0; i < jsonResult.count; i++)
        {
            // ...and put every element in the array into the dictionary we created earlier
            jsonElement = jsonResult[i] as! NSDictionary
            
            // create an instance of the PatientModel, which is basically a swift version of the rows in the MySQL table
            let patient = PatientModel()
            
            /*the following insures none of the jsonElement values are nil through optional binding
             looking at the dictionary, we refer to the Keys in " " like "Patient Name", pick up the associated Value, and assign it
            to the class instance's property. The Key in " " must be written exactly as it occurs in the MySQL database, because
            it was picked up from there by the NSJSONSerialization we did above
            */
            if let patientName = jsonElement["Patient Name"] as? String,
                let diagnosis = jsonElement["Diagnosis"] as? String
            {
                patient.patientName = patientName
                patient.diagnosis = diagnosis
            }
            // now we append the patient object thus created into the patients array
            patients.addObject(patient)
            
        }
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            // we delegate this Sequelizer class to now handle the protocol we defined earlier, to utilise the patients array
            // in the function itemsDownloaded, so that when we go to the PatientsTableViewController, 
            // we can transfer these into an array locally in that controller, and use it to create a table,
            // with one table cell for each patient
            //
            self.delegate.itemsDownloaded(patients)
        })
    }

}