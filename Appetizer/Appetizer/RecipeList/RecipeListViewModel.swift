//
//  RecipeListViewModel.swift
//  Appetizer
//
//  Created by Shady Adel on 13/07/2023.
//

import UIKit

protocol RecipeListViewModelDelegate: AnyObject {
    func recipesUpdated() // Delegate method called when recipes are updated
    func showError(message: String) // Delegate method called to show an error message
}

class RecipeListViewModel {
    
    //MARK: Properities
    weak var delegate: RecipeListViewModelDelegate? // Delegate instance
    
    private let urlString = "https://api.npoint.io/43427003d33f1f6b51cc" // URL for fetching recipes from an API
   
    private let imageCache = NSCache<AnyObject, AnyObject>() // Cache for storing recipe images
   
    public var searchController = UISearchController(searchResultsController: nil) // Search controller for filtering recipes
   
    var recipes: [Recipe] = [] // Array to store all recipes
   
    public var filteredRecipes: [Recipe] = [] // Array to store filtered recipes
    
    var recipesCount: Int { // Computed property to get the count of recipes based on whether filtering is enabled or not
        return isFiltering ? filteredRecipes.count : recipes.count
    }
    
    //MARK: Fetch data from API
    func fetchData() {
        guard let url = URL(string: urlString) else { // Create a URL from the API URL string
            delegate?.showError(message: "Invalid API URL") // Notify the delegate about the error
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error { // Check if there's an error
                self?.delegate?.showError(message: error.localizedDescription) // Notify the delegate about the error
                return
            }
            
            guard let data = data else { // Check if data is received
                self?.delegate?.showError(message: "No data received") // Notify the delegate about the error
                return
            }
            
            do {
                let decoder = JSONDecoder() // Create a JSON decoder
                self?.recipes = try decoder.decode([Recipe].self, from: data) // Decode the received data into an array of Recipe objects
                DispatchQueue.main.async {
                    self?.delegate?.recipesUpdated() // Notify the delegate that recipes are updated
                }
            } catch {
                self?.delegate?.showError(message: "Error parsing JSON: \(error)") // Notify the delegate about the error
            }
        }.resume() // Start the data task
    }
    
    // Return the recipe at the specified index based on whether filtering is enabled or not
    func getRecipe(at index: Int) -> Recipe? {
        guard index >= 0, index < recipes.count else {
            return nil
        }
        return isFiltering ? filteredRecipes[index] : recipes[index]
    }
    
    //MARK:  caching image
    func getImage(for recipe: Recipe, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: recipe.image as AnyObject) as? UIImage { // Check if the recipe image is already cached
            completion(cachedImage) // return the cahce image
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            guard let imageUrlString = recipe.image, let imageUrl = URL(string: imageUrlString) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            if let imageData = try? Data(contentsOf: imageUrl), let image = UIImage(data: imageData) { // Download and create an image from the recipe's image URL
                self?.imageCache.setObject(image, forKey: recipe.image as AnyObject) // Cache the downloaded image
                DispatchQueue.main.async {
                    completion(image) // Return the downloaded image
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil) // Return nil if the image couldn't be downloaded or created
                }
            }
        }
    }
    
    // Check if the search bar text is empty
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    // Check if the search controller is active and there's a non-empty search bar text
    private var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    // Filter the recipes based on the search text (case-insensitive)
    public func filterRecipes(for searchText: String) {
        filteredRecipes = recipes.filter { recipe in
            return recipe.name.lowercased().contains(searchText.lowercased())
        }
        
        delegate?.recipesUpdated() // Notify the delegate that recipes are updated
    }
}
