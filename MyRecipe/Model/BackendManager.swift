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
    var shareRecipe: Recipe!
    
    //MARK: Sign In / Sign Up
    class func createUserFor(email: String, password: String, username: String, completion: @escaping (_ uid: String?,_ error: Error?) -> Void) {
        print("BackendManager User Creation - Creating user...")
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil {
                print("BackendManager User Creation - User created")
                completion(result?.user.uid, error)
                BackendManager.shared.user = User.init(name: username, uid: (result?.user.uid)!, recipes: nil)
                Database.database().reference().child("emails").child(BackendManager.shared.user.uid).updateChildValues(["email":email])
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
    
    //MARK: Recipes
    class func saveRecipeForCurrentUser(recipe: Recipe) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let currentDate = Date.init()
        let dateString = dateFormatter.string(from: currentDate)
        
        if recipe.briefDescription == "" {
            recipe.briefDescription = "No description for this recipe"
        }
        
        let dict = ["name" : recipe.name,
                    "cookingTime" : recipe.cookingTime,
                    "briefDescription" : recipe.briefDescription!,
                    "ingridients" : recipe.ingridients,
                    "steps" : recipe.steps,
                    "FAVORITE" : false,
                    "COOKED" : false,
                    "cookedCount" : 0,
                    "photos" : "na",
                    "dateAdded" : dateString,
                    "tags" : recipe.tags ?? ["NA"],
                    "SHARED" : false,
                    "sharedBy" : "nil"] as [String : Any]
        Database.database().reference().child(BackendManager.shared.user.uid).child("recipes").child(recipe.name).updateChildValues(dict)
        BackendManager.shared.user.recipes?.append(recipe)
    }
    
    class func getRecipesForCurrentUser(completion: @escaping (_ arrayOfRecipes: [Recipe]?)-> Void) {
        Database.database().reference().child(BackendManager.shared.user.uid).child("recipes").observe(.value, with: { (snap) in
            if snap.exists() { // Fetch Recipes
                let value = snap.value as! NSDictionary
                var arrayOfRecipes: [Recipe] = []
                for recipe in value {
                    let new_recipe = Recipe.init(dict: recipe.value as! NSDictionary)
                    arrayOfRecipes.append(new_recipe)
                }
                completion(arrayOfRecipes)
                BackendManager.shared.user.recipes = arrayOfRecipes
            }
        })
    }
    
    class func favoriteRecipe(recipe: Recipe){
        Database.database().reference().child(BackendManager.shared.user.uid).child("recipes").child(recipe.name).updateChildValues(["FAVORITE": true])
        for somerecipe in BackendManager.shared.user.recipes! {
            if somerecipe == recipe {
                recipe.FAVORITE = true
            }
        }
    }
    
    class func unfavoriteRecipe(recipe: Recipe){
        Database.database().reference().child(BackendManager.shared.user.uid).child("recipes").child(recipe.name).updateChildValues(["FAVORITE": false])
        for somerecipe in BackendManager.shared.user.recipes! {
            if somerecipe == recipe {
                recipe.FAVORITE = false
            }
        }
    }
    
    class func deleteRecipe(recipe: Recipe){
        Database.database().reference().child(BackendManager.shared.user.uid).child("recipes").child(recipe.name).removeValue()
        for i in 0..<BackendManager.shared.user.recipes!.count {
            if recipe == BackendManager.shared.user.recipes![i] {
                BackendManager.shared.user.recipes?.remove(at: i)
            }
        }
    }
    
    class func saveSharedRecipe(recipe: Recipe){
        Database.database().reference().child(BackendManager.shared.user.uid).child("recipes").child(recipe.name).updateChildValues(["SHARED": false])
        for somerecipe in BackendManager.shared.user.recipes! {
            if somerecipe == recipe {
                recipe.SHARED = false
            }
        }
    }
    
    class func sendRecipeToEmail(email: String, completion: @escaping (_ errorString: String) -> Void) {
        var errorString = "nil"
        Auth.auth().fetchProviders(forEmail: email) { (arrayOfStrings, error) in
            if error == nil && arrayOfStrings != nil {
                // user found
                Database.database().reference().child("emails").queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .childAdded, with: { snapshot in
                    if snapshot.value != nil {
                        print(snapshot.key)
                        let userID = snapshot.key
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd-MM-yyyy"
                        let currentDate = Date.init()
                        let dateString = dateFormatter.string(from: currentDate)
                        let recipe = BackendManager.shared.shareRecipe!
                        let dict = ["name" : recipe.name,
                                    "cookingTime" : recipe.cookingTime,
                                    "briefDescription" : recipe.briefDescription ?? "No description for this recipe",
                                    "ingridients" : recipe.ingridients,
                                    "steps" : recipe.steps,
                                    "FAVORITE" : false,
                                    "COOKED" : false,
                                    "cookedCount" : 0,
                                    "photos" : "na",
                                    "dateAdded" : dateString,
                                    "tags" : recipe.tags ?? ["NA"],
                                    "SHARED" : true,
                                    "sharedBy" : BackendManager.shared.user.username] as [String : Any]
                        Database.database().reference().child(userID).child("recipes").child(recipe.name).updateChildValues(dict)
                    }
                    completion(errorString)
                })
            }
            else{
                // user not found
                errorString = "User \(email) not found. Please make sure you've got the right email."
                completion(errorString)
            }
        }

    }
    
    
    
    
    
}
