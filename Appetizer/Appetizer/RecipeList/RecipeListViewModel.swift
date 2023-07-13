//
//  RecipeListViewModel.swift
//  Appetizer
//
//  Created by Shady Adel on 13/07/2023.
//

import Foundation
import UIKit

class RecipeListViewModel {
    
    lazy var recipeListView : RecipeListView = {
        return RecipeListView()
    }()
    
    var recipes: [Recipe] = []
    let urlString = "https://api.npoint.io/43427003d33f1f6b51cc"

    var recipesCount: Int {
        return recipes.count
    }

}
    
