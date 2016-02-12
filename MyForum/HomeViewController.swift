//
//  HomeViewController.swift
//  MyForum
//
//  Created by Anya Gerasimchuk on 2/2/16.
//  Copyright © 2016 Anya Gerasimchuk. All rights reserved.
//

import Foundation

import UIKit
import CoreData

class HomeViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
       
        
        //Check if user exists and logged in
        if let user = PFUser.currentUser() {
            print("user is: \(user)")
            if user.authenticated {
            print("this user is authenticated: \(user.authenticated)")
            }
        }else{
            print("User cannot login")
            var controller = LoginViewController()
            controller = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
            
            presentViewController(controller, animated: true, completion: nil)

        }
        } else {
            print("Internet connection FAILED")
            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
    }

    @IBAction func showForum(sender: AnyObject) {
       /*
        let VC1 = self.storyboard!.instantiateViewControllerWithIdentifier("commentsViewController") as! commentsViewController
let vc = commentsViewController(nibName: "commentsViewController", bundle: nil)
        //self.presentViewController(VC1, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
*/
    }
    @IBAction func showPhotos(sender: AnyObject) {
      /*
        let VC = self.storyboard!.instantiateViewControllerWithIdentifier("photosViewController") as! photosViewController
        self.navigationController!.pushViewController(VC, animated: true)
*/
    }
    @IBAction func logoutNow(sender: AnyObject) {
        PFUser.logOut()
        
        var controller = LoginViewController()
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        
        presentViewController(controller, animated: true, completion: nil)
    }
}