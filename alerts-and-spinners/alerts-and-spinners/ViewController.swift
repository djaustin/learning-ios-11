//
//  ViewController.swift
//  alerts-and-spinners
//
//  Created by Dan Austin on 26/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBAction func pauseAppWasPressed(_ sender: Any) {
        let activity = UIActivityIndicatorView()
        activity.hidesWhenStopped = true
        activity.center = view.center
        activity.activityIndicatorViewStyle = .gray
        view.addSubview(activity)
        activity.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // To allow interaction with the app again
        // UIApplication.shared.endIgnoringInteractionEvents()
        
        
    }
    @IBAction func showAlertWasPressed(_ sender: Any) {
        let alert = UIAlertController(title: "An alert", message: "Are you sure?", preferredStyle: .alert)
        // Actions appear as buttons the user can click to act on the alert
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in print("User pressed 'Cancel'")
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in print("User pressed 'Ok'")
        }))


        present(alert, animated: true, completion: nil)
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

