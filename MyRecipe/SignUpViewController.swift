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
        let border1 = CALayer()
        border1.borderColor = UIColor.white.cgColor
        border1.frame = CGRect(x: 0, y: emailTextField.frame.size.height - 1.0, width: emailTextField.frame.size.width, height: emailTextField.frame.size.height)
        border1.borderWidth = 1.0
        let border2 = CALayer()
        border2.borderColor = UIColor.white.cgColor
        border2.frame = CGRect(x: 0, y: emailTextField.frame.size.height - 1.0, width: emailTextField.frame.size.width, height: emailTextField.frame.size.height)
        border2.borderWidth = 1.0
        let border3 = CALayer()
        border3.borderColor = UIColor.white.cgColor
        border3.frame = CGRect(x: 0, y: emailTextField.frame.size.height - 1.0, width: emailTextField.frame.size.width, height: emailTextField.frame.size.height)
        border3.borderWidth = 1.0
        let border4 = CALayer()
        border4.borderColor = UIColor.white.cgColor
        border4.frame = CGRect(x: 0, y: emailTextField.frame.size.height - 1.0, width: emailTextField.frame.size.width, height: emailTextField.frame.size.height)
        border4.borderWidth = 1.0
        self.emailTextField.layer.addSublayer(border1)
        self.emailTextField.layer.masksToBounds = true
        self.passwordTextField.layer.addSublayer(border2)
        self.passwordTextField.layer.masksToBounds = true
        self.rePasswordTextField.layer.addSublayer(border3)
        self.rePasswordTextField.layer.masksToBounds = true
        self.nameTextField.layer.addSublayer(border4)
        self.nameTextField.layer.masksToBounds = true
        self.nameTextField.attributedPlaceholder = NSAttributedString(string: "First Name",
                                                                            attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                       attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                          attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        self.rePasswordTextField.attributedPlaceholder = NSAttributedString(string: "Re-enter Password",
                                                                          attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
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
