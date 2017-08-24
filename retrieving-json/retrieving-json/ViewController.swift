//
//  ViewController.swift
//  retrieving-json
//
//  Created by Dan Austin on 24/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    let apiKey = "7ce4a67c74d691c829fa2411e3032525"
    let apiPlaceNameEndpoint = String("http://api.openweathermap.org/data/2.5/weather?q=%@&appId=%@")
    let apiCoordinateEndpoint = String("http://api.openweathermap.org/data/2.5/weather?lat=%.5f&lon=%.5f&appId=%@")
    
    @IBAction func buttonGoWasPressed(_ sender: Any) {
        if let location = txtLocation.text{
            getWeatherForecast(atPlaceName: location)
        }
    }
    
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var lblResult: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations[0].coordinate.latitude)
        locationManager.stopUpdatingLocation()
        getWeatherForecast(atCoordinate: locations[0].coordinate)
    }
    
    
    func getWeatherForecast(atCoordinate coordinate: CLLocationCoordinate2D){
        guard let url = URL(string: String(format: apiCoordinateEndpoint, Double(coordinate.latitude), Double(coordinate.longitude), apiKey)) else {
            return
        }
        
        processRequest(withUrl: url)
        
    }
    
    func getWeatherForecast(atPlaceName place: String){
        guard let encodedString = place.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        guard let url = URL(string: String(format: apiPlaceNameEndpoint, encodedString, apiKey)) else {
            return
        }
        
        processRequest(withUrl: url)
    }
    
    func processRequest(withUrl url: URL){
        print("url", url)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error{
                print(error)
            } else {
                if let data = data{
                    let json = JSON(data: data)
                    print(json)
                    DispatchQueue.main.async {
                        self.lblResult.text = json["weather"][0]["description"].stringValue
                    }
                }
                
            }
        }
        task.resume()
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

