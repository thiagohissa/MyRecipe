//
//  CreateRecipeViewController.swift
//  MyRecipe
//
//  Created by Thiago Hissa on 2018-07-13.
//  Copyright © 2018 thiagohisss. All rights reserved.
//

import UIKit

class CreateRecipeViewController: BaseViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var xibWrapView: UIView!
    @IBOutlet weak var ingridientTextField: UITextField!
    @IBOutlet weak var stepsTextView: UITextView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var wrapTablePopup: UIView!
    @IBOutlet weak var previewTable: UITableView!
    var bglayer: CAGradientLayer!
    var arrayOfIngridients: [String] = []
    var arrayOfSteps: [String] = []
    var isIngridients: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareUI()
        self.stepsTextView.delegate = self
        self.isIngridients = true
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
        self.okButton.layer.cornerRadius = 18
        // Text fields
        self.ingridientTextField.layer.borderWidth = 1
        self.ingridientTextField.layer.cornerRadius = 8
        self.ingridientTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.stepsTextView.layer.borderWidth = 1
        self.stepsTextView.layer.cornerRadius = 18
        self.stepsTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.stepsTextView.text = "Enter Step Here"
        self.stepsTextView.textColor = UIColor.lightGray
        // TableView
        self.wrapTablePopup.layer.cornerRadius = 18
        self.previewTable.estimatedRowHeight = 120
        let maskPath1 = UIBezierPath(roundedRect: self.xibWrapView.bounds, byRoundingCorners: [.topLeft], cornerRadii: CGSize(width: 100, height: 100))
        let shape1 = CAShapeLayer()
        shape1.path = maskPath1.cgPath
        self.wrapTablePopup.layer.mask = shape1
    }
    
    //MARK: Tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.isIngridients {
            return self.arrayOfIngridients.count
        }
        return self.arrayOfSteps.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isIngridients {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2") as! PreviewIngridientsCell
            cell.name.text = self.arrayOfIngridients[indexPath.section]
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1") as! PreviewStepsCell
            cell.step.text = self.arrayOfSteps[indexPath.section]
            cell.stepsCountLabel.text = "\(indexPath.section+1) Step"
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 20))
        header.backgroundColor = UIColor.clear
        return header
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
            self.stepsTextView.text = nil
        }
    }
    
    @IBAction func seeTapped(_ sender: UIButton) {
        if sender.tag == 1 {
            self.isIngridients = true
            if self.arrayOfIngridients.isEmpty {
                super.presentAlert(title: "INGRIDIENTS", message: "There are no ingridients yet for this recipe")
            }
            else{
                self.presentPreview()
            }
        }
        else{
            self.isIngridients = false
            if self.arrayOfSteps.isEmpty {
                super.presentAlert(title: "STEPS", message: "There are no steps yet for this recipe")
            }
            else{
                self.presentPreview()
            }
        }
    }
    
    @IBAction func okTapped(_ sender: UIButton) {
        self.removePreview()
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
    
    //MARK: Preview animation
    func presentPreview(){
        self.previewTable.reloadData()
        self.wrapTablePopup.center.x = self.view.center.x
        self.wrapTablePopup.isHidden = false
        self.wrapTablePopup.center.y = 800
        self.view.addSubview(self.grayview)
        self.grayview.addSubview(self.wrapTablePopup)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 5.0, initialSpringVelocity: 3, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.wrapTablePopup.center.y = self.view.frame.height - (self.wrapTablePopup.frame.height/2) - 20
        }, completion: nil)
    }
    
    func removePreview(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 5.0, initialSpringVelocity: 3, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.wrapTablePopup.center.y = 1200
        }, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            self.wrapTablePopup.isHidden = true
            self.grayview.removeFromSuperview()
        }
    }
    
    //MARK: Animation
    func animateButton(sender: UIButton){
        UIView.animate(withDuration: 0.5) {
            sender.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        }
    }


}

class PreviewIngridientsCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
}

class PreviewStepsCell: UITableViewCell {
    @IBOutlet weak var stepsCountLabel: UILabel!
    @IBOutlet weak var step: UILabel!
}




