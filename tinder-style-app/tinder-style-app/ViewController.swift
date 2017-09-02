//
//  ViewController.swift
//  tinder-style-app
//
//  Created by Dan Austin on 02/09/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    @IBOutlet weak var swipeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(labelWasDragged(_:)))
        swipeLabel.addGestureRecognizer(gesture)
        // Do any additional setup after loading the view, typically from a nib.
    }

    @objc func labelWasDragged(_ recognizer: UIPanGestureRecognizer){
        // Origin of coordinates is the center of the view
        let touchPoint = recognizer.translation(in: view)
        print(touchPoint)
        let newCenter = CGPoint(x: view.bounds.width/2 + touchPoint.x, y: view.bounds.height/2 + touchPoint.y)
        swipeLabel.center = newCenter
        
        let xFromCenter = view.bounds.width/2 - swipeLabel.center.x
        var rotation = CGAffineTransform(rotationAngle: xFromCenter/500)
        

        
        swipeLabel.transform = rotation
        
        
        
        // Change color
        var redVal, greenVal: CGFloat
        if newCenter.x - view.bounds.width / 2 < 0 {
            redVal = (128-newCenter.x) / 128
            greenVal = 0
        } else {
            redVal = 0
            greenVal = (newCenter.x - view.bounds.width / 2) / 128
        }
        
        let newColor = UIColor(red: redVal, green: greenVal, blue: 0, alpha: 1)
        swipeLabel.backgroundColor = newColor

        // Alert swipe accepted
        if recognizer.state == .ended {
            if swipeLabel.center.x < (view.bounds.width/2 - 100){
                let alert = UIAlertController(title: "Swiped", message: "Not interested", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            } else if swipeLabel.center.x > (view.bounds.width/2 + 100){
                let alert = UIAlertController(title: "Swiped", message: "Interested", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }

            swipeLabel.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
            rotation = CGAffineTransform(rotationAngle: 0)
            swipeLabel.transform = rotation
            swipeLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

