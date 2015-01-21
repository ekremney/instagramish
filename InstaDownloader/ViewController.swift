//
//  ViewController.swift
//  InstaDownloader
//
//  Created by Ekrem Doğan on 16.01.2015.
//  Copyright (c) 2015 Ekrem Doğan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var secondaryLabel: UILabel!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var alreadyRegistered: UILabel!
    @IBOutlet var signUpToggleButton: UIButton!
    
    var activityIndicator = UIActivityIndicatorView()
    var signUpFlag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(PFUser.currentUser())
    }

    @IBAction func signUp(sender: AnyObject){
        
        if formValidation() == true{
            var user = PFUser()
            user.username = username.text
            user.password = password.text
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            
            if signUpFlag == false {
                
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                PFUser.logInWithUsernameInBackground(user.username, password: user.password) {
                    (user: PFUser!, error: NSError!) -> Void in
                    if user != nil {
                        
                        self.performSegueWithIdentifier("jumpToUserTable", sender: self)
                        println("logged in")
                    } else {
                        
                        if let errorString = error.userInfo?["error"] as? NSString {
                            
                            self.displayAlert("Oops!", error: errorString)
                        }
                        else {
                            
                            self.displayAlert("Oops!", error: "Something's gone wrong!")
                        }
                    }
                }
            }
            else {
            
                user.signUpInBackgroundWithBlock {
                    (succeeded: Bool!, error: NSError!) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if error == nil {
                        // Hooray! Let them use the app now.
                        println("signedUp")
                    } else {
                        
                        if let errorString = error.userInfo?["error"] as? NSString {
                            
                            self.displayAlert("Oops!", error: errorString)
                        }
                        else {
                            
                            self.displayAlert("Oops!", error: "Something's gone wrong!")
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func toggleSignUp(sender: AnyObject) {
        
        if signUpFlag == true {
            
            signUpFlag = false
            secondaryLabel.text = "Use the form below to log in!"
            signUpButton.setTitle("Log In", forState: UIControlState.Normal)
            alreadyRegistered.text = "Not registered?"
            signUpToggleButton.setTitle("Sign Up", forState: UIControlState.Normal)
        }
        else {
            
            signUpFlag = true
            secondaryLabel.text = "Use the form below to sign up!"
            signUpButton.setTitle("Sign Up", forState: UIControlState.Normal)
            alreadyRegistered.text = "Already registered?"
            signUpToggleButton.setTitle("Log In", forState: UIControlState.Normal)
        }
    }

    
    func formValidation() -> Bool  {
        
        var errorFlag = false
        var errorText = ""
        
        if username.text == "" {
            
            errorFlag = true
            errorText = "Please do not leave \"Username\" field empty"
        }
        
        if password.text == "" {
            
            errorFlag = true
            errorText = "Please do not leave \"Password\" field empty"
        }
        
        
        if errorFlag == true {
            
            displayAlert("Oops!", error: errorText)
            return false
        }
        
        return true
    }
    
    func displayAlert(title: String, error: String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if PFUser.currentUser() != nil {
            self.performSegueWithIdentifier("jumpToUserTable", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        self.navigationController?.navigationBarHidden = false
    }
}

