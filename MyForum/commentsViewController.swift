//
//  commentsViewController.swift
//  MyForum
//
//  Created by Anya Gerasimchuk on 1/20/16.
//  Copyright © 2016 Anya Gerasimchuk. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class commentsViewController: PFQueryTableViewController, NSFetchedResultsControllerDelegate{
    
    //var fcomment = [FavoriteComment]()

    
    lazy var sharedContext: NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    lazy var scratchContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext()
        context.persistentStoreCoordinator = CoreDataStackManager.sharedInstance().persistentStoreCoordinator
        return context
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let user = PFUser.currentUser() {
            print("user is: \(user)")
            if user.authenticated {
                print("this user is authenticated: \(user.authenticated)")
                //Sequge with identifier will work only if we embed in navigator
                //self.performSegueWithIdentifier(self.tableViewWallSegue, sender: nil)
                
                
                
                
            }else{
                print("User cannot login")
                
            }

        }
        
        print("Saved in view DID LOad is : \(GlobalVariables.sharedManager.saved)")
        self.tableView.estimatedRowHeight = 500
        self.tableView.rowHeight = UITableViewAutomaticDimension

        
    }
    
    override func viewWillAppear(animated: Bool) {
        loadObjects()
    }
    
    override func queryForTable() -> PFQuery {
        let query = ForumComment.query()
        return query!
    }
    
    //USE THIS IF YOU WANT TO GO BACK MODALLY. CURRENTLY WE ARE USING NAVIGATION
    /*
    @IBAction func backHome(sender: AnyObject) {
        var controller = HomeViewController()
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        
        self.presentViewController(controller, animated: true, completion: nil)
    }
*/
  

    //TABLE DELEGATE METHODS
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell? {

        
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentPostCell", forIndexPath: indexPath) as! commentsTableViewCell

        //print("saved before check: \(GlobalVariables.sharedManager.saved)")
        //print("indexpath is: \(indexPath.row)")

        
        if (GlobalVariables.sharedManager.saved.count) == indexPath.row{
            GlobalVariables.sharedManager.saved.insert(false, atIndex: indexPath.row)
            print("Saved globallry: \(GlobalVariables.sharedManager.saved)")
        
        }
        
        let commentPost = object as! ForumComment
        
        cell.titleLable.text = commentPost.title
        cell.commentText.text = commentPost.comment
        cell.userLabel.text = commentPost.user.username
        return cell
    }
    


    //https://github.com/ParsePlatform/ParseUI-iOS/blob/master/ParseUIDemo/Swift/CustomViewControllers/ProductTableViewController/CustomProductTableViewController.swift
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
     
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {

        }

        
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentPostCell", forIndexPath: indexPath) as! commentsTableViewCell

        let commentPost = objects?[indexPath.row] as! ForumComment

        //print("what is saved: \(GlobalVariables.sharedManager.saved)")
        
        if (GlobalVariables.sharedManager.saved[indexPath.row] ){
            var savedAlert = UIAlertView()
            savedAlert.title = "Entry Saved Previously!"
            savedAlert.addButtonWithTitle("OK")
            savedAlert.show()
        }else{

            var savedAlert = UIAlertView()
            savedAlert.title = "Entry Saved!"
            savedAlert.addButtonWithTitle("OK")
            savedAlert.show()
            
            
            GlobalVariables.sharedManager.saved[indexPath.row] = true
            
            var userValue:String? = commentPost.user.username! as! AnyObject? as? String!
            
            print("this is the user: \(userValue)")
            //print("user value is now: \(commentPost.valueForKey("user")!)")
            
            var commentDictionary = [String: AnyObject]()
            commentDictionary[FavoriteComment.Keys.Comment] = commentPost.valueForKey("comment")
            commentDictionary[FavoriteComment.Keys.Title] = commentPost.valueForKey("title")
            commentDictionary[FavoriteComment.Keys.User] = userValue
            
            //add the new comment to the CoreData object and save
            let favoriteComment = FavoriteComment(dictionary: commentDictionary, context: self.sharedContext)
            
            print("favoriteComment: \(favoriteComment.comment)")
            CoreDataStackManager.sharedInstance().saveContext()

        }

        //print("Saved count is this: \(GlobalVariables.sharedManager.saved)")
    }
    

    @IBAction func LogoutPressed(sender: AnyObject) {
        PFUser.logOut()
        
        var controller = LoginViewController()
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        
        presentViewController(controller, animated: true, completion: nil)    }
}

