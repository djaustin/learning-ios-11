//
//  ViewController.swift
//  weather-app
//
//  Created by Dan Austin on 22/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit
import SwiftSoup
import NVActivityIndicatorView

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lblWeather: UILabel!
    @IBOutlet weak var txtLocation: UITextField!
    @IBAction func buttonClicked(_ sender: Any) {
        if let location = txtLocation.text {
            activityIndicator.startAnimating()
            fetchWeather(forLocation: location)
        }
        
        
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchWeather(forLocation location: String){
        let escapedLocationString = location.replacingOccurrences(of: " ", with: "")
        guard let url = URL(string: "http://weather-forecast.com/locations/\(escapedLocationString)/forecasts/latest") else {
            self.updateLabel(withText: "Unable to fetch weather for that location")
            return
        }
        
            let task = URLSession.shared.dataTask(with: url)  {
                data, response, error in
                
                if let err = error {
                    print(err)
                } else
                {
                    guard let unwrappedData = data else {
                        self.updateLabel(withText: "No data receieved from server")
                        return
                    }
                    
                    
                    if let html = String(data: unwrappedData, encoding: String.Encoding.utf8){
                        do{
                            let parsedHtml = try SwiftSoup.parse(html)
                            if let weatherReport =  try parsedHtml.getElementsByClass("phrase").first()?.text(){
                                self.updateLabel(withText: weatherReport)
                            } else {
                                self.updateLabel(withText: "Unable to fetch weather for this location. Please try another")
                            }
                        } catch {
                            self.updateLabel(withText: "Error parsing response from server")
                        }
                        
                        
                    }
                    
                }
                
            
                
            }
            task.resume()
            
            
        }
    
    func updateLabel(withText text: String) {
        DispatchQueue.main.async {
            self.lblWeather.text = text
            self.activityIndicator.stopAnimating()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Requires implementing the UITextFieldDelegate protocol
    // Requires textfield to have this view as its assigned delegate
    // Is called whenever the return key is pressed on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Hide keyboard
        textField.resignFirstResponder()
        // Tell text field to process return with default behaviour
        return true
    }
    
    }


