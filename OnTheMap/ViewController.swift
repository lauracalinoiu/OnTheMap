//
//  ViewController.swift
//  OnTheMap
//
//  Created by Laura Calinoiu on 30/09/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var debugLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityWeel: UIActivityIndicatorView!
    @IBOutlet weak var facebookLoginButton: UIButton!
    
    let readPermissions = ["public_profile", "email", "user_friends"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugLabel.hidden = true
        loginButton.enabled = true
        activityWeel.hidden = true
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func showActivityWeel(){
        self.activityWeel.hidden = false
        self.activityWeel.startAnimating()
    }
    
    func hideActivityWeel(){
        self.activityWeel.stopAnimating()
        self.activityWeel.hidden = true
    }
    
    
    func allFieldsAreValid() -> Bool{
        guard emailTextField.text != nil && emailTextField.text != "" else{
            alertMessage("Complete email field")
            emailTextField.becomeFirstResponder()
            return false
        }
        guard passwordTextField.text != nil && passwordTextField.text != "" else{
            alertMessage("Complete password field")
            passwordTextField.becomeFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func onLoginPressed(sender: UIButton) {
        dismissKeyboard()
        debugLabel.hidden = true
        
        if allFieldsAreValid(){
            
            loginButton.enabled = false
            self.showActivityWeel()
            
            UdacityAPIClient.sharedInstance().authenticateOnUdacity(emailTextField.text!, password: passwordTextField.text!){ success, error in
                guard error == nil else{
                    self.alertMessage(error!)
                    return
                }
                if success{
                    let controller = self.storyboard!.instantiateViewControllerWithIdentifier("OnMapTabController") as! UITabBarController
                    dispatch_async(dispatch_get_main_queue()){
                        self.presentViewController(controller, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func onSignUpPressed(sender: UIButton) {
        if let openLink = NSURL(string : UdacityAPIClient.Constant.SignInUdacityURL){
            UIApplication.sharedApplication().openURL(openLink)
        }
    }
    
    @IBAction func onLoginWithFacebookPressed(sender: UIButton) {
        
        let fbManager = FBSDKLoginManager()
        fbManager.logInWithReadPermissions(readPermissions, fromViewController: self){ result, error in
            if ((error) != nil){
                print(error.description)
                self.alertMessage("Login with facebook went wrong, try using credentials from Udacity!")
            }else if result.isCancelled {
                print("result is cancelled")
                self.alertMessage("Login with facebook went wrong, try using credentials from Udacity!")
            }else {
                print(FBSDKAccessToken.currentAccessToken().tokenString)
            }
        }
    }
       
}

extension ViewController{
    
    func alertMessage(message: String){
        dispatch_async(dispatch_get_main_queue()){
            self.loginButton.enabled = true
            self.hideActivityWeel()
            let alertController = UIAlertController(title: "Error Message", message:
                message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func printDebugMessage(message: String){
        dispatch_async(dispatch_get_main_queue()){
            self.debugLabel.hidden = false
            self.debugLabel.text = message
            self.loginButton.enabled = true
            self.hideActivityWeel()
        }
    }
}


