//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Laura Calinoiu on 13/10/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import UIKit

class InformationPostingViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textFieldLocation: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldLocation.delegate = self
        
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

}
