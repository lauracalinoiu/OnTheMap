//
//  LinkEditorViewController.swift
//  OnTheMap
//
//  Created by Laura Calinoiu on 15/10/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import UIKit
import MapKit

class LinkEditorViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var latitude: Double = 0
    var longitude: Double = 0
    var mapString: String = ""
    let regionRadius: CLLocationDistance = 1000
    @IBOutlet weak var mediaURL: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initialLocation = CLLocation(latitude: latitude, longitude: longitude)
        centerMapOnLocation(initialLocation)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title = "Me"
        mapView.addAnnotation(annotation)
        
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
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func onSubmitPressed(sender: UIButton) {
        if ParseAPIClient.sharedInstance().doOverwrite{
            let studentLocation = ParseAPIClient.sharedInstance().studentLocation!
            print("get student location ")
            
            studentLocation.latitude = latitude
            studentLocation.longitude = longitude
            studentLocation.mediaURL = mediaURL.text!
            studentLocation.mapString = mapString
            
            ParseAPIClient.sharedInstance().updateStudentLocation(studentLocation){ success, error in
                guard error == nil else{
                    self.alertMessage(error)
                    return
                }
                
                print("Overwritten")
            }
        } else {
           
             UdacityAPIClient.sharedInstance().getPublicUserData(){ studentLocation, error in
                guard error == nil else{
                    self.alertMessage(error!)
                    return
                }
                let studentLocationComplete = studentLocation
                ParseAPIClient.sharedInstance().postStudentLocation(studentLocationComplete){ success, error in
                    guard error == nil else{
                        self.alertMessage(error)
                        return
                    }
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
