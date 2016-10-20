//
//  RegisterViewController.swift
//  DatingApp
//
//  Created by Hahaboy on 20/10/2016.
//  Copyright © 2016 Hahaboy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class RegisterViewController: UIViewController {

    
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    
    @IBAction func onSignUpButtonPressed(sender: AnyObject) {
        
        guard
            let username = usernameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text else{
                return
        }
        
        //other validation here
        
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
            if let user = user{
                //stores into user defaults
                NSUserDefaults.standardUserDefaults().setObject(user.uid, forKey: "userUID")
                self.performSegueWithIdentifier("HomeSegue", sender: nil)
                
                let firebaseRef = FIRDatabase.database().reference()
                
                let currentUserRef = firebaseRef.child("users").child(user.uid)
                let userDict = ["email":email, "username":username]
                currentUserRef.setValue(userDict)
                //successfully sign up
            }else{
                // if sign up failed, pop this message
                let alert = UIAlertController(title: "Sign Up Failed", message: error?.localizedDescription, preferredStyle: .Alert)
                
                let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
                
                alert.addAction(dismissAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }
    
}
