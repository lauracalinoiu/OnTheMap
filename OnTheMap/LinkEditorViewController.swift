//
//  LinkEditorViewController.swift
//  OnTheMap
//
//  Created by Laura Calinoiu on 15/10/15.
//  Copyright © 2015 3Smurfs. All rights reserved.
//

import UIKit
import MapKit

class LinkEditorViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var latitude: Double = 0
    var longitude: Double = 0
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initialLocation = CLLocation(latitude: latitude, longitude: longitude)
        centerMapOnLocation(initialLocation)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title = "Me"
        mapView.addAnnotation(annotation)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}
