//
//  RecipeDetailView.swift
//  Appetizer
//
//  Created by Shady Adel on 14/07/2023.
//

import UIKit

class RecipeDetailView: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: RecipeDetailHeaderView!
    
    var viewModel: RecipeDetailVM!
    
    // Convenience initializer to create an instance of RecipeDetailView with a Recipe
    convenience init(recipe: Recipe) {
        self.init(nibName: nil, bundle: nil)
        viewModel = RecipeDetailVM(recipe: recipe)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delegate and data source for the table view
        tableView.delegate = self
        tableView.dataSource = self
        
        // Configure table view behavior
        tableView.contentInsetAdjustmentBehavior = .never
        
        // Disable large titles in the navigation bar
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // Set the recipe title and calories in the header view
        headerView.nameLabel.text = viewModel.recipeTitle
        headerView.caloriesLabel.text = viewModel.recipeCalories
        
        // Load the recipe image asynchronously and update the header view
        viewModel.loadImage { [weak self] image in
            DispatchQueue.main.async {
                self?.headerView.headerImageView.image = image
            }
        }
        
        // Update the favorite button based on the recipe's favorite status
        updateFavoriteButton()
    }
    
    // Action method for when the heart button is pressed
    @IBAction func heartPressed(_ sender: UIButton) {
        viewModel.toggleFavorite() // Toggle the favorite status of the recipe
        updateFavoriteButton() // Update the favorite button appearance
    }
    
    // Update the appearance of the favorite button based on the recipe's favorite status
    private func updateFavoriteButton() {
        let image = viewModel.isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        headerView.heartButton.setImage(image, for: .normal)
    }
}

extension RecipeDetailView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 // The table view has 2 rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            // Configure and return the cell for the description row
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionDetailViewCell", for: indexPath) as! RecipeDetailDescriptionCell
            cell.descriptionLabel.text = viewModel.recipeDescription
            return cell
        case 1:
            // Configure and return the cell for the ingredients row
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsDetailViewCell", for: indexPath) as! RecipeDetailIngredientsCell
            cell.ingredientsLabel.text = viewModel.recipeIngredients
            return cell
        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
        }
    }
}
