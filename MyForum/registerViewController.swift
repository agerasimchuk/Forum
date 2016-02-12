//
//  registerViewController.swift
//  MyForum
//
//  Created by Anya Gerasimchuk on 1/11/16.
//  Copyright © 2016 Anya Gerasimchuk. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let tableViewWallSegue = "SignupSuccesfulTable"
    
     
    // MARK: - Actions
    @IBAction func signUpPressed(sender: AnyObject) {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
        
        //TODO
        //1
        let user = PFUser()
        
        //2
        user.username = userTextField.text
        user.password = passwordTextField.text
        
        //3
        user.signUpInBackgroundWithBlock { succeeded, error in
            if (succeeded) {
                //The registration was successful, go to the wall
                //self.performSegueWithIdentifier(self.tableViewWallSegue, sender: nil)
                var controller = UINavigationController()
                controller = self.storyboard?.instantiateViewControllerWithIdentifier("navForumController") as! UINavigationController
                
                self.presentViewController(controller, animated: true, completion: nil)
                
            } else if let error = error {
                //Something bad has occurred
                self.showErrorView(error)
            }
        }
        
        
        //If signup sucessful:
        //performSegueWithIdentifier(self.tableViewWallSegue, sender: nil)
        var controller = UINavigationController()
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("navForumController") as! UINavigationController
        
        self.presentViewController(controller, animated: true, completion: nil)
            
        } else {
            print("Internet connection FAILED")
            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
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