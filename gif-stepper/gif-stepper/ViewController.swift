//
//  ViewController.swift
//  gif-stepper
//
//  Created by Dan Austin on 23/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var btnPlayPause: UIButton!
    var count = 0
    var timer = Timer()
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func growClicked(_ sender: Any) {
        UIView.animate(withDuration: 1) {


        }
        UIView.animate(withDuration: 1, animations: {
            let frame = self.imageView.frame
            self.imageView.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width+100, height: frame.height+100)
        }) { (finished) in
            UIView.animate(withDuration: 1, animations: {
                let frame = self.imageView.frame
                self.imageView.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width-100, height: frame.height-100)
            })
        }
        
    }
    @IBAction func slideClicked(_ sender: Any) {
        imageView.center = CGPoint(x: imageView.center.x - 500, y: imageView.center.y)
        UIView.animate(withDuration: 2) {
            self.imageView.center = CGPoint(x: self.imageView.center.x + 500, y: self.imageView.center.y)
        }
    }
    @IBAction func fadeClicked(_ sender: Any) {
        imageView.alpha = 0
        UIView.animate(withDuration: 1) {
            self.imageView.alpha = 1
        }
    }
    @IBAction func buttonClicked(_ sender: Any) {
        if !timer.isValid{
            timer = Timer.scheduledTimer(timeInterval: 0.13, target: self, selector: #selector(progressGif), userInfo: nil, repeats: true)
            btnPlayPause.setTitle("Pause", for: UIControlState.normal)
        } else {
            timer.invalidate()
            btnPlayPause.setTitle("Play", for: .normal)
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
    
    @objc func progressGif(){
        if let image = getStillImageName(fromNumber: count) {
            imageView.image = image
            count += 1
        } else {
            count = 0
        }
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

