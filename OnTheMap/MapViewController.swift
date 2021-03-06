//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Laura Calinoiu on 09/10/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAnnotations()
    }
    
    func loadAnnotations(){
        var annotations = [MKPointAnnotation]()
        ParseAPIClient.sharedInstance().getLast100StudentLocation(){ studentLocations, error in
            guard error == nil else{
                self.alertMessage(error!)
                return
            }
            guard studentLocations != nil else{
                print("no locations")
                return
            }
            for studentLocation in studentLocations!{
                let annotation = MKPointAnnotation()
                let coordinate = CLLocationCoordinate2D(latitude: studentLocation.latitude, longitude: studentLocation.longitude)
                annotation.coordinate = coordinate
                annotation.title = "\(studentLocation.firstName) \(studentLocation.lastName)"
                annotation.subtitle = studentLocation.mediaURL
                
                annotations.append(annotation)
            }
            self.mapView.addAnnotations(annotations)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: (annotationView.annotation!.subtitle!)!)!)
        }
    }
    
    @IBAction func refreshPressed(sender: UIBarButtonItem) {
        loadAnnotations()
    }
    
    @IBAction func newPinPressed(sender: UIBarButtonItem) {
        ParseAPIClient.sharedInstance().studentAlreadyOnTheMap(){ userAlreadyOnMap, errorString in
            guard errorString == nil else{
                self.alertMessage(errorString!)
                return
            }
            if userAlreadyOnMap {
                self.overwriteLocationAlertOnSegue(ParseAPIClient.ErrorString.youAlreadyAreOnTheMap)
            } else {
                self.goToInformationPostingVC()
            }
        }

    }
    
    func goToInformationPostingVC(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let informationPosting = storyboard.instantiateViewControllerWithIdentifier("InformationPostingVC")
        dispatch_async(dispatch_get_main_queue()){
            self.presentViewController( informationPosting, animated: true, completion: nil)
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
    
    func overwriteLocationAlertOnSegue(message: String){
        dispatch_async(dispatch_get_main_queue()){
            let alertController = UIAlertController(title: "Error Message", message:
                message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Overwrite", style: UIAlertActionStyle.Default){ action in
                    ParseAPIClient.sharedInstance().doOverwrite = true
                self.goToInformationPostingVC()
            })
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }

}
