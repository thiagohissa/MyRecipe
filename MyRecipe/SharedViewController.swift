//
//  SharedViewController.swift
//  MyRecipe
//
//  Created by Thiago Hissa on 2018-08-06.
//  Copyright © 2018 thiagohisss. All rights reserved.
//

import UIKit

class SharedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var xibWrapView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var arrayOfRecipes: [Recipe]!
    var bglayer: CAGradientLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arrayOfRecipes = DataManager.getSharedRecipesFromCurrentUser()
        self.prepareUI()
    }

    func prepareUI(){
        // BG Color
        let gradientcolor = Color.init(top: UIColor.init(red: 254/255, green: 184/255, blue: 141/255, alpha: 0.8), bottom: UIColor.init(red: 246/255, green: 133/255, blue: 148/255, alpha: 0.8))
        self.bglayer = gradientcolor.gl
        self.bglayer.frame = self.view.frame
        // Xib Wrapper Edge
//        self.xibWrapView.layer.cornerRadius = 8
//        let maskPath = UIBezierPath(roundedRect: self.xibWrapView.bounds, byRoundingCorners: [.topLeft], cornerRadii: CGSize(width: 100, height: 100))
//        let shape = CAShapeLayer()
//        shape.path = maskPath.cgPath
//        self.xibWrapView.layer.mask = shape
    }
    
    //MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.arrayOfRecipes.count == 0 {
            return 1
        }
        else{
            return self.arrayOfRecipes.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SharedCell
        if self.arrayOfRecipes.count == 0 {
            cell.name.text = "No Recipes yet"
            cell.sentByLabel.text = "No recipes were shared with you yet"
            cell.saveButton.isHidden = true
        }
        else{
            cell.name.text = self.arrayOfRecipes[indexPath.section].name
            cell.sentByLabel.text = "Sent by \(self.arrayOfRecipes[indexPath.section].sharedBy)"
            cell.saveButton.tag = indexPath.section
            cell.saveButton.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
            // TODO Delete Recipe
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
            return
        })
        deleteButton.backgroundColor = UIColor.init(red: 241/255, green: 146/255, blue: 153/255, alpha: 1)
        return [deleteButton]
    }
    
    //MARK: IBAction
    @IBAction func saveTapped(_ sender: UIButton) {
        // TODO Make a quick animation (this should be somewhat standart animation for the app)
        BackendManager.saveSharedRecipe(recipe: self.arrayOfRecipes[sender.tag])
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    


}

class SharedCell: UITableViewCell {
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var sentByLabel: UILabel!
    
    override func awakeFromNib() {
        self.saveButton.layer.cornerRadius = 15
    }
}



