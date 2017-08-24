//
//  ProfileViewController.swift
//  core-data-demo
//
//  Created by Dan Austin on 24/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController {

    @IBOutlet weak var txtUsername: UITextField!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var activeUsername: String?
    var activeUser: User?
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBAction func saveWasPressed(){
        saveProfile()
    }
    
    @IBAction func logoutWasPressed(_ sender: Any) {
        performSegue(withIdentifier: "logout", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let username = activeUsername {
            loadUserProfile(withUsername: username)
        }

        // Do any additional setup after loading the view.
    }

    func loadUserProfile(withUsername username: String){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "username = %@", argumentArray: [username])
        // Xcode automatically generates the subclasses of NSManagedObject for each of our entities
        if let results = try? context.fetch(request) as! [User]{
            activeUser = results[0]
            txtUsername.text = username
            if let password = results[0].password{
                txtPassword.text = password
            }
        }
    }
    
    func saveProfile(){
        if let user = activeUser {
            if let password = txtPassword.text{
                user.password = password
            }
            do{
                try context.save()
            }catch{
                print(error)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logout"{
            let vc = segue.destination as! ViewController
            vc.activeUsername = nil
        }
    }
    

}
