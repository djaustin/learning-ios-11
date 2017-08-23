//
//  ViewController.swift
//  gif-stepper
//
//  Created by Dan Austin on 23/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var count = 0
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func buttonClicked(_ sender: Any) {
        if let image = getStillImageName(fromNumber: count) {
            imageView.image = image
            count += 1
        } else {
            count = 0
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

    func getStillImageName(fromNumber number:Int) -> UIImage?{
        var numString = String()
        if number < 10{
            numString = "0\(number)"
        }else{
            numString = String(number)
        }
        let imageName = "ezgif/frame_\(numString)_delay-0.13s.gif"
        return UIImage(named: imageName)
    }
    
}

