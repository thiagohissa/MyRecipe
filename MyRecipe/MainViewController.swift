//
//  MainViewController.swift
//  MyRecipe
//
//  Created by Thiago Hissa on 2018-07-03.
//  Copyright © 2018 thiagohisss. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    //MARK: Properties
    var bglayer: CAGradientLayer!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var xibWrapView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // BG Color
        let gradientcolor = Color.init(top: UIColor.init(red: 254/255, green: 184/255, blue: 141/255, alpha: 1.0), bottom: UIColor.init(red: 246/255, green: 133/255, blue: 148/255, alpha: 1.0))
        self.backgroundView.backgroundColor = UIColor.clear
        self.bglayer = gradientcolor.gl
        self.bglayer.frame = self.view.frame
        self.backgroundView.layer.insertSublayer(bglayer, at: 0)
        self.backgroundView.alpha = 0.86
        
    }

   

}
