//
//  ViewController.swift
//  OnTheMap
//
//  Created by Laura Calinoiu on 30/09/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var debugLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugLabel.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func printDebugMessage(message: String){
        debugLabel.hidden = false
        debugLabel.text = message
    }
    
    @IBAction func onLoginPressed(sender: UIButton) {
        guard emailTextField.text != nil || emailTextField.text != "" else{
            printDebugMessage("Complete email field")
            return
        }
        
        guard passwordTextField.text != nil || emailTextField.text != "" else{
            printDebugMessage("Complete password field")
            return
        }
        
        UdacityAuth.sharedInstance().makeRequestToUdacity(emailTextField.text!, password: passwordTextField.text!)
        
    }

    @IBAction func onSignUpPressed(sender: UIButton) {
    }
    
    @IBAction func onSignInWithFacebookPressed(sender: UIButton) {
    }
    
}

