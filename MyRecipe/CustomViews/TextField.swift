//
//  TextField.swift
//  MyRecipe
//
//  Created by Thiago Hissa on 2018-07-19.
//  Copyright © 2018 thiagohisss. All rights reserved.
//

import UIKit

class TextField: UITextField {
    
    override func awakeFromNib() {
        self.layer.applySketchShadow(color: UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1.0), alpha: 0.5, x: 0, y: 2, blur: 4, radius: 2.5, spread: 0)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 8
    }
    
    let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 5);
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}


