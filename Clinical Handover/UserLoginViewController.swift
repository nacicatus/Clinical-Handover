//
//  UserLoginViewController.swift
//  Clinical Handover
//
//  Created by Saurabh Sikka on 09/09/16.
//  Copyright (c) 2016 Saurabh Sikka. All rights reserved.
//

import UIKit

class UserLoginViewController: UIViewController, UserSequelizerProtocol {
    
    var userFeedItems: NSArray = NSArray()
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // get all user data from the database first
        let userSequel = UserSequelizer()
        userSequel.userDelegate = self
        userSequel.downloadItems()
    }
    
    // hold the users array in userFeedItems
    func userItemsDownloaded(items: NSArray) {
        userFeedItems = items
    }
    
    @IBAction func loginUser(sender: UIButton) {
        
        let userName = usernameTextField.text!
        let password = passwordTextField.text!
        
        // check no fields are empty
        if (userName.isEmpty || password.isEmpty) {
            displayAlertMessage("All fields are required")
            return
        }
        
        // validate user
        for (var j = 0; j < userFeedItems.count; j++) {
            var randomUser: User = userFeedItems[j] as! User
            if userName == randomUser.loginName! && password == randomUser.password! {
                // Login Success
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn")
                NSUserDefaults.standardUserDefaults().synchronize()
                self.dismissViewControllerAnimated(true, completion: nil)
            } 
        }
        

    }
    
    
    func displayAlertMessage(userMessage: String) {
        var myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
        var okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction)
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    
    
    
}
