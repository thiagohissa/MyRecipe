//
//  ShareView.swift
//  MyRecipe
//
//  Created by Thiago Hissa on 2018-08-02.
//  Copyright © 2018 thiagohisss. All rights reserved.
//

import UIKit

class ShareView: UIView {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var descriptiveText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 20
        self.sendButton.layer.cornerRadius = 18
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft], cornerRadii: CGSize(width: 100, height: 100))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        self.layer.mask = shape
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ShareView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    @IBAction func sendTapped(_ sender: UIButton) {
        if !(self.emailTextField.text?.isEmpty)! {
            BackendManager.sendRecipeToEmail(email: self.emailTextField.text!) { (errorString) in
                if errorString == "nil" {
                    self.descriptiveText.text = "The recipe \(BackendManager.shared.shareRecipe.name) was sent to user \(self.emailTextField.text!)."
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                        let notificationName = Notification.Name("REMOVE_SHAREVIEW_NOTIFICATION")
                        NotificationCenter.default.post(name: notificationName, object: nil)
                    })
                }
                else{
                    self.descriptiveText.text = errorString
                }
            }
        }
    }
    
    
    
}
