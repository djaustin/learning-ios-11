//
//  UserDetailsViewController.swift
//  tinder-style-app
//
//  Created by Dan Austin on 03/09/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit
import Parse

class UserDetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBAction func logoutWasTapped(_ sender: Any) {
        PFUser.logOut()
        performSegue(withIdentifier: "showLogin", sender: self)
    }
    
    @IBOutlet weak var userInterestedInSelector: UISegmentedControl!
    @IBOutlet weak var userGenderSelector: UISegmentedControl!
    let imagePicker = UIImagePickerController()
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageView()
        populateFormIfLoggedIn()
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func populateFormIfLoggedIn(){
        if let user = PFUser.current(){
            if let profilePicture = user["profilePicture"] as? PFFile{
                profilePicture.getDataInBackground(block: { (data, error) in
                    if let data = data {
                        if let image = UIImage(data: data){
                            DispatchQueue.main.async {
                                self.imageView.image = image
                            }
                            
                        }
                    }
                })
            }
            if let userGender = user["gender"] as? String {
               userGenderSelector.selectedSegmentIndex = userGender == "m" ? 0 : 1
            }
            
            if let interestedInGender = user["interestedIn"] as? String {
                userInterestedInSelector.selectedSegmentIndex = interestedInGender == "m" ? 0 : 1
            }
        }
    }
    
    func setupImageView(){
        imageView.tintColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewWasTapped(_:)))
        imageView.addGestureRecognizer(tapGesture)
    }
    @IBAction func saveWasTapped(_ sender: Any) {
        let userGender = userGenderSelector.titleForSegment(at: userGenderSelector.selectedSegmentIndex) == "Man" ? "m" : "f"
        let interestedInGender = userInterestedInSelector.titleForSegment(at: userInterestedInSelector.selectedSegmentIndex) == "Men" ? "m" : "f"
        let user = PFUser.current()!
        if let imageData = UIImageJPEGRepresentation(imageView.image!, 0.5) {
            let profilePicture = PFFile(name: "image.jpg", data: imageData)
            user["profilePicture"] = profilePicture
            user["interestedIn"] = interestedInGender
            user["gender"] = userGender
            user.saveInBackground(block: { (success, error) in
                if success {
                    self.presentOkAlert(title: "Save Complete", message: "Details successfully updated")
                } else {
                    if let error = error {
                        self.presentOkAlert(title: "Error", message: error.localizedDescription)
                    }
                }
            })
        }
    }
    
    @objc func imageViewWasTapped(_ gesture:UITapGestureRecognizer){
        // Show action-sheet alert to allow camera or photo library selection
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: showCameraPicker))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: showPhotoLibraryPicker))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func showCameraPicker(_ : UIAlertAction){
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func showPhotoLibraryPicker(_ : UIAlertAction){
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }

}
