//
//  RecipeListViewModel.swift
//  Appetizer
//
//  Created by Shady Adel on 13/07/2023.
//

import Foundation
import UIKit

class RecipeListViewModel {
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    lazy var recipeListView : RecipeListView = {
        return RecipeListView()
    }()
    
    lazy var apiService: ApiService = {
        return ApiService()
    }()
    
    var recipes: [Recipe] = []
    
    var recipesCount: Int {
        return recipes.count
    }
    
    func fetchData(){
        apiService.fetchDataFromAPI()
    }
    

    //MARK: Cache image
    func getImageFromCache(url: URL, completion: @escaping (UIImage?) -> Void) {
        
        if let cachedImage = imageCache.object(forKey: url as AnyObject) as? UIImage {
            completion(cachedImage)
            return
        }
        DispatchQueue.global().async { [self] in
            if let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) {
                // Store the loaded image in the cache
                imageCache.setObject(image, forKey: url as AnyObject)
                
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func refresherStopAnimating() {
        if let refreshControl = recipeListView.refreshControl {
            if refreshControl.isRefreshing { refreshControl.endRefreshing() } }
    }
    
    
    
}


