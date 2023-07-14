//
//  ApiService.swift
//  Appetizer
//
//  Created by Shady Adel on 13/07/2023.
//

import Foundation
import UIKit

class ApiService : UIViewController {
    
    lazy var recipeListViewModel : RecipeListViewModel = {
        return RecipeListViewModel()
    }()
    
    let urlString = "https://api.npoint.io/43427003d33f1f6b51cc"
    
    
    //MARK: Fetch Data from API
    func fetchDataFromAPI() {
        
        let session = URLSession.shared

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let task = session.dataTask(with: url) { (data, response, error) in
            // Check for any errors
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let decoder = JSONDecoder()
                var recipes = self.recipeListViewModel.recipes
                   recipes = try decoder.decode([Recipe].self, from: data)
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    
}
