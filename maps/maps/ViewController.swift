//
//  ViewController.swift
//  maps
//
//  Created by Dan Austin on 23/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up values required to use the setRegion function of the map view
        let long = CLLocationDegrees(78.0399773)
        let lat = CLLocationDegrees(27.175244)
        let latDelta = CLLocationDegrees(0.05)
        let longDelta = CLLocationDegrees(0.05)
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        // Set the region to view in map view
        mapView.setRegion(region, animated: true)
        
        // Creating an annotation using the centre coordinate from the map region
        let annotation = MKPointAnnotation()
        annotation.title = "Taj Mahal"
        annotation.subtitle = "Great place!"
        annotation.coordinate =  coordinate
        mapView.addAnnotation(annotation)
        
        // Target is the object containing the function referenced in 'selector'.
        // The syntax addMarker(_:) is to avoid ambiguity where multiple functions with the same name have different param labels
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(addMarker(_:)))
        longPressRecognizer.minimumPressDuration = 2
        mapView.addGestureRecognizer(longPressRecognizer)
    }

    @objc func addMarker(_ recognizer: UIGestureRecognizer ){
        // Get the location inside the map view
        let touchPoint = recognizer.location(in: self.mapView)
        
        // Convert the point in the view to a coordinate
        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        // Create new annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

