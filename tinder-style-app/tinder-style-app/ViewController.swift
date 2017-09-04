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
    var displayedUser: PFUser?
    @IBAction func settingsWasTapped(_ sender: Any) {
        performSegue(withIdentifier: "showUserDetails", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUserLocation()
        loadNewMatch()
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(labelWasDragged(_:)))
        imageView.addGestureRecognizer(gesture)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBOutlet weak var lblUsername: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @objc func labelWasDragged(_ recognizer: UIPanGestureRecognizer){
        print("dragging")
        // Origin of coordinates is the center of the view
        let touchPoint = recognizer.translation(in: view)
        print(touchPoint)
        let newCenter = CGPoint(x: view.bounds.width/2 + touchPoint.x, y: view.bounds.height/2 + touchPoint.y)
        imageView.center = newCenter
        
        let xFromCenter = view.bounds.width/2 - imageView.center.x
        var rotation = CGAffineTransform(rotationAngle: xFromCenter/500)
        
        imageView.transform = rotation
        
        // Alert swipe accepted
        if recognizer.state == .ended {
            if imageView.center.x < (view.bounds.width/2 - 100){
                processDisplayedUser(accepted: false)
            } else if imageView.center.x > (view.bounds.width/2 + 100){
                processDisplayedUser(accepted: true)
            }
            
            imageView.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
            rotation = CGAffineTransform(rotationAngle: 0)
            imageView.transform = rotation
            imageView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
    }
    
    func loadNewMatch() {
        let acceptedUsersQuery = PFUser.current()!.relation(forKey: "accepted").query()
        let rejectedUsersQuery = PFUser.current()!.relation(forKey: "rejected").query()
        // Query to get all users that are in either the accepted or rejected relation of current user
        let swipedUsersQuery = PFQuery.orQuery(withSubqueries: [acceptedUsersQuery, rejectedUsersQuery])
        
        swipedUsersQuery.findObjectsInBackground { (results, error) in
            if let swipedUsers = results as? [PFUser] {
                if let query = PFUser.query() {
                    // Get first compatible match that has not already been swiped by current user
                    query.whereKey("gender", equalTo: PFUser.current()!["interestedIn"])
                    query.whereKey("interestedIn", equalTo: PFUser.current()!["gender"])
                    query.whereKey("location", nearGeoPoint: PFUser.current()!["location"] as! PFGeoPoint, withinKilometers: 20)
                    query.whereKey("objectId", notContainedIn: swipedUsers.map({ (user) -> String in
                        user.objectId!
                    }))
                    query.getFirstObjectInBackground { (user, error) in
                        if let user = user as? PFUser{
                            self.displayedUser = user
                            if let image = user["profilePicture"] as? PFFile {
                                image.getDataInBackground(block: { (data, error) in
                                    if let data = data {
                                        if let uiImage = UIImage(data: data){
                                            self.imageView.isHidden = false
                                            self.imageView.image = uiImage
                                            self.lblUsername.text = user.username!
                                        }
                                    }
                                })
                            }
                            
                        } else {
                            self.imageView.isHidden = true
                            self.lblUsername.text = "No more potential matches nearby"
                        }
                    }
                }
            }
        }
        
        
    }
    
    func processDisplayedUser(accepted: Bool){
        if let displayedUser = displayedUser {
            if let currentUser = PFUser.current() {
                if accepted {
                    let acceptedUsers = currentUser.relation(forKey: "accepted")
                    acceptedUsers.add(displayedUser)
                } else {
                    let rejectedUsers = currentUser.relation(forKey: "rejected")
                    rejectedUsers.add(displayedUser)
                }
                currentUser.saveInBackground(block: { (success, error) in
                    if success {
                        self.loadNewMatch()
                    } else {
                        if let error = error {
                            self.presentOkAlert(title: "Error", message: error.localizedDescription)
                        }
                    }
                })
            }
        }
    }
    
    func updateUserLocation(){
        PFGeoPoint.geoPointForCurrentLocation { (location, error) in
            if let location = location {
                PFUser.current()!["location"] = location
                PFUser.current()!.saveEventually()
                
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

