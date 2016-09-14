//
//  UserRegistrationViewController.swift
//  Clinical Handover
//
//  Created by Saurabh Sikka on 11/09/16.
//  Copyright (c) 2016 Saurabh Sikka. All rights reserved.
//

import UIKit

class UserRegistrationViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPassTextField: UITextField!
    
    
    @IBAction func backToLoginPage(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func registerUser(sender: UIButton) {
        
        var userName: String = usernameTextField.text!
        var password: String = passwordTextField.text!
        var repeatPass: String = repeatPassTextField.text!
        
        // check all fields
        if (usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty || repeatPassTextField.text!.isEmpty) {
            displayAlertMessage("All fields are required")
            return
        }
        
        // check passwords match
        if password != repeatPass {
            displayAlertMessage("Passwords do not match")
            return
        }
        
        // Store Data
        var myURL = NSURL(string: "http://einthoven.local/userRegister.php")
        let request = NSMutableURLRequest(URL: myURL!)
        request.HTTPMethod = "POST"
        let postString = "Login=\(userName)&Password=\(password)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            if error != nil {
                print("Error is \(error)")
                return
            }
            
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary
            
            if let parseJSON = json {
                var resultValue = parseJSON["status"] as! String!
                print("result is \(resultValue)")
                
                var isUserRegistered: Bool = false
                if resultValue == "Success" { isUserRegistered = true }
                var messageToDisplay: String = parseJSON["message"] as! String!
                if !isUserRegistered {
                    messageToDisplay = parseJSON["message"] as! String!
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        // confirmation message
                        var confAlert = UIAlertController(title: "Confirmed!", message: "Registration successful", preferredStyle: UIAlertControllerStyle.Alert)
                        var okayAction = UIAlertAction(title: "Thanks!", style: UIAlertActionStyle.Default, handler: nil)
                        self.presentViewController(confAlert, animated: true, completion: nil)
                    })
                }
            }
        }
        task.resume()
    }
    
    func displayAlertMessage(message: String) {
        var myAlert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        var okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }

        
        
}
