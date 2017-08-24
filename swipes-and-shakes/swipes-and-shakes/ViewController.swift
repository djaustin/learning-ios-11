//
//  ViewController.swift
//  swipes-and-shakes
//
//  Created by Dan Austin on 24/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lblFeedback: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }

    @objc func swiped(_ gestureRecognizer: UISwipeGestureRecognizer){
        switch gestureRecognizer.direction {
            case .left:
                lblFeedback.text = "Swiped Left"
            case .right:
                lblFeedback.text = "Swiped Right"
            default:
                break
        }
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake{
            lblFeedback.text = "Shook"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

