//
//  SearchViewController.swift
//  MyRecipe
//
//  Created by Thiago Hissa on 2018-08-09.
//  Copyright © 2018 thiagohisss. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var noResultLine: UIView!
    @IBOutlet weak var searchWrap: UIView!
    var arrayOfRecipes: [Recipe]!
    var isNoResultsFound: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arrayOfRecipes = DataManager.getRecipesFromCurrentUser()
        self.isNoResultsFound = false
        self.searchWrap.layer.applySketchShadow(color: UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1.0), alpha: 0.5, x: 0, y: 2, blur: 4, radius: 2.5, spread: 0)
        self.updateResults()
    }
    
    //MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayOfRecipes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SearchCell
        let recipe = self.arrayOfRecipes[indexPath.row]
        cell.name.text = recipe.name
        cell.briefDescription.text = recipe.briefDescription
        cell.minute.text = "Ready in \(String(recipe.cookingTime))min"
        return cell
    }
    
    

    //MARK: IBAction
    @IBAction func saveRecipeTapped(_ sender: UIButton) {
    }
    @IBAction func detailsTapped(_ sender: UIButton) {
    }
    @IBAction func searchTapped(_ sender: UIButton) {
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
