//
//  SearchViewController.swift
//  MyRecipe
//
//  Created by Thiago Hissa on 2018-08-09.
//  Copyright © 2018 thiagohisss. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var noResultLine: UIView!
    @IBOutlet weak var searchWrap: UIView!
    var arrayOfRecipes: [Recipe]!
    var isNoResultsFound: Bool!
    // Preview
    @IBOutlet weak var wrapTablePopup: UIView!
    @IBOutlet weak var previewTable: UITableView!
    @IBOutlet weak var previewTitle: UILabel!
    @IBOutlet weak var switchTableButton: UIButton!
    @IBOutlet weak var saveFromDetails: WhiteButton!
    var isIngridients: Bool!
    var arrayOfIngridients: [String]!
    var arrayOfSteps: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arrayOfRecipes = DataManager.getRecipesFromCurrentUser()
        self.tableView.estimatedRowHeight = 180
        self.isNoResultsFound = false
        self.searchWrap.layer.applySketchShadow(color: UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1.0), alpha: 0.5, x: 0, y: 2, blur: 4, radius: 2.5, spread: 0)
        self.arrayOfIngridients = []
        self.arrayOfSteps = []
        self.isIngridients = true
        self.updateResults()
        self.prepareUI()
    }
    
    func prepareUI(){
        self.wrapTablePopup.layer.cornerRadius = 18
        self.previewTable.estimatedRowHeight = 120
        let maskPath1 = UIBezierPath(roundedRect: self.wrapTablePopup.bounds, byRoundingCorners: [.topLeft], cornerRadii: CGSize(width: 100, height: 100))
        let shape1 = CAShapeLayer()
        shape1.path = maskPath1.cgPath
        self.wrapTablePopup.layer.mask = shape1
        self.searchTextField.attributedPlaceholder = NSAttributedString.init(string: "Type Here", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
    
    //MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.tableView == tableView {
            return self.arrayOfRecipes.count
        }
        else{
            if self.isIngridients {
                return self.arrayOfIngridients.count
            }
            return self.arrayOfSteps.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.tableView == tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SearchCell
            let recipe = self.arrayOfRecipes[indexPath.section]
            cell.name.text = recipe.name
            cell.briefDescription.text = recipe.briefDescription
            cell.minute.text = "Ready in \(String(recipe.cookingTime))min"
            cell.detailsButton.tag = indexPath.section
            cell.saveButton.tag = indexPath.section
            return cell
        }
        else{
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 100))
        header.backgroundColor = UIColor.clear
        return header
    }
    
    

    //MARK: IBAction
    @IBAction func saveRecipeTapped(_ sender: UIButton) {
        let selectedRecipe = self.arrayOfRecipes[sender.tag]
        BackendManager.saveRecipeForCurrentUser(recipe: selectedRecipe)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            super.presentAlert(title: "RECIPE SAVED", message: "\(selectedRecipe.name) was saved to your recipes!")
        }
    }
    @IBAction func detailsTapped(_ sender: UIButton) {
        self.seeTapped(sender)
    }
    @IBAction func searchTapped(_ sender: UIButton) {
    }
    
    func seeTapped(_ sender: UIButton) {
        var array1Empty = false
        var array2Empty = false
        self.saveFromDetails.tag = sender.tag
        let thisrecipe = self.arrayOfRecipes[sender.tag]
        self.arrayOfSteps = thisrecipe.steps
        self.arrayOfIngridients = thisrecipe.ingridients
        if self.arrayOfIngridients.isEmpty { array1Empty = true}
        if self.arrayOfSteps.isEmpty { array2Empty = true }
        
        if array1Empty && array2Empty {
            super.presentAlert(title: "BOOMER", message: "This Recipe does not have Steps or Ingridients.")
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
                super.presentAlert(title: "NO STEPS", message: "No Steps for this Recipe")
                return
            }
            self.isIngridients = false
            self.previewTable.reloadData()
            self.previewTitle.text = "STEPS"
            self.switchTableButton.setTitle("See Ingridients", for: .normal)
        }
        else{
            if self.arrayOfSteps.isEmpty {
                super.presentAlert(title: "NO INGRIDIENTS", message: "No Ingridients for this Recipe")
                return
            }
            self.isIngridients = true
            self.previewTable.reloadData()
            self.previewTitle.text = "INGRIDIENTS"
            self.switchTableButton.setTitle("See Steps", for: .normal)
        }
    }
    
    @IBAction func saveFromDetailsTapped(_ sender: UIButton) {
        self.saveRecipeTapped(sender)
        self.removePreview()
    }
    
    @IBAction func okTapped(_ sender: UIButton) {
        self.removePreview()
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Search
    func searchString(string: String) {
        // search for word function should return an arrayOfRecipes
        // make self.arrayOfRecipes = arrayOfRecipes returned by function
        if self.arrayOfRecipes.count == 0 || self.arrayOfRecipes == nil {
            self.isNoResultsFound = true
        }
        else {
            self.isNoResultsFound = false
        }
    }
    
    func updateResults(){
        if self.isNoResultsFound {
            self.tableView.isHidden = true
            self.noResultLabel.isHidden = false
            self.noResultLine.isHidden = false
        }
        else{
            self.tableView.isHidden = false
            self.noResultLabel.isHidden = true
            self.noResultLine.isHidden = true
        }
    }
    
    //MARK: Preview animation
    func presentPreview(){
        if self.isIngridients {
            self.previewTitle.text = "INGRIDIENTS"
        } else { self.previewTitle.text = "STEPS" }
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
    
    


}

class SearchCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var minute: UILabel!
    @IBOutlet weak var briefDescription: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var wrapView: UIView!
    
    override func awakeFromNib() {
        self.wrapView.layer.applySketchShadow(color: UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1.0), alpha: 0.5, x: 0, y: 2, blur: 4, radius: 2.5, spread: 0)
        self.wrapView.layer.cornerRadius = 18
        self.saveButton.layer.cornerRadius = 14
        self.detailsButton.layer.cornerRadius = 14
        self.saveButton.layer.applySketchShadow(color: UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1.0), alpha: 0.5, x: 0, y: 2, blur: 4, radius: 2.5, spread: 0)
        self.detailsButton.layer.applySketchShadow(color: UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1.0), alpha: 0.5, x: 0, y: 2, blur: 4, radius: 2.5, spread: 0)
    }
    
}
