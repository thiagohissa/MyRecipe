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
    
    static let shared = BackendManager()
    var user: User!
    
    //MARK: User Creation
    class func createUserFor(email: String, password: String, username: String, completion: @escaping (_ uid: String?,_ error: Error?) -> Void) {
        print("BackendManager User Creation - Creating user...")
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil {
                print("BackendManager User Creation - User created")
                completion(result?.user.uid, error)
                BackendManager.shared.user = User.init(name: username, uid: (result?.user.uid)!, recipes: nil)
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
                        Database.database().reference().child(uid).child("recipes").observe(.value, with: { (snap) in
                            if snap.exists() { // Fetch Recipes
                                let value = snap.value as! NSDictionary
                                var arrayOfRecipes: [Recipe] = []
                                for recipe in value {
                                    let new_recipe = Recipe.init(dict: recipe.value as! NSDictionary)
                                    arrayOfRecipes.append(new_recipe)
                                }
                                user.recipes = arrayOfRecipes
                            }
                            else{
                                // No Recipes for this user
                            }
                            BackendManager.shared.user = user
                            completion(user, error)
                        })
                    }
                    else { completion(nil, error) }
                })
            }
            else{
                completion(nil, error)
            }
        }
    }
    
    class func saveRecipeForCurrentUser(recipe: Recipe) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let currentDate = Date.init()
        let dateString = dateFormatter.string(from: currentDate)
        
        let dict = ["name" : recipe.name,
                    "cookingTime" : recipe.cookingTime,
                    "briefDescription" : "na",
                    "ingridients" : recipe.ingridients,
                    "steps" : recipe.steps,
                    "FAVORITE" : false,
                    "COOKED" : false,
                    "cookedCount" : 0,
                    "photos" : "na",
                    "dateAdded" : dateString,] as [String : Any]
        Database.database().reference().child(BackendManager.shared.user.uid).child("recipes").child(recipe.name).updateChildValues(dict)
        
    }
    
    class func favoriteRecipe(recipe: Recipe){
        Database.database().reference().child(BackendManager.shared.user.uid).child("recipes").child(recipe.name).updateChildValues(["FAVORITE": true])
    }
    
    class func unfavoriteRecipe(recipe: Recipe){
        Database.database().reference().child(BackendManager.shared.user.uid).child("recipes").child(recipe.name).updateChildValues(["FAVORITE": false])
    }
    
    
    
    
}
