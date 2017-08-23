//
//  ViewController.swift
//  user-location
//
//  Created by Dan Austin on 23/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
// Delegate means that location manager will call functions in this class to report back location and other things
class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    let locMan = CLLocationManager()
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locMan.delegate = self
        locMan.desiredAccuracy = kCLLocationAccuracyBest
        locMan.requestWhenInUseAuthorization()
        locMan.startUpdatingLocation()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations[0])
        centreMap(onLocation: locations[0])
    }
    
    func centreMap(onLocation location: CLLocation){
        
        let region = MKCoordinateRegion(center: location.coordinate, span: mapSpan)
        map.setRegion(region, animated: true)
    }

    
    
}

