//
//  UserTableViewController.swift
//  SwiftChat
//
//  Created by Mark on 1/20/15.
//  Copyright (c) 2015 MEB. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {

    // user arrays
    var userArray = [String]()
    var sortedUserArray = [String]()
    
    // MARK: - View Initialization
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // get users, not current
        var query = PFUser.query()
        query.whereKey("username", notEqualTo: PFUser.currentUser().username)
        
        // synchronous query
        var users = query.findObjects()
        
        for user in users {
            // add usernames to user array
            userArray.append(user.username)
        }
        
        // sort user array alphabetically
        sortedUserArray = userArray.sorted({
            $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending
        })
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table View Data Source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // Return the number of rows in the section.
        return userArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell

        // set cell labels
        cell.textLabel?.text = sortedUserArray[indexPath.row]
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
