//
//  ViewController.swift
//  location-aware
//
//  Created by Dan Austin on 23/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    @IBOutlet weak var lblCourse: UILabel!
    @IBOutlet weak var lblSpeed: UILabel!
    @IBOutlet weak var lblThoroughfare: UILabel!
    @IBOutlet weak var lblSubAdministrativeArea: UILabel!
    @IBOutlet weak var lblPostCode: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateLabels(withLocation: locations[0])
    }
    
    func updateLabels(withLocation location: CLLocation){
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let err = error{
                print(err)
            }
            guard let placemark = placemarks?[0] else {
                return
            }
            DispatchQueue.main.async {
            
                
                // Extract location information from placemark and location object
                self.lblLatitude.text = String(location.coordinate.latitude)
                self.lblLongitude.text = String(location.coordinate.longitude)
                self.lblCourse.text = String(location.course)
                self.lblSpeed.text = String(location.speed)
                
                self.lblThoroughfare.text = placemark.subThoroughfare ?? ""
                self.lblThoroughfare.text?.append(" " + (placemark.thoroughfare ?? ""))
                self.lblSubAdministrativeArea.text = placemark.subAdministrativeArea ?? ""
                self.lblPostCode.text = placemark.postalCode ?? ""
                self.lblCountry.text = placemark.country ?? ""
               
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

