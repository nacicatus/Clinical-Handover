//
//  PatientsTableViewController.swift
//  Clinical Handover
//
//  Created by Saurabh Sikka on 09/09/16.
//  Copyright (c) 2016 Saurabh Sikka. All rights reserved.
//

import UIKit

class PatientsTableViewController: UITableViewController, SequelizerProtocol {
    
    // we create an array to hold the patients array
    var feedItems: NSArray = NSArray()
    
    // we create a reference to the TableView inside the Controller object
    @IBOutlet var listTableView: UITableView!
    
    
    
    //    override func viewDidLoad(animated: Bool) {
    //        super.viewDidLoad()
    //        let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn")
    //        if (!isUserLoggedIn) {
    //            self.performSegueWithIdentifier("loginView", sender: self)
    //        }
    //    }
    
    @IBAction func logoutButtonTapped(sender: UIBarButtonItem) {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isUserLoggedIn")
        NSUserDefaults.standardUserDefaults().synchronize()
//        self.performSegueWithIdentifier("loginView", sender: self)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let isUserLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("isUserLoggedIn")
        if (isUserLoggedIn) {
            let sequelizer = Sequelizer()
            sequelizer.delegate = self
            sequelizer.downloadItems()
        } else {
            self.performSegueWithIdentifier("loginView", sender: self)
        }
    }
    

    // hold the patients array in feedItems and list it in the table
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        self.listTableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "patientCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! UITableViewCell
        let item: PatientModel = feedItems[indexPath.row] as! PatientModel
        
        // Configure the cell
        myCell.textLabel?.text = item.patientName
        myCell.detailTextLabel?.text = item.diagnosis
        return myCell
    }
    
    
    
}
