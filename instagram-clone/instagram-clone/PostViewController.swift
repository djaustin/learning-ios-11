//
//  PostViewController.swift
//  instagram-clone
//
//  Created by Dan Austin on 28/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit
import Parse

class PostViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    let indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))


    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    let imagePicker = UIImagePickerController()
    @IBAction func postWasPressed(_ sender: Any) {
        uploadNewPost()
        
    }
    @IBOutlet weak var txtCaption: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Activity indicator to show when uploading files
        indicator.center = view.center
        indicator.activityIndicatorViewStyle = .gray
        
        
        txtCaption.delegate = self
        imagePicker.delegate = self
        
        addTapRecognizerToImageView()
        view.addSubview(indicator)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = image
        imageView.backgroundColor = nil
        btnPost.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    
    func addTapRecognizerToImageView(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(displayImageSourceSelector))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func displayImageSourceSelector(){
        print("Tapped image")
        let alert = UIAlertController(title:nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            print("User chose camera")
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
           
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            print("User chose photo library")
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in self.dismiss(animated: true, completion: nil)}))
        present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Requires implementing the UITextFieldDelegate protocol
    // Requires textfield to have this view as its assigned delegate
    // Is called whenever the return key is pressed on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Hide keyboard
        textField.resignFirstResponder()
        // Tell text field to process return with default behaviour
        return true
    }
    
    func pauseApplication(){
        indicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }
    func resumeApplication(){
        indicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func uploadNewPost(){
        guard let image = imageView.image else {
            return
        }
        guard let caption = txtCaption.text else {
            return
        }
        guard let imageData = image.jpeg(.medium) else {
            return
        }
        let newPost = PFObject(className: "Post")

        let parseImage = PFFile(name: "image.jpg", data: imageData)!
        pauseApplication()
        progressBar.isHidden = false
        
        // Upload image and only save new post if successfully uploaded
        parseImage.saveInBackground({ (success, error) in
            self.progressBar.isHidden = true
            if(success){
                newPost["image"] = parseImage
                newPost["author"] = PFUser.current()!
                newPost["caption"] = caption
                let acl = PFACL()
                acl.getPublicReadAccess = true
                acl.getPublicWriteAccess = false
                acl.setWriteAccess(true, for: PFUser.current()!)
                acl.setReadAccess(true, for: PFUser.current()!)
                newPost.acl = acl
                
                newPost.saveInBackground { (success, error) in
                    self.resumeApplication()
                    if success {
                        print("Successfully uploaded")
                        self.clearFormControls()
                    } else {
                        if let error = error {
                            print("Error:", error.localizedDescription)
                        }
                    }
                }
            } else {
                self.resumeApplication()
                if let error = error {
                    print("Error:", error.localizedDescription)
                }
            }
        }) { (progress) in
            let progressFloat = Float(progress)
            DispatchQueue.main.async {
                self.progressBar.progress = progressFloat/100
            }
        }
    }
    
    func clearFormControls(){
        txtCaption.text = ""
        imageView.image = #imageLiteral(resourceName: "icons8-plus_math_filled.png")
        imageView.backgroundColor = UIColor.lightGray
        btnPost.isEnabled = false
    }
}
