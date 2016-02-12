//
//  newCommentViewController.swift
//  MyForum
//
//  Created by Anya Gerasimchuk on 1/12/16.
//  Copyright © 2016 Anya Gerasimchuk. All rights reserved.
//

import UIKit

class newPhotoViewController: UIViewController, UITextViewDelegate{
    
    @IBOutlet weak var takePhoto: UIToolbar!
    @IBOutlet weak var selectPhoto: UIBarButtonItem!
    @IBOutlet weak var imageToUpload: UIImageView!
    @IBOutlet weak var commentField: UITextView!
    @IBOutlet weak var saveComment: UIBarButtonItem!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    let PLACEHOLDER_TEXT = "Add your comments"
    
    //NEW CODE
    
    override func viewDidLoad() {
    super.viewDidLoad()
    
    saveComment.enabled = false
    commentField.delegate = self
    commentField.text = PLACEHOLDER_TEXT
    commentField.textColor = UIColor.lightGrayColor()
    loadingSpinner.hidden = true
    
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView == commentField && textView.text == PLACEHOLDER_TEXT{
            //print("title will be here")
            commentField.text = ""
            commentField.textColor = UIColor.darkGrayColor()
            
        }

    }


    var username: String?
    
    // MARK: - Actions
    @IBAction func selectPicturePressed(sender: AnyObject) {
        print("Will select the picture now)")
        //Open a UIImagePickerController to select the picture
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        
           }
    
    @IBAction func sendPressed(sender: AnyObject) {
        commentField.resignFirstResponder()
        
        
        //Disable the send button until we are ready
        navigationItem.rightBarButtonItem?.enabled = false
        loadingSpinner.hidden = false
        loadingSpinner.startAnimating()
        
        //TODO: Upload a new picture
        let pictureData = UIImageJPEGRepresentation(imageToUpload.image!, 1.0)
        //let pictureData = UIImagePNGRepresentation(imageToUpload.image!)
        
        //1
        let file = PFFile(name: "image", data: pictureData!)
        
        if Reachability.isConnectedToNetwork() == true {
        file!.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
            if succeeded {
                //2
                self.saveWallPost(file!)
                self.loadingSpinner.hidden = true
            } else if let error = error {
                //3
                self.showErrorView(error)
                self.loadingSpinner.hidden = true

            }
            }, progressBlock: { percent in
                //4
                print("Uploaded: \(percent)%")
        })

        }else {
            print("Internet connection FAILED")
            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            self.loadingSpinner.stopAnimating()
            self.loadingSpinner.hidden = true
            saveComment.enabled = true
        }
        
    }
    
    func saveWallPost(file: PFFile)
    {
        
            print("Internet connection OK")
            let picturePost = ForumPost(image: file, comment: self.commentField.text, user: PFUser.currentUser()! )

            picturePost.saveInBackgroundWithBlock{ succeeded, error in
            if succeeded {
                //3
                self.navigationController?.popViewControllerAnimated(true)
                print("image saved")
            } else {
                //4
                if let errorMessage = error?.userInfo["error"] as? String {
                    self.showErrorView(error!)
                    //print("could not save")
                    
                    self.loadingSpinner.stopAnimating()
                    }
                }
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



extension newPhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        //Place the image in the imageview
        imageToUpload.image = image
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        if imageToUpload.image != nil{
            print("image to upload: \(imageToUpload.image)")
            saveComment.enabled = true
        }else{
            print("image to upload now: \(imageToUpload.image)")
            saveComment.enabled = false
        }
        

    }
    
}



