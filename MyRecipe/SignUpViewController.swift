//
//  SignUpViewController.swift
//  MyRecipe
//
//  Created by Thiago Hissa on 2018-07-05.
//  Copyright © 2018 thiagohisss. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var titleWrap: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
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
        self.emailTextField.layer.addSublayer(border1)
        self.emailTextField.layer.masksToBounds = true
        self.passwordTextField.layer.addSublayer(border2)
        self.passwordTextField.layer.masksToBounds = true
        self.rePasswordTextField.layer.addSublayer(border3)
        self.rePasswordTextField.layer.masksToBounds = true
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
    }
    

}
