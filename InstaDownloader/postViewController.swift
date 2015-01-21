//
//  postViewController.swift
//  InstaDownloader
//
//  Created by Ekrem Doğan on 20.01.2015.
//  Copyright (c) 2015 Ekrem Doğan. All rights reserved.
//

import UIKit

class postViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var imageToPost: UIImageView!
    @IBOutlet var shareText: UITextField!
    
    var photoSelected: Bool = false
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageToPost.image = UIImage(named: "placeholder.png")
        photoSelected = false
        shareText.text = ""
    }
    
    @IBAction func logout(sender: AnyObject) {
        
        PFUser.logOut()
        self.performSegueWithIdentifier("logout", sender: self)
    }
    
    @IBAction func chooseImage(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        imageToPost.image = image
        
        photoSelected = true
    }
    
    @IBAction func postImage(sender: AnyObject) {
        
        var error = ""
        
        if shareText.text == "" {
            
            error = "Please enter a message"
        }
        
        if photoSelected == false {
            
            error = "Please select a photo"
        }
        
        if error != "" {
            
            displayAlert("Cannot post the image", error: error)
        }
        else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var post = PFObject(className: "posts")
            post["title"] = shareText.text
            post["username"] = PFUser.currentUser().username
            
            post.saveInBackgroundWithBlock({ (success: Bool!, error: NSError!) -> Void in
                
                if success == false {
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if let errorString = error.userInfo?["error"] as? NSString {
                        
                        self.displayAlert("Couldn't post the image", error: errorString)
                    }
                    else {
                        
                        self.displayAlert("Couldn't post the image", error: "Something's gone wrong!")
                    }
                }
                else {
                    
                    let imageData = UIImagePNGRepresentation(self.imageToPost.image)
                    let imageFile = PFFile(name: "image.png", data: imageData)
                    
                    post["imageFile"] = imageFile
                    
                    post.saveInBackgroundWithBlock({ (success: Bool!, error: NSError!) -> Void in
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        
                        if success == false {
                            
                            if let errorString = error.userInfo?["error"] as? NSString {
                                
                                self.displayAlert("Couldn't post the image", error: errorString)
                            }
                            else {
                                
                                self.displayAlert("Couldn't post the image", error: "Something's gone wrong!")
                            }
                        }
                        else {
                            self.displayAlert("Done!", error: "Your image has been posted successfully")
                            self.imageToPost.image = UIImage(named: "placeholder.png")
                            self.photoSelected = false
                            self.shareText.text = ""
                        }
                    })
                }
            })
        }
    }
    
    func displayAlert (title: String, error: String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
