//
//  SettingsViewController.swift
//  MyRecipe
//
//  Created by Thiago Hissa on 2018-07-11.
//  Copyright © 2018 thiagohisss. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsViewController: BaseViewController {

    var bglayer: CAGradientLayer!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.signOutButton.layer.cornerRadius = 20
        self.signOutButton.layer.borderColor = UIColor.white.cgColor
        self.signOutButton.layer.borderWidth = 1.0
    }

    //MARK: IBAction
    @IBAction func signOutTapped(_ sender: UIButton) {
        let vc = UIStoryboard.init(name: "SignSignUp", bundle: Bundle.main).instantiateInitialViewController() as! SignInViewController
        vc.loadWhiteScreenTransition()
        if let _ = try? Auth.auth().signOut() {
            super.presentLoadingScreen()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.present(vc, animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + vc.loadingScreenDuration, execute: {
                    vc.removeWhiteScreenTransition()
                })
            })
        }
        else{
            super.presentAlert(title: "ERROR", message: "Ops, something went wrong. Try logging out later.")
        }
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
