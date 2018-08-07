//
//  SignInViewController.swift
//  MyRecipe
//
//  Created by Thiago Hissa on 2018-07-05.
//  Copyright © 2018 thiagohisss. All rights reserved.
//

import UIKit

class SignInViewController: BaseViewController {
    
    //MARK: Properties
    var bglayer: CAGradientLayer!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func prepareUI(){
        // BG Color
        let gradientcolor = Color.init(top: UIColor.init(red: 254/255, green: 184/255, blue: 141/255, alpha: 0.8), bottom: UIColor.init(red: 246/255, green: 133/255, blue: 148/255, alpha: 0.8))
        self.backgroundView.backgroundColor = UIColor.clear
        self.bglayer = gradientcolor.gl
        self.bglayer.frame = self.view.frame
        self.backgroundView.layer.insertSublayer(bglayer, at: 0)
        //Buttons
        self.loginButton.layer.cornerRadius = 20
        let border1 = CALayer()
        border1.borderColor = UIColor.white.cgColor
        border1.frame = CGRect(x: 0, y: emailTextField.frame.size.height - 1.0, width: emailTextField.frame.size.width, height: emailTextField.frame.size.height)
        border1.borderWidth = 1.0
        let border2 = CALayer()
        border2.borderColor = UIColor.white.cgColor
        border2.frame = CGRect(x: 0, y: emailTextField.frame.size.height - 1.0, width: emailTextField.frame.size.width, height: emailTextField.frame.size.height)
        border2.borderWidth = 1.0
        self.emailTextField.layer.addSublayer(border1)
        self.emailTextField.layer.masksToBounds = true
        self.passwordTextField.layer.addSublayer(border2)
        self.passwordTextField.layer.masksToBounds = true
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                       attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                       attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
    
    //MARK: IBActions
    @IBAction func loginTapped(_ sender: Any) {
        if (self.emailTextField.text?.isEmpty) ?? false || (self.passwordTextField.text?.isEmpty) ?? false {
            super.presentAlert(title: "EMPTY FIELD", message: "Please make sure you have entered all required fields")
        }
        else if !(self.emailTextField.text?.contains("@"))!{
            super.presentAlert(title: "EMAIL FORMAT", message: "Please make sure you have entered your email properly")
        }
        else{
            super.presentLoadingScreen()
            let email = self.emailTextField.text!
            let password = self.passwordTextField.text!
            BackendManager.loginUserWith(email: email, password: password, completion: { (user, error) in
                if user != nil {
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                    self.present(vc, animated: true, completion: nil)
                }
                else{
                    super.removeLoadingScreen()
                    print("SignInViewController - Error")
                    DispatchQueue.main.asyncAfter(deadline: .now() + super.loadingScreenDuration, execute: {
                        super.presentAlert(title: "ERROR", message: (error?.localizedDescription)!)
                    })
                }
            })
        }

    }
    
    @IBAction func signUpTapped(_ sender: Any) {
    }
    
}
