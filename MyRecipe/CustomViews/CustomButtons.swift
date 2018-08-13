//
//  whiteButton.swift
//  MyRecipe
//
//  Created by Thiago Hissa on 2018-08-13.
//  Copyright © 2018 thiagohisss. All rights reserved.
//

import UIKit

class WhiteButton: UIButton {
    override func awakeFromNib() {
        self.layer.applySketchShadow(color: UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1.0), alpha: 0.5, x: 0, y: 2, blur: 4, radius: 2.5, spread: 0)
        self.layer.cornerRadius = 14
    }
}

class ColorButton: UIButton {
    override func awakeFromNib() {
        self.layer.applySketchShadow(color: UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1.0), alpha: 0.5, x: 0, y: 2, blur: 4, radius: 2.5, spread: 0)
        self.layer.cornerRadius = 14
    }
}
