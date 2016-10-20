//
//  ProfileViewController.swift
//  DatingApp
//
//  Created by Hahaboy on 20/10/2016.
//  Copyright © 2016 Hahaboy. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var aboutMeLabel: UITextView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var user:User!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Profile"
        
        DataService.userRef.child(User.currentUserUid()!).observeEventType(.Value, withBlock: { userSnapshot in
            if let user = User(snapshot: userSnapshot){
                
                if user.profileImage == ""{
                    self.profileImageView.image = UIImage(named: "default-user")
                }else{
                    let url = NSURL(string: user.profileImage!)
                    self.profileImageView.sd_setImageWithURL(url)
                }
                
                self.aboutMeLabel.text = user.description
                self.usernameLabel.text = user.username
                self.user = user
                
            }
        })
        
        
    }
    
    @IBAction func unwindToMyProfile(segue: UIStoryboardSegue) {
    }
    
    @IBAction func onLogOutButtonPressed(sender: AnyObject) {
        try! FIRAuth.auth()!.signOut()
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey("userUID")
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let viewController = storyboard.instantiateInitialViewController()
        
        self.presentViewController(viewController!, animated: true, completion: nil)
        
    }
    
    @IBAction func goBackToHome(sender: AnyObject) {
        performSegueWithIdentifier("unwindToHomeSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditSegue"{
            let nextScene = segue.destinationViewController as! EditViewController
            nextScene.user = self.user
        }
    }
    
}
