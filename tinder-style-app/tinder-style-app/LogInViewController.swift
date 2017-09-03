//
//  LogInViewController.swift
//  tinder-style-app
//
//  Created by Dan Austin on 02/09/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit
import Parse

extension UIViewController{
    func presentOkAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

class LogInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var formBackground: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBAction func logInWasTapped(_ sender: Any?) {
        guard let username = txtUsername.text else {return}
        guard let password = txtPassword.text else {return}
        logInUser(username: username, password: password)
    }
    
    
    func logInUser(username: String, password: String){
        PFUser.logInWithUsername(inBackground: username, password: password) { user, error in
            if let user = user {
                self.performSegue(withIdentifier: "showUserDetails", sender: self)
            } else {
                if let error = error{
                    self.presentOkAlert(title: "Log In Failed", message: error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func signUpWasTapped(_ sender: Any) {
        guard let username = txtUsername.text else {return}
        guard let password = txtPassword.text else {return}
        let newUser = PFUser()
        newUser.username = username
        newUser.password = password
        newUser.signUpInBackground { (success, error) in
            if success {
                // If user was signed up, login using their credentials
               self.logInUser(username: username, password: password)
            } else {
                if let error = error {
                    self.presentOkAlert(title: "Log In Failed", message: error.localizedDescription)
                }
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Requires implementing the UITextFieldDelegate protocol
    // Requires textfield to have this view as its assigned delegate
    // Is called whenever the return key is pressed on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtUsername{
            txtPassword.becomeFirstResponder()
        }else {
            // Submit form
            logInWasTapped(nil)
            // Hide keyboard
            textField.resignFirstResponder()
        }
      
        
        // Tell text field to process return with default behaviour
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bypassLoginIfLoggedIn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formBackground.layer.cornerRadius = 10
        formBackground.layer.masksToBounds = true
        txtPassword.delegate = self
        txtUsername.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func bypassLoginIfLoggedIn(){
        if PFUser.current() != nil {
            performSegue(withIdentifier: "showUserDetails", sender: self)
        }
    }
}
