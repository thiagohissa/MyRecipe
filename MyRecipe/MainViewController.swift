//
//  MainViewController.swift
//  MyRecipe
//
//  Created by Thiago Hissa on 2018-07-03.
//  Copyright © 2018 thiagohisss. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {
    //MARK: Properties
    var bglayer: CAGradientLayer!
    @IBOutlet weak var usernameLabel: UILabel!
    var arrayOfTitles: [String]!
    var arrayOfIMGNames: [String]!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = BackendManager.shared.user
        self.prepareUI()
        super.loadWhiteScreenTransition()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        super.removeWhiteScreenTransition()
    }
    
    func prepareUI(){
        self.usernameLabel.text = "Hi \(self.user.username)"
    }
    
    
    @IBAction func settingsTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SegueToSettings", sender: nil)
    }
    
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToRecipes" {
            let vc = segue.destination as! RecipesViewController
            vc.isFavorites = false
            vc.pageTitle = "RECIPES"
        }
    }
    
   

}





