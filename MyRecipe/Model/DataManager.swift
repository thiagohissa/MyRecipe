//
//  DataManager.swift
//  MyRecipe
//
//  Created by Thiago Hissa on 2018-07-03.
//  Copyright © 2018 thiagohisss. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    class func getArrayOfRecipes() -> [Recipe]{
        let ingridients1 = ["1/4 cup butter","4 teaspoons chopped fresh parsley","4 (4 ounce) fillets salmon","1 Lemon","1/4 cup dry bread crumbs","3 tablespoons Dijon mustard","1 1/2 tablespoons honey","1/4 cup dry bread crumbs"]
        let steps1 = ["Preheat oven to 400 degrees F (200 degrees C).","In a small bowl, stir together butter, mustard, and honey. Set aside. In another bowl, mix together bread crumbs, pecans, and parsley.","Brush each salmon fillet lightly with honey mustard mixture, and sprinkle the tops of the fillets with the bread crumb mixture.","Bake salmon 12 to 15 minutes in the preheated oven, or until it flakes easily with a fork. Season with salt and pepper, and garnish with a wedge of lemon."]
        let tags1 = ["Seafood","Fish","Spicy","Breaded"]
        let tags2 = ["Steak","Spicy","Meat","Protein"]
        let tags3 = ["Pasta","Carbs","Vegetarian"]
        
        let recipe1 = Recipe.init(name: "Baked Dijon Salmon", cookingTime: 20, briefDescription: "Preheat oven to 400 degrees F (200 degrees C) next time!", ingridients: ingridients1, steps: steps1, FAVORITE: true, COOKED: true, cookedCount: 3, photos: [Data.init()], dateAdded: Date.init(), tags: tags1)
        let recipe2 = Recipe.init(name: "Steak and Fries", cookingTime: 35, briefDescription: "It goes very nice with aspargus.", ingridients: ingridients1, steps: steps1, FAVORITE: false, COOKED: false, cookedCount: 1, photos: [Data.init()], dateAdded: Date.init(), tags: tags2)
        let recipe3 = Recipe.init(name: "Primavera Pasta", cookingTime: 25, briefDescription: "Light pasta with pesto. Add more garlic next time", ingridients: ingridients1, steps: steps1, FAVORITE: false, COOKED: true, cookedCount: 0, photos: [Data.init()], dateAdded: Date.init(), tags: tags3)
        
        return [recipe1,recipe2,recipe3]
    }
    
    class func getEmptyOfRecipes() -> Recipe{
        return Recipe.init(name: "", cookingTime: 0, briefDescription: "", ingridients: [""], steps: [""], FAVORITE: false, COOKED: false, cookedCount: 0, photos: [Data.init()], dateAdded: Date.init(), tags: [""])
    }
    
}

