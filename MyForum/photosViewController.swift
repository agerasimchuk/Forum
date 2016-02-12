//
//  commentsViewController.swift
//  MyForum
//
//  Created by Anya Gerasimchuk on 1/13/16.
//  Copyright © 2016 Anya Gerasimchuk. All rights reserved.
//

import Foundation
import UIKit

class photosViewController: PFQueryTableViewController{
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        loadObjects()
    }
    
    override func queryForTable() -> PFQuery {
        let query = ForumPost.query()
        return query!
    }
    
    @IBAction func backHome(sender: AnyObject) {
        var controller = HomeViewController()
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
    

    //table delegate method
    //TABLE DELEGATE METHODS
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell? {

        let cell = tableView.dequeueReusableCellWithIdentifier("ForumPostCell", forIndexPath: indexPath) as! ForumTableViewCell
        
        let forumPost = object as! ForumPost
        cell.postImage.file = forumPost.image
               cell.postImage.loadInBackground(nil) { percent in
            //cell.progre.progress = Float(percent)*0.01
            //print("\(percent)%")

        }
        
        cell.postImage.file = forumPost.image
        cell.postText.text = forumPost.comment
        cell.postLabel.text = forumPost.user.username
        
        
        
      return cell
  }
    
    @IBAction func LogoutPressed(sender: AnyObject) {

        PFUser.logOut()
        
        var controller = LoginViewController()
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        
        presentViewController(controller, animated: true, completion: nil)
        
        //navigationController?.performSegueWithIdentifier("logoutSegue", sender: nil)
        
    }
}

