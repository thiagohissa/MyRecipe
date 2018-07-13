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
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titleWrapView: UIView!
    @IBOutlet weak var xibWrapView: UIView!
    @IBOutlet weak var selectionTitle: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    var arrayOfTitles: [String]!
    var arrayOfIMGNames: [String]!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareUI()
        super.loadWhiteScreenTransition()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        super.removeWhiteScreenTransition()
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
        self.usernameLabel.text = "Hi \(self.user.username)"
    }
    
    
    @IBAction func settingsTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SegueToSettings", sender: nil)
    }
    
   

}





