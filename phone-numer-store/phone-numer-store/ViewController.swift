//
//  ViewController.swift
//  phone-numer-store
//
//  Created by Dan Austin on 22/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtNumber: UITextField!
    @IBAction func buttonClicked(_ sender: Any) {
        
        if let phoneNumber = txtNumber.text {
            saveNumber(phoneNumber)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        txtNumber.text = retrieveNumber()
        print("Retrieved number")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveNumber(_ telephoneNumber: String){
        UserDefaults.standard.set(telephoneNumber, forKey: "phone_number")
        print("Saved number")
    }
    
    func retrieveNumber() -> String? {
        return UserDefaults.standard.string(forKey: "phone_number")
        
    }


}

