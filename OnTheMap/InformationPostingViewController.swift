//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Laura Calinoiu on 13/10/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import UIKit
import CoreLocation

class InformationPostingViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFieldLocation: UITextField!
    let errorFromGeocoder = "Geocoder could not find location!"
    
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
  
    @IBAction func findOnTheMapPressed(sender: UIButton) {
        CLGeocoder().geocodeAddressString(textFieldLocation.text!){ placemarks, error in
            guard error==nil else{
                self.alertMessage(self.errorFromGeocoder)
                return
            }
            if let placemark = placemarks?[0] {
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let linkEditorVC = storyboard.instantiateViewControllerWithIdentifier("LinkEditorVC") as! LinkEditorViewController
                linkEditorVC.latitude = (placemark.location?.coordinate.latitude)!
                linkEditorVC.longitude = (placemark.location?.coordinate.longitude)!
                linkEditorVC.mapString = self.textFieldLocation.text!
                dispatch_async(dispatch_get_main_queue()){
                    self.presentViewController(linkEditorVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    func alertMessage(message: String){
        dispatch_async(dispatch_get_main_queue()){
            let alertController = UIAlertController(title: "Error Message", message:
                message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}
