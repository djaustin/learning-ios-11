//
//  ViewController.swift
//  instagram-clone
//
//  Created by Dan Austin on 25/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit
import Parse

extension UIViewController{
    func launchOkAlert(withTitle title: String, andText text: String){
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

class LogInViewController: UIViewController {
    
    let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    @IBAction func logInWasPressed(_ sender: Any) {
        guard let username = txtEmail.text else{
            return
        }
        guard let password = txtPassword.text else{
            return
        }
        pauseApplication()

        
        PFUser.logInWithUsername(inBackground: username, password: password) { user, error in
            print("logging in user")
            self.resumeApplication()
            if let user = user {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "showUserTable", sender: self)
                }
                
            } else {
                if let error = error{
                    self.launchOkAlert(withTitle: "Log In Failed", andText: error.localizedDescription)
                }
            }


        }
    }
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        indicator.center = view.center
        indicator.activityIndicatorViewStyle = .gray
        view.addSubview(indicator)
        
//        var activityIN : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 100 , y: 200, width: 50, height:50)) as UIActivityIndicatorView
//        activityIN.center = self.view.center
//        activityIN.hidesWhenStopped = true
//        activityIN.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//        activityIN.startAnimating()
//        self.view.addSubview(activityIN)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func pauseApplication(){
        indicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    
    }
    func resumeApplication(){
       indicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       print(PFUser.current())
        if PFUser.current() != nil {
            performSegue(withIdentifier: "showUserTable", sender: self)
        }
    }

}

