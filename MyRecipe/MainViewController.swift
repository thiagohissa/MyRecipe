//
//  MainViewController.swift
//  MyRecipe
//
//  Created by Thiago Hissa on 2018-07-03.
//  Copyright © 2018 thiagohisss. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: Properties
    var bglayer: CAGradientLayer!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleWrapView: UIView!
    @IBOutlet weak var xibWrapView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectionTitle: UILabel!
    var arrayOfTitles: [String]!
    var arrayOfIMGNames: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareUI()
        self.arrayOfTitles = ["Recipes", "New Recipe","Favourites", "Search"]
        self.arrayOfIMGNames = ["icon_book","icon_plus","icon_heartFull","icon_search"]
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
        // Title Wrap Edge
        self.titleWrapView.layer.cornerRadius = 40
    }
    
    //MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellMenu") as! MenuCell
        cell.name.text = self.arrayOfTitles[indexPath.row]
        cell.icon.image = UIImage.init(named: self.arrayOfIMGNames[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RecipesViewController") as! RecipesViewController
            self.present(vc, animated: true, completion: nil)
        default:
            break
        }
    }
    
   

}





