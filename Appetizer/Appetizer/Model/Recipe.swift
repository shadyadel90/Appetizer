//
//  Recipe.swift
//  Appetizer
//
//  Created by Shady Adel on 13/07/2023.
//

import Foundation

struct Recipe: Codable {
    
    let name: String
    let calories: String
    let description: String
    let ingredients: [String]
    let image: String?
   
    
    
}
