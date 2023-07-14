//
//  RecipeDetailView.swift
//  Appetizer
//
//  Created by Shady Adel on 14/07/2023.
//

import UIKit

class RecipeDetailView: UITableViewController {
    
    

    var recipeTitle = ""
    var recipeCalories = ""
//  var recipeImage = UIImage?.self
    var recipeDescription = ""
    var recipeIngredients = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeHeader", for: indexPath) as! RecipeDetailHeaderCell
            cell.nameLabel.text = recipeTitle
            cell.caloriesLabel.text = recipeCalories
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeDescription", for: indexPath) as! RecipeDetailDescriptionCell
            cell.descriptionLabel.text = recipeDescription
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeIngredients", for: indexPath) as! RecipeDetailIngredientsCell
            cell.ingredientsLabel.text = recipeIngredients
            return cell
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
            
        }
        
    }
    
    

  

}
