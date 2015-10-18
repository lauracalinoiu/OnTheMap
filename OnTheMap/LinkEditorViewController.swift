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

    func updateStudentLocationObject(studentLocation: DBStudentLocation) {
        studentLocation.latitude = latitude
        studentLocation.longitude = longitude
        studentLocation.mediaURL = mediaURL.text!
        studentLocation.mapString = mapString
    }
    
    
    func toTabBarView(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbarController = storyboard.instantiateViewControllerWithIdentifier("TabBarController")
        dispatch_async(dispatch_get_main_queue()){
            self.presentViewController( tabbarController, animated: true, completion: nil)
        }
    }
    
    func updateParseWithNewValues(){
        let studentLocation = ParseAPIClient.sharedInstance().studentLocation!
        updateStudentLocationObject(studentLocation)
        
        ParseAPIClient.sharedInstance().updateStudentLocation(studentLocation){ success, error in
            guard error == nil else{
                self.alertMessage(error)
                return
            }
            self.toTabBarView()
        }
    }
    @IBAction func onSubmitPressed(sender: UIButton) {
        if ParseAPIClient.sharedInstance().doOverwrite{
            updateParseWithNewValues()
        } else {
             UdacityAPIClient.sharedInstance().getPublicUserData(){ studentLocation, error in
                guard error == nil else{
                    self.alertMessage(error!)
                    return
                }
                ParseAPIClient.sharedInstance().postStudentLocation(studentLocation){ success, error in
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
