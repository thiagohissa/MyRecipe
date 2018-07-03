//
//  Recipe.swift
//  MyRecipe
//
//  Created by Thiago Hissa on 2018-07-03.
//  Copyright © 2018 thiagohisss. All rights reserved.
//

import UIKit

class Recipe: NSObject {
    
    var name: String
    var cookingTime: Int
    var briefDescription: String
    var ingridients: [String]
    var steps: [String]
    
    var FAVORITE: Bool
    var COOKED: Bool
    var cookedCount: Int
    var photos: [Data]!
    var dateAdded: Date
    var tags: [String]!
    
    init(name: String, cookingTime: Int, briefDescription: String, ingridients:[String], steps:[String], FAVORITE:Bool,COOKED: Bool, cookedCount: Int, photos:[Data], dateAdded:Date, tags:[String]) {
        self.name = name
        self.cookingTime = cookingTime
        self.briefDescription = briefDescription
        self.ingridients = ingridients
        self.steps = steps
        self.FAVORITE = FAVORITE
        self.COOKED = COOKED
        self.cookedCount = cookedCount
        self.photos = photos
        self.dateAdded = dateAdded
        self.tags = tags
    }
    
    init(dict: NSDictionary) {
        self.name = dict["name"] as! String
        self.cookingTime = dict["cookingTime"] as! Int
        self.briefDescription = dict["briefDescription"] as! String
        self.ingridients = dict["ingridients"] as! [String]
        self.steps = dict["steps"] as! [String]
        self.FAVORITE = dict["FAVORITE"] as! Bool
        self.COOKED = dict["COOKED"] as! Bool
        self.cookedCount = dict["cookedCount"] as! Int
        if let photos = dict["photos"] as! [Data]! { self.photos = photos }
        self.dateAdded = dict["dateAdded"] as! Date
        if let tags = dict["tags"] as! [String]! { self.tags = tags }
    }
    
    
}

