//
//  DataService.swift
//  DatingApp
//
//  Created by Hahaboy on 20/10/2016.
//  Copyright © 2016 Hahaboy. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

struct DataService {
    
    static var rootRef = FIRDatabase.database().reference()
    static var userRef = FIRDatabase.database().reference().child("users")
    
}
