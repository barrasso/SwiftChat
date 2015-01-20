//
//  ViewController.swift
//  SwiftChat
//
//  Created by Mark on 1/20/15.
//  Copyright (c) 2015 MEB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet var usernameTextField: UITextField!

    // MARK: Actions
    
    @IBAction func signIn(sender: AnyObject)
    {
        // try to log user in
        PFUser.logInWithUsernameInBackground(usernameTextField.text, password:"mypass") {
            (user: PFUser!, error: NSError!) -> Void in
            if user != nil {
                
                // successful login
                println("logged in")
                
                // segue to user table view controller
                self.performSegueWithIdentifier("showUsers", sender: self)
                
            } else {
                
                // try to sign the user up
                var user = PFUser()
                user.username = self.usernameTextField.text
                user.password = "mypass"
                
                user.signUpInBackgroundWithBlock {
                    (succeeded: Bool!, error: NSError!) -> Void in
                    if error == nil {
                        
                        // successful sign up
                        println("signed up")
                        
                        // segue to user table view controller
                        self.performSegueWithIdentifier("showUsers", sender: self)
                        
                    } else {
                        
                        // The login/signup failed
                        NSLog("Error: %@", error)
                    }
                }
            }
        }
    }
    
    // MARK: View Initialization
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool)
    {
        // check if current user is logged in
        if PFUser.currentUser() != nil
        {
            // who is current user
            NSLog("Current User: %@", PFUser.currentUser().username)
            
            // segue to user table view controller
            self.performSegueWithIdentifier("showUsers", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

