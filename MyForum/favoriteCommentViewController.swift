//
//  favoriteCommentViewController.swift
//  MyForum
//
//  Created by Anya Gerasimchuk on 1/22/16.
//  Copyright © 2016 Anya Gerasimchuk. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class favoriteCommentsViewController: UITableViewController, NSFetchedResultsControllerDelegate{
    
    var connection: Bool = true
    
        lazy var sharedContext: NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()

    @IBAction func backHome(sender: AnyObject) {
        var controller = HomeViewController()
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
        
        self.presentViewController(controller, animated: true, completion: nil)
    }

    
    lazy var scratchContext: NSManagedObjectContext = {
        var context = NSManagedObjectContext()
        context.persistentStoreCoordinator = CoreDataStackManager.sharedInstance().persistentStoreCoordinator
        return context
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        let fetchRequest = NSFetchRequest(entityName: "FavoriteComment")
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "comment", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        return fetchedResultsController
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
               //tableView.frame = CGRectMake(0.0, <#T##y: CGFloat##CGFloat#>, <#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>)
        tableView.frame = CGRectMake(2.0, 5.0, tableView.frame.size.width, tableView.frame.size.height);
        
        tableView.delegate = self
        
                do {
                    print("performing fetch")
            try fetchedResultsController.performFetch()
                    print("performed fetch")
        } catch {
            print("cannot perform fetch)")
        }
        
        // Step 9: set the fetchedResultsController.delegate = self
        fetchedResultsController.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        

            tableView.reloadData()

    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
                    let commentInfo = self.fetchedResultsController.sections![section]
            print("commentInfor is: \(commentInfo.numberOfObjects)")
            print("fetchedresults: \(fetchedResultsController)")
  
          return commentInfo.numberOfObjects
            }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("Cell")
        let comment = fetchedResultsController.objectAtIndexPath(indexPath) as! FavoriteComment
        print("indexpath: \(indexPath)")
        print("comment first: \(comment)")
        let CellIdentifier = "FavoriteCommentCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! favoriteCommentTableViewCell
        
        cell.fComment.text = comment.comment
        cell.fTitle.text = comment.title
        cell.userLabel.text = comment.user
        
        print("comment is: \(comment.comment)")
        
        return cell
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    
    override func tableView(tableView: UITableView,
        commitEditingStyle editingStyle: UITableViewCellEditingStyle,
        forRowAtIndexPath indexPath: NSIndexPath) {
            
            switch (editingStyle) {
            case .Delete:
                
                // Here we get the actor, then delete it from core data
                let comment = fetchedResultsController.objectAtIndexPath(indexPath) as! FavoriteComment
                sharedContext.deleteObject(comment)
                CoreDataStackManager.sharedInstance().saveContext()
                
            default:
                break
            }
    }
    
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController,
        didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
        atIndex sectionIndex: Int,
        forChangeType type: NSFetchedResultsChangeType) {
            
            switch type {
            case .Insert:
                self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
                
            case .Delete:
                self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
                
            default:
                return
            }
    }
    
    //
    // This is the most interesting method. Take particular note of way the that newIndexPath
    // parameter gets unwrapped and put into an array literal: [newIndexPath!]
    //
    
    func controller(controller: NSFetchedResultsController,
        didChangeObject anObject: AnyObject,
        atIndexPath indexPath: NSIndexPath?,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath?) {
            
            switch type {
            case .Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
                
            case .Delete:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                
            case .Update:
                let cell = tableView.cellForRowAtIndexPath(indexPath!) as! favoriteCommentTableViewCell
                let comment = controller.objectAtIndexPath(indexPath!) as! FavoriteComment
                cell.fComment.text = comment.comment
                
            case .Move:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }


    @IBAction func LogoutPressed(sender: AnyObject) {
        PFUser.logOut()
        
        var controller = LoginViewController()
        controller = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        
        presentViewController(controller, animated: true, completion: nil)
    }
        

}
