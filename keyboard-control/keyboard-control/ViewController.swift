//
//  ViewController.swift
//  keyboard-control
//
//  Created by Dan Austin on 22/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

