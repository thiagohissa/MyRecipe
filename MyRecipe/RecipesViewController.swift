//
//  RecipesViewController.swift
//  MyRecipe
//
//  Created by Thiago Hissa on 2018-07-03.
//  Copyright © 2018 thiagohisss. All rights reserved.
//

import UIKit

class RecipesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Properties
    var isCooking: Bool!
    @IBOutlet weak var selectionTitle: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var xibWrapView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newRecipeButton: UIButton!
    var bglayer: CAGradientLayer!
    var arrayOfRecipes: [Recipe]!
    var recipe: Recipe!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isCooking = false
        self.arrayOfRecipes = DataManager.getArrayOfRecipes()
        self.prepareUI()
        self.tableView.estimatedRowHeight = 120
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
        // Recipe Button
        self.newRecipeButton.layer.cornerRadius = 18
    }
    
    //MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.isCooking {
            return self.recipe.steps.count
        }
        return self.arrayOfRecipes.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !self.isCooking {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1") as! RecipeCell
            cell.name.text = "\(self.arrayOfRecipes[indexPath.section].name) "
            cell.briefDescription.text = self.arrayOfRecipes[indexPath.section].briefDescription
            cell.minute.text = " \(String(self.arrayOfRecipes[indexPath.section].cookingTime))min"
            cell.updateConstraintsIfNeeded()
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2") as! CookingCell
            cell.stepText.text = self.recipe.steps[indexPath.section]
            cell.stepLabelCount.text = "Step \(indexPath.section+1)"
            cell.updateConstraintsIfNeeded()
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.isCooking {
            self.recipe = self.arrayOfRecipes[indexPath.section]
            self.isCooking = true
            UIView.animate(withDuration: 1, animations: {
                self.tableView.alpha = 0
                self.selectionTitle.alpha = 0
            })
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                self.tableView.reloadData()
                self.selectionTitle.text = self.arrayOfRecipes[indexPath.section].name.uppercased()
                UIView.animate(withDuration: 0.5, animations: {
                    self.tableView.alpha = 1
                    self.selectionTitle.alpha = 1
                })
            })
        }
        else{
            let cell = self.tableView.cellForRow(at: indexPath) as! CookingCell
            cell.circleView.backgroundColor = UIColor.init(red: 244/255, green: 146/255, blue: 158/255, alpha: 1.0)
            let scrollIndex = IndexPath.init(row: indexPath.row, section: indexPath.section+1)
            self.tableView.scrollToRow(at: scrollIndex, at: UITableViewScrollPosition.top, animated: true)
        }
    }

    //MARK: IBAction
    
    @IBAction func backTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func heartButtonTapped(_ sender: UIButton) {
    }
    @IBAction func newRecipeTapped(_ sender: UIButton) {
    }
    
}

class RecipeCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var minute: UILabel!
    @IBOutlet weak var briefDescription: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    
}

class CookingCell: UITableViewCell {
    @IBOutlet weak var stepLabelCount: UILabel!
    @IBOutlet weak var stepText: UILabel!
    @IBOutlet weak var circleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.circleView.layer.borderWidth = 1
        self.circleView.layer.borderColor = UIColor.init(red: 244/255, green: 146/255, blue: 158/255, alpha: 1.0).cgColor
        self.circleView.layer.cornerRadius = self.circleView.frame.height/2
    }
    
}
