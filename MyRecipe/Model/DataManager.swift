//
//  DataManager.swift
//  MyRecipe
//
//  Created by Thiago Hissa on 2018-07-03.
//  Copyright © 2018 thiagohisss. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    class func getEmptyRecipe() -> Recipe{
        return Recipe.init(name: "", cookingTime: 0, briefDescription: "", ingridients: [""], steps: [""], FAVORITE: false, COOKED: false, cookedCount: 0, photos: [Data.init()], dateAdded: Date.init(), tags: [""],SHARED: false, sharedBy: "")
    }
    
    class func getFavoritesFromCurrentUser() -> [Recipe]? {
        let user = BackendManager.shared.user
        var arrayOfFavorites: [Recipe]? = []
        for recipe in user?.recipes ?? [] {
            if recipe.FAVORITE {
                arrayOfFavorites?.append(recipe)
            }
        }
        return arrayOfFavorites
    }
    
    class func getDateFromString(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateFromString = dateFormatter.date(from: string)
        return dateFromString!
    }
    
    
}

