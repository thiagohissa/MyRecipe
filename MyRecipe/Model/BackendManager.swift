//
//  BackendManager.swift
//  MyRecipe
//
//  Created by Thiago Hissa on 2018-07-06.
//  Copyright © 2018 thiagohisss. All rights reserved.
//

import Foundation

import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class BackendManager: NSObject {
    
    
    //MARK: User Creation
    class func createUserFor(email: String, password: String, username: String, completion: @escaping (_ uid: String?,_ error: Error?) -> Void) {
        print("BackendManager User Creation - Creating user...")
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil {
                print("BackendManager User Creation - User created")
                completion(result?.user.uid, error)
            }
            else{
                completion("", error)
            }
        }
    }
    
    class func saveUserInitialValues(name: String, uid: String) {
        print("BackendManager User Creation - Creating user init data...")
        let dict = ["username" : name,
                    "recipes" : "na",
                    "favorites" : "na"
        ]
        Database.database().reference().child(uid).updateChildValues(dict)
        print("BackendManager User Creation - User init data created")
    }
    
    
    
    
}
