//
//  AppDelegate.swift
//  MyRecipe
//
//  Created by Thiago Hissa on 2018-07-03.
//  Copyright © 2018 thiagohisss. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        application.isStatusBarHidden = false
        application.statusBarStyle = .lightContent
        IQKeyboardManager.shared.enable = true
        self.checkIUserIsSignIn()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func checkIUserIsSignIn(){
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                // User is sign in
                Database.database().reference().child(user.uid).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                    if snapshot.exists() {
                        let value = snapshot.value as! NSDictionary
                        let uid = user.uid
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
                            BackendManager.shared.user = user
                            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
//                            vc.user = user
                            self.window?.rootViewController?.present(vc, animated: true, completion: nil)
                        })
                    }
                })
            }
            else{
                // User is sign out
            }
        }
    }


}

