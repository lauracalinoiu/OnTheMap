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
    
    let completeEmailFieldError = "Complete email field"
    let completePasswordFieldError = "Complete password field"
    let didNotSpecifyExactlyOneCredentialError = "Did not specify exactly one credential!"
    let loginWithFacebookWentWrong = "Login with facebook went wrong, try using credentials from Udacity!"
    
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
            alertMessage(completeEmailFieldError)
            emailTextField.becomeFirstResponder()
            return false
        }
        guard passwordTextField.text != nil && passwordTextField.text != "" else{
            alertMessage(completePasswordFieldError)
            passwordTextField.becomeFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func onLoginWithCredentialsPressed(sender: UIButton) {
        dismissKeyboard()
        debugLabel.hidden = true
        
        guard allFieldsAreValid() else{
            return
        }
        
        loginButton.enabled = false
        self.showActivityWeel()
        
        UdacityAPIClient.sharedInstance().authenticateOnUdacity(emailTextField.text!, password: passwordTextField.text!){ success, error in
            guard error == nil else{
                self.alertMessage(error!)
                return
            }
            if success{
                self.toTheTabBarController()
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
                self.alertMessage(self.loginWithFacebookWentWrong)
            }else if result.isCancelled {
                print("result is cancelled")
                self.alertMessage(self.loginWithFacebookWentWrong)
            }else {
                UdacityAPIClient.sharedInstance().authenticateOnUdacityWithFacebook(FBSDKAccessToken.currentAccessToken().tokenString){ success, error in
                    guard error == nil else{
                        self.alertMessage(error!)
                        return
                    }
                    if success{
                        self.toTheTabBarController()
                    }
                }
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
    
    
    func toTheTabBarController(){
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        dispatch_async(dispatch_get_main_queue()){
            let tabbarController = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
            appDelegate.window?.rootViewController = tabbarController
        }
    }
}


