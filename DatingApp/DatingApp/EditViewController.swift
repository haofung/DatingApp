//
//  EditViewController.swift
//  DatingApp
//
//  Created by Hahaboy on 20/10/2016.
//  Copyright © 2016 Hahaboy. All rights reserved.
//

import UIKit
import FirebaseStorage

class EditViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var user:User!
    var selectedImage:UIImage!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var aboutMeTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Edit Profile"
        self.hideKeyboardWhenTappedAround()
        self.editButton.userInteractionEnabled = false
        
        if let description = self.user.description{
        self.aboutMeTextView.text = description
        }
        self.usernameTextField.text = self.user.username
        
        if user.profileImage == ""{
            self.profileImageView.image = UIImage(named: "default-user")
        }else{
            let url = NSURL(string: user.profileImage!)
            self.profileImageView.sd_setImageWithURL(url)
        }
        
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectProfileImage)))
        profileImageView.userInteractionEnabled = true
        
    }
    
    @IBAction func onCancelButtonPressed(sender: AnyObject) {
        performSegueWithIdentifier("unwindToProfileSegue", sender: self)
    }
    
    @IBAction func onSaveButtonPressed(sender: AnyObject) {
        let username = self.usernameTextField.text
        
        let description = self.aboutMeTextView.text
        
        DataService.userRef.child(User.currentUserUid()!).child("username").setValue(username)
        DataService.userRef.child(User.currentUserUid()!).child("self-description").setValue(description)
        
        if let profileImage = self.selectedImage{
            
            let uniqueImageName = NSUUID().UUIDString
            let storageRef = FIRStorage.storage().reference().child("\(uniqueImageName).png")
            if let imageToUpload = UIImageJPEGRepresentation(profileImage, 0.5) {
                
                storageRef.putData(imageToUpload, metadata: nil, completion: { (metadata, error) in
                    if error != nil{
                        print(error)
                        return
                    }
                    let userRef = DataService.userRef.child(User.currentUserUid()!)
                    if let imageURL = metadata?.downloadURL()?.absoluteString{
                        userRef.child("profileImage").setValue(imageURL)
                    }
                })
            }
        }
        performSegueWithIdentifier("unwindToProfileSegue", sender: self)
    }
    
    func selectProfileImage () {
        let picker = UIImagePickerController ()
        picker.delegate = self
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        var selectedImageFromPicker : UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            self.profileImageView.image = selectedImage
            self.selectedImage = selectedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
