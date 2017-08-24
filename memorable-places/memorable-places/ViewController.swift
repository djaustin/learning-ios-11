//
//  ViewController.swift
//  memorable-places
//
//  Created by Dan Austin on 23/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

extension MKPointAnnotation{
    func toDictionary() -> [String:Any] {
        var dict = [String:Any]()
        dict["longitude"] = self.coordinate.longitude
        dict["latitude"] = self.coordinate.latitude
        dict["title"] = self.title
        return dict
    }
    
    convenience init(fromDictionary dictionary: [String:Any]){
        self.init()
        if let title = dictionary["title"] as? String{
            self.title = title
        }
        if let longitude = dictionary["longitude"] as? CLLocationDegrees{
            self.coordinate.longitude = longitude
        }
        if let latitude = dictionary["latitude"] as? CLLocationDegrees {
            self.coordinate.latitude = latitude
        }
    }
    
}

class ViewController: UIViewController, CLLocationManagerDelegate{

    @IBAction func currentLocationClicked(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var pointToShow:MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Place all saved annotations on the map
        loadAllPoints()
        CGRect(x: 0, y:0, width: 100, height: 100)
        
        // Zoom map to selected annotation
        if let annotation = pointToShow {
            let region = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            mapView.setRegion(region, animated: true)
        } else{
            // Zoom map to user location
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(addMemorablePlace(_:)))
        mapView.addGestureRecognizer(longPressRecognizer)
    }

    // Add annotation to map at user touch point. Saved to user defaults
    @objc func addMemorablePlace(_ recognizer: UIGestureRecognizer){
        if(recognizer.state == .began){
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            let touchPoint = recognizer.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            createAnnotation(fromCoordinate: coordinate)
        }
    }
    
    // Loads all annotations from UserDefaults
    func loadAllPoints(){
        if let dictPoints = UserDefaults.standard.object(forKey: "memorable_places") as? [[String:Any]]{
            let annotations = dictPoints.map({ ele in
                MKPointAnnotation(fromDictionary: ele)
            })
            mapView.addAnnotations(annotations)
        }
    }
    
    // Populates annotation values with reverse geocoded title
    func createAnnotation(fromCoordinate coord: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = coord
        
        let location = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if let err = error{
                print(err)
            }
            
            guard let placemark = placemarks?[0] else{
                return
            }
            
            var title = ""
            if placemark.subThoroughfare != nil && placemark.thoroughfare != nil{
                title.append(placemark.subThoroughfare! + " " + placemark.thoroughfare!)
            } else if placemark.subAdministrativeArea != nil {
                title.append(placemark.subAdministrativeArea!)
            }
            
            annotation.title = title
            self.mapView.addAnnotation(annotation)
            self.saveNewMemorablePlace(fromAnnotation: annotation)
            
        })
    }
    
    // Save memorable place to UserDefaults
    func saveNewMemorablePlace(fromAnnotation annotation: MKPointAnnotation){
        if var savedPlaces = UserDefaults.standard.object(forKey: "memorable_places") as? [[String:Any]]{
            savedPlaces.append(annotation.toDictionary())
            print("saving", savedPlaces)
            UserDefaults.standard.set(savedPlaces, forKey: "memorable_places")
        } else {
            UserDefaults.standard.set([annotation.toDictionary()], forKey: "memorable_places")
        }
    }
    
    // Zoom map to user location when updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        // Allow the user to move the screen
        locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        locationManager.requestLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

