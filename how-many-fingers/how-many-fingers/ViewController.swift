//
//  ViewController.swift
//  how-many-fingers
//
//  Created by Dan Austin on 21/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func submit(_ sender: UIButton) {
        let answer = arc4random_uniform(6)
        if let guessString = txtGuess.text{
            if let guess = Int(guessString){
                lblResult.text = answer == guess ? "Correct!" : "Wrong! The answer was \(answer)"
            }
        }
    }
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var txtGuess: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

