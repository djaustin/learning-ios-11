//
//  ViewController.swift
//  core-data-demo
//
//  Created by Dan Austin on 24/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    var activeUsername: String?
    @IBOutlet weak var lblFeedback: UILabel!
    var context: NSManagedObjectContext!
    @IBAction func btnSubmitPressed(_ sender: UIButton) {
        guard let username = txtUsername.text else { return  }
        if authenticateUser(withUsername: username){
            activeUsername = username
            performSegue(withIdentifier: "login", sender: nil)
        } else {
            addUser(withUsername: username)
            lblFeedback.text = "User \(username) added"
        }
    }
    @IBOutlet weak var txtUsername: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get AppDelegate for our app. This contains the initialization of the Core Data stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        context = delegate.persistentContainer.viewContext
        
        // Do any additional setup after loading the view, typically from a nib.
            /* -- SAVE USER SAMPLE
                    // Retrieve the context for our app
                    let context = delegate.persistentContainer.viewContext
         
                    let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
         
                    user.setValue("djaustin", forKey: "username")
                    user.setValue("pass123", forKey: "password")
                    user.setValue("Dan", forKey: "firstname")
                    user.setValue("Austin", forKey: "lastname")
         
                    do{
                        try context.save()
                        print("saved user")
                    } catch{
                        print("error:", error)
                    }
             */
        
    }

    func authenticateUser(withUsername username: String) -> Bool{
        // Construct a request
        let request: NSFetchRequest<User> = User.fetchRequest()
        // Return complete objects
        request.returnsObjectsAsFaults = false
        
        // Get all objects from context matching request (all objects in User entity)
        if let results = try? context.fetch(request){
            // If any objects have a username matching the one provided, authenticate
            return results.index(where: { (object) -> Bool in
                object.username == username
            }) != nil
            
        }
        return false
    }
    
    func addUser(withUsername username: String, andPassword password: String = "pass123") {
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
        newUser.username = username
        newUser.password = password
        do {
            try context.save()
        } catch {
            lblFeedback.text = "Unable to save user"
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "login"{
            let vc = segue.destination as! ProfileViewController
            vc.activeUsername = activeUsername
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

