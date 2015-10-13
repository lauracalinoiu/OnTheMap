//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Laura Calinoiu on 13/10/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    var studentLocations: [DBStudentLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ParseAPIClient.sharedInstance().getLast100StudentLocation(){ studentLocations, error in
            guard error == nil else{
                self.alertMessage(error!)
                return
            }
            guard studentLocations != nil else{
                print("no locations")
                return
            }
           
            self.studentLocations = studentLocations!
            dispatch_async(dispatch_get_main_queue()){
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = studentLocations[indexPath.row].firstName+" "+studentLocations[indexPath.row].lastName
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let link = studentLocations[indexPath.row].mediaURL
        let app = UIApplication.sharedApplication()
        app.openURL(NSURL(string: link)!)
    }

    func alertMessage(message: String){
        dispatch_async(dispatch_get_main_queue()){
            let alertController = UIAlertController(title: "Error Message", message:
                message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }  
}