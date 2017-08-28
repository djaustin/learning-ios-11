//
//  SignUpViewController.swift
//  instagram-clone
//
//  Created by Dan Austin on 26/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {
    
    let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))

    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBAction func signUpWasPressed(_ sender: Any) {
        if allFieldsCompleted() {
            if txtPassword.text! == txtConfirmPassword.text!{
                createNewUser(withUsername: txtUsername.text!, password: txtPassword.text!, email: txtEmail.text!)
            } else {
                launchOkAlert(withTitle: "Mismatched Passwords", andText: "Passwords do not match. Please try again")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.activityIndicatorViewStyle = .gray
        indicator.hidesWhenStopped = true
        indicator.center = view.center
        view.addSubview(indicator)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func allFieldsCompleted() -> Bool{
        guard let email = txtEmail.text else {
            return false
        }
        guard let password = txtPassword.text else {
            return false
        }
        guard let confirmPassword = txtConfirmPassword.text else {
            return false
        }
        
        guard let username = txtUsername.text else{
            return false
        }
        return !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty && !username.isEmpty
        
    }
    
    // Creates a new Parse user with the given credentials
    func createNewUser(withUsername username: String, password: String, email: String){
        let user = PFUser()
        user.username = username
        user.password = password
        user.email = email
        pauseApplication()
        user.signUpInBackground { (success, error) in
            self.resumeApplication()
            if let error = error{
                print(error)
                self.launchOkAlert(withTitle: "Sign Up Failed", andText: error.localizedDescription)
            }
            
            if success{
                self.performSegue(withIdentifier: "showUserTable", sender: self)
            } else {
                self.launchOkAlert(withTitle: "Sign Up Failed", andText: "Unable to sign up at this time. Please try again later")
            }
        }
    }
    
    func pauseApplication(){
            indicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
    }
    func resumeApplication(){
            indicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
