//
//  PostViewController.swift
//  instagram-clone
//
//  Created by Dan Austin on 28/08/2017.
//  Copyright © 2017 Dan Austin. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let imagePicker = UIImagePickerController()
    @IBAction func postWasPressed(_ sender: Any) {
        
    }
    @IBOutlet weak var txtComment: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtComment.delegate = self
        imagePicker.delegate = self
        addTapRecognizerToImageView()
        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = image
        imageView.backgroundColor = nil
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
            self.dismiss(animated: true, completion: nil)
        }))
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
}
