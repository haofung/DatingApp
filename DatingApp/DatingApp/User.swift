//
//  User.swift
//  DatingApp
//
//  Created by Hahaboy on 20/10/2016.
//  Copyright © 2016 Hahaboy. All rights reserved.
//

import Foundation
import Firebase

class User{
    
    var uid:String?
    var username: String?
    var profileImage: String?
    var description : String?

    
    init?(snapshot: FIRDataSnapshot){
        
        self.uid = snapshot.key
        
        guard let dict = snapshot.value as? [String: AnyObject] else { return nil }
        
        if let dictUsername = dict["username"] as? String{
            self.username = dictUsername
        }else{
            self.username = ""
        }
        
        if let dictPImage = dict["profileImage"] as? String{
            self.profileImage = dictPImage
        }else{
            self.profileImage = ""
        }
        
        if let dictDescription = dict["self-description"] as? String{
            self.description = dictDescription
        }else{
            self.description = ""
        }
        
    }
    
    class func currentUserUid() -> String? {
        return NSUserDefaults.standardUserDefaults().valueForKey("userUID") as? String
    }
    
    init(){}
}