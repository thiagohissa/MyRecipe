//
//  CreateRecipeViewController.swift
//  MyRecipe
//
//  Created by Thiago Hissa on 2018-07-13.
//  Copyright © 2018 thiagohisss. All rights reserved.
//

import UIKit

class CreateRecipeViewController: BaseViewController, UITextViewDelegate {

    //MARK: Properties
    var bglayer: CAGradientLayer!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var xibWrapView: UIView!
    @IBOutlet weak var ingridientTextField: UITextField!
    @IBOutlet weak var stepsTextView: UITextView!
    var arrayOfIngridients: [String] = []
    var arrayOfSteps: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareUI()
        self.stepsTextView.delegate = self
    }
    
    func prepareUI(){
        // BG Color
        let gradientcolor = Color.init(top: UIColor.init(red: 254/255, green: 184/255, blue: 141/255, alpha: 0.8), bottom: UIColor.init(red: 246/255, green: 133/255, blue: 148/255, alpha: 0.8))
        self.backgroundView.backgroundColor = UIColor.clear
        self.bglayer = gradientcolor.gl
        self.bglayer.frame = self.view.frame
        self.backgroundView.layer.insertSublayer(bglayer, at: 0)
        // Xib Wrapper Edge
        self.xibWrapView.layer.cornerRadius = 8
        let maskPath = UIBezierPath(roundedRect: self.xibWrapView.bounds, byRoundingCorners: [.topLeft], cornerRadii: CGSize(width: 100, height: 100))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        self.xibWrapView.layer.mask = shape
        //Buttons
        for view in self.xibWrapView.subviews {
            if view is UIButton {
                view.layer.cornerRadius = 18
            }
        }
        // Text fields
        self.ingridientTextField.layer.borderWidth = 1
        self.ingridientTextField.layer.cornerRadius = 8
        self.ingridientTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.stepsTextView.layer.borderWidth = 1
        self.stepsTextView.layer.cornerRadius = 18
        self.stepsTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.stepsTextView.text = "Enter Step Here"
        self.stepsTextView.textColor = UIColor.lightGray
    }
    
    //MARK: IBActions
    @IBAction func nextTapped(_ sender: UIButton) {
        if sender.tag == 1 {
            if (self.ingridientTextField.text?.isEmpty)! {
                super.presentAlert(title: "EMPTY FIELD", message: "Please make sure you have entered all required fields")
                return
            }
            // add to ingridient array
            self.arrayOfIngridients.append(self.ingridientTextField.text!)
            self.ingridientTextField.text = nil
        }
        else{
            if self.stepsTextView.text == "Enter Step Here" {
                super.presentAlert(title: "EMPTY FIELD", message: "Please make sure you have entered all required fields")
                return
            }
            // add to step array
             self.arrayOfSteps.append(self.stepsTextView.text!)
            self.stepsTextView.text = "Enter Step Here"
            self.stepsTextView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func seeTapped(_ sender: UIButton) {
        if sender.tag == 1 {
            // show ingridient table
        }
        else{
            // show step table
        }
    }
    
    //MARK :TextField Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.stepsTextView.textColor == UIColor.lightGray {
            self.stepsTextView.text = nil
            self.stepsTextView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.stepsTextView.text.isEmpty {
            self.stepsTextView.text = "Enter Step Here"
            self.stepsTextView.textColor = UIColor.lightGray
        }
    }


}
