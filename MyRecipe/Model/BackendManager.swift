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
        let dict = ["username" : name]
        Database.database().reference().child(uid).updateChildValues(dict)
        print("BackendManager User Creation - User init data created")
    }
    
    //MARK: Login
    class func loginUserWith(email: String, password: String, completion: @escaping (_ user: User?,_ error: Error?)-> Void){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error == nil {
                Database.database().reference().child(result?.user.uid ?? "").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                    if snapshot.exists() {
                        let value = snapshot.value as! NSDictionary
                        let uid = (result?.user.uid)!
                        let name = value["username"] as! String
                        let user = User.init(name: name, uid: uid, recipes: nil)
                        completion(user, error)
                    }
                    else { completion(nil, error) }
                })
            }
            else{
                completion(nil, error)
            }
        }
    }
    
    class func getUsersRecipes(userUID: String, completion: @escaping (_ recipes: [Recipe]?,_ error: Error)-> Void){
        Database.database().reference().child(userUID).child("recipes").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                // init recipes here
            }
        }
    }
    
    
    
    
}
