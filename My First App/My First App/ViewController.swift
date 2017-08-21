//
//  ViewController.swift
//  My First App
//
//  Created by Dan Austin on 21/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var labelCounter: UILabel!
    
    @IBOutlet weak var txtName: UITextField!
    @IBAction func ButtonClicked(_ sender: UIButton) {
        // First check and unwrap contents of txtName.text
        if let name = txtName.text {
            labelCounter.text = "Hello " + name
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


}

