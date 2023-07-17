//
//  RecipeDetailVM.swift
//  Appetizer
//
//  Created by Shady Adel on 14/07/2023.
//

import UIKit

protocol RecipeDetailViewModelDelegate: AnyObject {
    func reloadData()
}

class RecipeDetailVM {
    
    weak var delegate: RecipeDetailViewModelDelegate?
    
    private let userDefaults = UserDefaults()
    
    // MARK: - Properties
    
    var recipeTitle = ""
    var recipeCalories = ""
    var recipeImageUrl = ""
    var recipeFav = true
    var recipeDescription = ""
    var recipeIngredients = ""
    
    // MARK: - Computed Property
    
    var isFavorite: Bool {
        return userDefaults.bool(forKey: recipeTitle)
    }
    
    // MARK: - Initializer
    
    init(recipe: Recipe) {
        recipeTitle = recipe.name
        recipeCalories = recipe.calories
        recipeImageUrl = recipe.image ?? ""
        recipeDescription = recipe.description
        recipeIngredients = recipe.ingredients.joined(separator: "\n")
    }
    
    // MARK: - Favorite Handling
    
    func toggleFavorite() {
        if isFavorite {
            userDefaults.set(false, forKey: recipeTitle)
        } else {
            userDefaults.set(true, forKey: recipeTitle)
        }
        delegate?.reloadData()
    }
    
    // MARK: - Image Loading
    
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = URL(string: recipeImageUrl) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            if let error = error {
                print("Error loading image: \(error)")
                completion(nil)
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
}


