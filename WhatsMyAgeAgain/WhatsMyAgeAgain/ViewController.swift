//
//  ViewController.swift
//  WhatsMyAgeAgain
//
//  Created by Dan Austin on 21/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtAge: UITextField!
    @IBAction func submit(_ sender: UIButton) {
        if let age = txtAge.text{
            lblResult.text = "You are " + age + " years old"
        }
    }
    @IBOutlet weak var lblResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

