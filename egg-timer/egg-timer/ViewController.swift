//
//  ViewController.swift
//  egg-timer
//
//  Created by Dan Austin on 22/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var timer:Timer = Timer()
    var timeRemaining:Int = 0
    
    @IBAction func resetButtonClicked(_ sender: UIBarButtonItem) {
        updateTime(changeInSeconds: -timeRemaining)
    }
    @IBAction func incrementButtonClicked(_ sender: UIBarButtonItem) {
        updateTime(changeInSeconds: 10)
    }
    @IBAction func decrementButtonClicked(_ sender: UIBarButtonItem) {
        updateTime(changeInSeconds: -10)
    }
    @IBAction func pauseButtonClicked(_ sender: UIBarButtonItem) {
        if timer.isValid{
            timer.invalidate()
        }
        
    }
    @IBAction func playButtonClicked(_ sender: UIBarButtonItem) {
        if !timer.isValid{
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
        }
    }
    @IBOutlet weak var lblTime: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func timerTick(){
        updateTime(changeInSeconds: -1)
       
    }
    
    func updateTime(changeInSeconds: Int) {
        if changeInSeconds > 0 {
            timeRemaining += changeInSeconds
            updateLabel()
        }else{
            if timeRemaining + changeInSeconds <= 0{
                timeRemaining = 0
                timer.invalidate()
            } else{
                timeRemaining += changeInSeconds
            }
            updateLabel()
        }
    }
    
    func updateLabel(){
        lblTime.text = String(timeRemaining)
    }


}

