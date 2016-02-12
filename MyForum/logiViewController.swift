//
//  ViewController.swift
//  MyForum
//
//  Created by Anya Gerasimchuk on 1/11/16.
//  Copyright © 2016 Anya Gerasimchuk. All rights reserved.
////http://www.raywenderlich.com/98831/parse-tutorial-getting-started-web-backends
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let tableViewWallSegue = "LoginSuccesfulTable"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        //Check if user exists and logged in
        if let user = PFUser.currentUser() {
            print("user is: \(user)")
            if user.authenticated {
                print("this user is authenticated: \(user.authenticated)")
                //Sequge with identifier will work only if we embed in navigator
                //self.performSegueWithIdentifier(self.tableViewWallSegue, sender: nil)
                
                var controller = HomeViewController()
                controller = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
                
                presentViewController(controller, animated: true, completion: nil)

               
            }else{
                print("User cannot login")
            }
        }

    }
    
    // MARK: - Actions
    @IBAction func logInPressed(sender: AnyObject) {
        
        PFUser.logInWithUsernameInBackground(userTextField.text!, password: passwordTextField.text!) { user, error in
            if user != nil {
                print("performing taleview segue)")
                //self.performSegueWithIdentifier(self.tableViewWallSegue, sender: nil)
                
                var controller = UINavigationController()
                controller = self.storyboard?.instantiateViewControllerWithIdentifier("navForumController") as! UINavigationController
                
                self.presentViewController(controller, animated: true, completion: nil)

            } else if let error = error {
                //self.showErrorView(error)
                print("Cannot login")
            }

                //self.performSegueWithIdentifier(self.tableViewWallSegue, sender: nil)
        }
        
        
    }
    
    
    func showErrorView(error: NSError) {
        if let errorMessage = error.userInfo["error"] as? String {
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
    }

}

