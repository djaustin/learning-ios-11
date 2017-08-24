//
//  ViewController.swift
//  advanced-core-data
//
//  Created by Dan Austin on 24/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let context = appDelegate.persistentContainer.viewContext
//        let newUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
//        newUser.setValue("John", forKey: "username")
//        newUser.setValue("pass123", forKey: "password")
//        newUser.setValue(16, forKey: "age")
//
//        do {
//            try context.save()
//        } catch  {
//            print(error)
//        }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "username = %@", argumentArray: ["Jonno"])
        
        
        if let results = try? context.fetch(request) as! [NSManagedObject]{
            for result in results{
                print("Found", result)
                context.delete(result)
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


}

