//
//  ViewController.swift
//  is-it-prime
//
//  Created by Dan Austin on 21/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtNumber: UITextField!
    @IBOutlet weak var lblResult: UILabel!
    @IBAction func submit(_ sender: UIButton) {
        if let numString = txtNumber.text {
            if let num = Int(numString){
                updateLabel(numIsPrime: isPrime(num: num))
            } else {
                lblResult.textColor = UIColor.black
                lblResult.text = "Please enter a postitive integer"
            }
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
    
    func updateLabel(numIsPrime: Bool){
        if numIsPrime{
            lblResult.textColor = UIColor.green
            lblResult.text = "Prime"
        }else{
            lblResult.textColor = UIColor.red
            lblResult.text = "Not Prime"
        }
    }
    
    func isPrime(num: Int) -> Bool{
        var isPrime = true
        var i = 2
        while i < num{
            if num % i == 0 {
                isPrime = false
            }
            i += 1
        }
        return isPrime
    }


}

