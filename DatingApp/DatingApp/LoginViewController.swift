//
//  ViewController.swift
//  DatingApp
//
//  Created by Hahaboy on 20/10/2016.
//  Copyright © 2016 Hahaboy. All rights reserved.
//

import UIKit
import FirebaseAuth

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }

    @IBAction func onLogInButtonPressed(sender: AnyObject) {
        
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text
            else { return }
        
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            
            if let user = user{
                //successfully signed in
                NSUserDefaults.standardUserDefaults().setObject(user.uid, forKey: "userUID")
                self.performSegueWithIdentifier("HomeSegue", sender: nil)
            }else{
                //failed sign in
                let alert = UIAlertController(title: "Sign In Failed", message: error?.localizedDescription, preferredStyle: .Alert)
                
                let dismissAction = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
                
                alert.addAction(dismissAction)
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
        
    }

}

