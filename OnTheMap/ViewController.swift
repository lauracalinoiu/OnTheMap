//
//  ViewController.swift
//  OnTheMap
//
//  Created by Laura Calinoiu on 30/09/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var debugLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugLabel.hidden = true
        
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
    
    func printDebugMessage(message: String){
        dispatch_async(dispatch_get_main_queue()){
            self.debugLabel.hidden = false
            self.debugLabel.text = message
        }
    }
    
    @IBAction func onLoginPressed(sender: UIButton) {
        if allFieldsAreValid(){
            UdacityAPIClient.sharedInstance().authenticateOnUdacity(emailTextField.text!, password: passwordTextField.text!){ success, error in
                guard error == nil else{
                    self.printDebugMessage(error!)
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
    
    func allFieldsAreValid() -> Bool{
        guard emailTextField.text != nil || emailTextField.text != "" else{
            printDebugMessage("Complete email field")
            return false
        }
        guard passwordTextField.text != nil || emailTextField.text != "" else{
            printDebugMessage("Complete password field")
            return false
        }
        return true
    }
    
    @IBAction func onSignUpPressed(sender: UIButton) {
    }
    
    @IBAction func onSignInWithFacebookPressed(sender: UIButton) {
    }
    
}

