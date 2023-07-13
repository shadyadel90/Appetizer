//
//  ApiService.swift
//  Appetizer
//
//  Created by Shady Adel on 13/07/2023.
//

import Foundation
import UIKit

class ApiService : UIViewController {
    
    let urlString = "https://api.npoint.io/43427003d33f1f6b51cc"
    
    lazy var recipeListViewModel : RecipeListViewModel = {
       return RecipeListViewModel()
    }()
    lazy var recipeListView: RecipeListView = {
        return RecipeListView()
    }()
    
  
}
