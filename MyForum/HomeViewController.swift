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
        
        //Check if user exists and logged in
        if let user = PFUser.currentUser() {
            print("user is: \(user)")
            if user.authenticated {
                print("this user is authenticated: \(user.authenticated)")
                //Sequge with identifier will work only if we embed in navigator
                //self.performSegueWithIdentifier(self.tableViewWallSegue, sender: nil)
                
               
                
                
            }else{
                print("User cannot login")
                var controller = LoginViewController()
                controller = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
                
                presentViewController(controller, animated: true, completion: nil)
            }
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