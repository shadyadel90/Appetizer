//
//  RecipeListViewModel.swift
//  Appetizer
//
//  Created by Shady Adel on 13/07/2023.
//

import UIKit

protocol RecipeListViewModelDelegate: AnyObject {
    // MARK: - Delegate Methods
    
    /// Informs the delegate that the recipes have been updated.
    func recipesUpdated()
    
    /// Displays an error message through the delegate.
    func showError(message: String)
}

class RecipeListViewModel {
    // MARK: - Properties
    weak var delegate: RecipeListViewModelDelegate?
    
    private let urlString = "https://api.npoint.io/43427003d33f1f6b51cc"
    private var recipes: [Recipe] = []
    private let imageCache = NSCache<AnyObject, AnyObject>()
    
    var recipesCount: Int {
        return recipes.count
    }
    // MARK: - Network Methods
       
       /// Fetches recipe data from the API.
    func fetchData() {
        guard let url = URL(string: urlString) else {
            delegate?.showError(message: "Invalid API URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                self?.delegate?.showError(message: error.localizedDescription)
                return
            }
            
            guard let data = data else {
                self?.delegate?.showError(message: "No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                self?.recipes = try decoder.decode([Recipe].self, from: data)
                DispatchQueue.main.async {
                    self?.delegate?.recipesUpdated()
                }
            } catch {
                self?.delegate?.showError(message: "Error parsing JSON: \(error)")
            }
        }.resume()
    }
    // MARK: - Accessor Methods
       
       /// Retrieves the recipe at the specified index.
       ///
       /// - Parameter index: The index of the recipe to retrieve.
       /// - Returns: The recipe at the specified index, or `nil` if the index is out of bounds.
    func getRecipe(at index: Int) -> Recipe? {
        guard index >= 0, index < recipes.count else {
            return nil
        }
        return recipes[index]
    }
    
    // MARK: - Image Handling
        
        /// Retrieves the image for the specified recipe.
        ///
        /// - Parameters:
        ///   - recipe: The recipe for which to retrieve the image.
        ///   - completion: The closure to be executed upon completion with the retrieved image.
    func getImage(for recipe: Recipe, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: recipe.image as AnyObject) as? UIImage {
            completion(cachedImage) // Return cached image
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            guard let imageUrlString = recipe.image, let imageUrl = URL(string: imageUrlString) else {
                DispatchQueue.main.async {
                    completion(nil) // Image URL is invalid
                }
                return
            }
            
            if let imageData = try? Data(contentsOf: imageUrl), let image = UIImage(data: imageData) {
                self?.imageCache.setObject(image, forKey: recipe.image as AnyObject)
                DispatchQueue.main.async {
                    completion(image) // Return downloaded image
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil) // Failed to download image
                }
            }
        }
    }
}
