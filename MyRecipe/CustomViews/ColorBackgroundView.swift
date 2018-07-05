//
//  ColorBackgroundView.swift
//  MyRecipe
//
//  Created by Thiago Hissa on 2018-07-05.
//  Copyright © 2018 thiagohisss. All rights reserved.
//

import UIKit

class ColorBackgroundView: UIView {
    
    var bglayer: CAGradientLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // BG Color
        let gradientcolor = Color.init(top: UIColor.init(red: 254/255, green: 184/255, blue: 141/255, alpha: 0.8), bottom: UIColor.init(red: 246/255, green: 133/255, blue: 148/255, alpha: 0.8))
        self.backgroundColor = UIColor.clear
        self.bglayer = gradientcolor.gl
        self.bglayer.frame = self.frame
        self.layer.insertSublayer(bglayer, at: 0)
    }

}
