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
    @IBOutlet weak var previewTitle: UILabel!
    @IBOutlet weak var switchTableButton: UIButton!
    @IBOutlet weak var recipeNameTextField: TextField!
    @IBOutlet weak var cookingtimeTextField: TextField!
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
        self.switchTableButton.layer.cornerRadius = 18
        // Text fields
        self.ingridientTextField.layer.borderWidth = 1
        self.ingridientTextField.layer.cornerRadius = 8
        self.ingridientTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.recipeNameTextField.layer.borderWidth = 1
        self.recipeNameTextField.layer.cornerRadius = 8
        self.recipeNameTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.cookingtimeTextField.layer.borderWidth = 1
        self.cookingtimeTextField.layer.cornerRadius = 8
        self.cookingtimeTextField.layer.borderColor = UIColor.lightGray.cgColor
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            if self.isIngridients {
                print("Delete this row for ingridients")
                self.arrayOfIngridients.remove(at: indexPath.section)
            }
            else{
                print("Delete this row for steps")
                self.arrayOfSteps.remove(at: indexPath.section)
            }
            self.previewTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            self.previewTable.dataSource?.tableView!(self.previewTable, commit: .delete, forRowAt: indexPath)
            return
        })
        deleteButton.backgroundColor = UIColor.init(red: 241/255, green: 146/255, blue: 153/255, alpha: 1)
        return [deleteButton]
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
        var array1Empty = false
        var array2Empty = false
        if self.arrayOfIngridients.isEmpty { array1Empty = true}
        if self.arrayOfSteps.isEmpty { array2Empty = true }

        
        if array1Empty && array2Empty {
            super.presentAlert(title: "EMPTY FIELDS", message: "Please add at least 1 ingridient or 1 step to see a preview.")
            self.wrapTablePopup.isHidden = true
        }
        else{
            self.isIngridients = !array1Empty
            self.presentPreview()
        }
    }
    
    @IBAction func switchTableTapped(_ sender: UIButton) {
        if self.isIngridients {
            if self.arrayOfSteps.isEmpty {
                super.presentAlert(title: "EMPTY STEPS", message: "You have no steps")
                return
            }
            self.isIngridients = false
            self.previewTable.reloadData()
            self.previewTitle.text = "STEPS"
            self.switchTableButton.setTitle("See Ingridients", for: .normal)
        }
        else{
            if self.arrayOfSteps.isEmpty {
                super.presentAlert(title: "EMPTY INGRIDIENTS", message: "You have no ingridients")
                return
            }
            self.isIngridients = true
            self.previewTable.reloadData()
            self.previewTitle.text = "INGRIDIENTS"
            self.switchTableButton.setTitle("See Steps", for: .normal)
        }
    }
    
    @IBAction func okTapped(_ sender: UIButton) {
        self.removePreview()
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneTapped(_ sender: UIButton) {
        if (self.recipeNameTextField.text?.isEmpty)! || (self.cookingtimeTextField.text?.isEmpty)! || self.arrayOfIngridients.isEmpty || self.arrayOfSteps.isEmpty {
            super.presentAlert(title: "EMPTY FIELDS", message: "Make sure to have filled out all spaces and to have included at least 1 ingridient and 1 step.")
        }
        else{
            let recipe = Recipe.init(name: self.recipeNameTextField.text!, cookingTime: Int(self.cookingtimeTextField.text!)!, briefDescription: "", ingridients: self.arrayOfIngridients, steps: self.arrayOfSteps, FAVORITE: false, COOKED: false, cookedCount: 0, photos: [Data.init()], dateAdded: Date.init(), tags: [""])
            BackendManager.saveRecipeForCurrentUser(recipe: recipe)
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
    
    //MARK: Preview animation
    func presentPreview(){
        if self.isIngridients {
            self.previewTitle.text = "INGRIDIENTS"
        } else { self.previewTitle.text = "STEPS" }
        self.ingridientTextField.endEditing(true)
        self.stepsTextView.endEditing(true)
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




