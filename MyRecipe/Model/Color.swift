//
//  Color.swift
//  MyRecipe
//
//  Created by Thiago Hissa on 2018-07-03.
//  Copyright © 2018 thiagohisss. All rights reserved.
//

import UIKit

class Color: NSObject {
    
    let gl: CAGradientLayer!
    let imageName: String!
    
    override init() {
        let top = UIColor(red: 38/255, green: 87/255, blue: 153/255, alpha: 1).cgColor
        let bottom = UIColor(red: 60/255, green: 169/255, blue: 205/255, alpha: 1).cgColor
        self.gl = CAGradientLayer()
        self.gl.colors = [top, bottom]
        self.gl.locations = [0.0,1.0]
        self.imageName = ""
    }
    
    init(top: UIColor, bottom: UIColor){
        self.gl = CAGradientLayer()
        self.gl.colors = [top.cgColor, bottom.cgColor]
        self.gl.locations = [0.0,1.0]
        self.imageName = ""
    }
    
    init(top: UIColor, bottom: UIColor, imageName: String){
        self.gl = CAGradientLayer()
        self.gl.colors = [top.cgColor, bottom.cgColor]
        self.gl.locations = [0.0,1.0]
        self.imageName = imageName
}

}
