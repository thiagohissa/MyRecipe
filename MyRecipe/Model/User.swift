//
//  User.swift
//  MyRecipe
//
//  Created by Thiago Hissa on 2018-07-06.
//  Copyright © 2018 thiagohisss. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var username: String
    var uid: String
    var recipes: [Recipe]?

    init(name: String, uid: String, recipes: [Recipe]?) {
        self.username = name
        self.uid = uid
        self.recipes = recipes
    }

}
