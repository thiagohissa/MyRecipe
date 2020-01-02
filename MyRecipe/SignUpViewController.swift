//
//  SignUpViewController.swift
//  MyRecipe
//
//  Created by Thiago Hissa on 2018-07-05.
//  Copyright © 2018 thiagohisss. All rights reserved.
//

import UIKit

class SignUpViewController: BaseViewController {
    
    //MARK: Properties
    @IBOutlet weak var titleWrap: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleWrap.layer.cornerRadius = 40
        self.doneButton.layer.cornerRadius = 20
        self.prepareUI()
    }
    

    
    func prepareUI(){
        self.nameTextField.layer.masksToBounds = true
        self.emailTextField.layer.masksToBounds = true
        self.passwordTextField.layer.masksToBounds = true
        self.rePasswordTextField.layer.masksToBounds = true
        self.emailTextField.layer.cornerRadius = 16
        self.passwordTextField.layer.cornerRadius = 16
        self.rePasswordTextField.layer.cornerRadius = 16
        self.nameTextField.layer.cornerRadius = 16
    }

    
    //MARK: IBActions
    @IBAction func loginTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        if self.nameTextField.text?.isEmpty ?? false || self.emailTextField.text?.isEmpty ?? false || self.passwordTextField.text?.isEmpty ?? false || self.rePasswordTextField.text?.isEmpty ?? false {
            print("SignUp - Textfields Incomplete")
            super.presentAlert(title: "EMPTY FIELDS", message: "Please make sure you have entered all required fields")
        }
        else if !(self.emailTextField.text?.contains("@"))!{
            super.presentAlert(title: "EMAIL FORMAT", message: "Please make sure you have entered your email properly")
        }
        else if self.passwordTextField.text != self.rePasswordTextField.text{
            super.presentAlert(title: "PASSWORDS MISMATCH", message: "The passwords you have entered don't match")
        }
        else if self.passwordTextField.text == self.rePasswordTextField.text {
            
            let email = self.emailTextField.text!
            let password = self.passwordTextField.text!
            let username = self.nameTextField.text!
            
            super.presentLoadingScreen()
            
            BackendManager.createUserFor(email: email, password: password, username: username, completion: { (uid, error) in
                if error == nil && uid != nil {
                    print("SignUp - Proceeding to MainViewController")
                    BackendManager.saveUserInitialValues(name: username, uid: uid!)
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateInitialViewController() as! MainViewController
                    self.present(vc, animated: true, completion: nil)
                }
                else{
                    super.removeLoadingScreen()
                    print("SignUp - Error detected: \(String(describing: error?.localizedDescription))")
                    DispatchQueue.main.asyncAfter(deadline: .now() + super.loadingScreenDuration, execute: {
                        let message = (error?.localizedDescription)!
                        super.presentAlert(title: "ERROR", message: "\(message)")
                    })
                }
            })
        }
    }
    


}
