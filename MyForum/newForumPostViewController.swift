//
//  newForumPostViewController.swift
//  MyForum
//
//  Created by Anya Gerasimchuk on 1/19/16.
//  Copyright © 2016 Anya Gerasimchuk. All rights reserved.
//

//
//  newCommentViewController.swift
//  MyForum
//
//  Created by Anya Gerasimchuk on 1/12/16.
//  Copyright © 2016 Anya Gerasimchuk. All rights reserved.
//

import UIKit

class newForumPostViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate{
    

    @IBOutlet weak var commentTitle: UITextField!
    @IBOutlet weak var saveComment: UIBarButtonItem!
    @IBOutlet weak var commentField: UITextView!

    
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    let PLACEHOLDER_TEXT = "Type your comments here"
    let PLACEHOLDER_TITLE = "Add Title"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveComment.enabled = false
        loadingSpinner.hidden = true
        commentField.delegate = self
        commentField.text = PLACEHOLDER_TEXT
        commentField.textColor = UIColor.lightGrayColor()
        commentTitle.delegate = self
        commentTitle.text = PLACEHOLDER_TITLE
        commentTitle.textColor = UIColor.lightGrayColor()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //print("in Title: \(textField)")
        if textField == commentTitle && textField.text == PLACEHOLDER_TITLE{
            //print("title will be here")
            commentTitle.text = ""
            commentTitle.textColor = UIColor.darkGrayColor()
            
        }

    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {

        if textView == commentField && textView.text == PLACEHOLDER_TEXT {

            commentField.text = ""
            commentField.textColor = UIColor.darkGrayColor()
            
        }

        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {

        //if textView = commentTitle && textView.text.len
        if range.length > 0 {
            
            saveComment.enabled = true
        }
        return true
    }
    
    
    func textViewDidChange(textView: UITextView) {
        if (textView.text.isEmpty) {
            saveComment.enabled = false
        }else{
            saveComment.enabled=true
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


extension newForumPostViewController: UINavigationControllerDelegate {
    
    
    @IBAction func savePost(sender: AnyObject) {
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            //add a loading spinner and animate it
            loadingSpinner.hidden = false
            loadingSpinner.startAnimating()
            
            print("commentValue: \(commentField.text)")
            print("commentTitle: \(commentTitle.text!)")
            print("user: \(PFUser.currentUser()!)")
        
            if (commentField.text.isEmpty) || (commentTitle.text!.isEmpty){
                saveComment.enabled=false
            }else{
                saveComment.enabled = true
                let commentValue = self.commentField.text
                let commentPost = ForumComment(comment: commentValue, title:self.commentTitle.text, user: PFUser.currentUser()!)
        
                commentPost.saveInBackgroundWithBlock { succeeded, error in
                    if succeeded{
                        print("UPLOADED NEW POST")
                        //self.navigationController?.popViewControllerAnimated(true)
                        self.navigationController!.popViewControllerAnimated(true)
                    
                    }else{
                        print("could not save")
    
                        if let errorMessage = error?.userInfo["error"] as? String {
                            self.showErrorView(error!)

                        }
                    }
                }
            }
        } else {
            print("Internet connection FAILED")
            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            self.loadingSpinner.stopAnimating()
            self.loadingSpinner.hidden = true
    }
    
}
}