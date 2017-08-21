//
//  ViewController.swift
//  cat-years
//
//  Created by Dan Austin on 21/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func submit(_ sender: UIButton) {
        if let ageString = txtAge.text{
            if let age = Int(ageString){
                let catAge = age * 7
                lblResult.text = "Your cat is \(catAge) in cat years"
            }
        }
    }
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var txtAge: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

