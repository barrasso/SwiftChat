//
//  UserTableViewController.swift
//  SwiftChat
//
//  Created by Mark on 1/20/15.
//  Copyright (c) 2015 MEB. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // user arrays
    var userArray = [String]()
    var sortedUserArray = [String]()
    
    // selected recipient
    var selectedRecipient = 0;
    
    // MARK: - View Initialization
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // query for other users
        var query = PFUser.query()
        query.whereKey("username", notEqualTo: PFUser.currentUser().username)
        
        // synchronous query
        var users = query.findObjects()
        
        for user in users {
            // add usernames to user array
            userArray.append(user.username)
            
            // update table view
            tableView.reloadData()
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        // set the recipient number
        selectedRecipient = indexPath.row
        
        // call image choosing method
        chooseImage(self)
    }
    
    // MARK: Image Actions
    
    @IBAction func chooseImage(sender: AnyObject)
    {
        // init picker controller
        var image = UIImagePickerController()
        
        // set delegate
        image.delegate = self
        
        // access photo library
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        // allows user to edit picture
        image.allowsEditing = false
        
        // present the picker controller
        self.presentViewController(image, animated: true, completion: nil)
    }

    // MARK: Image Picker Delegate Functions
    
    // user did finishing picking an image
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!)
    {
        NSLog("Picked Image")
        
        // close image picker
        self.dismissViewControllerAnimated(true, completion: nil)
        
        // upload to parse
        var imageToSend = PFObject(className:"Image")
        imageToSend["photo"] = PFFile(name: "photo.jpg", data: UIImageJPEGRepresentation(image, 0.5))
        imageToSend["senderUsername"] = PFUser.currentUser().username
        imageToSend["recipientUsername"] = sortedUserArray[selectedRecipient]
        imageToSend.saveInBackgroundWithBlock {
            (success: Bool!, error: NSError!) -> Void in
            
            if success == false {
                // failed sending image
                NSLog("Error: %@", error)
                self.displayAlert("Could Not Send Image", error: "Please try again later.")
            } else {
                // successfully sent
                self.displayAlert("Image Sent", error: "Your image has been sent successfully!")
            }
        }
    }
    
    // MARK: Alert Functions
    
    func displayAlert(title:String, error:String)
    {
        // display error alert
        var errortAlert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        errortAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
            // close popup and do nothing
        }))
        
        self.presentViewController(errortAlert, animated: true, completion: nil)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "logoutSegue") {
            PFUser.logOut()
        }
    }
}
