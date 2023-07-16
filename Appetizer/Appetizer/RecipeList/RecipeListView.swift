//
//  RecipeListView.swift
//  Appetizer
//
//  Created by Shady Adel on 13/07/2023.
//

import UIKit

class RecipeListView: UITableViewController {
    
    // MARK: - Properties
    private let viewModel = RecipeListViewModel()
    private var spinner = UIActivityIndicatorView()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.fetchData()
        
        initSpinner()
        navigationItem.backButtonTitle = ""
        tableView.alpha = 0.5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recipesCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? RecipeListViewCell else {
            fatalError("Cell does not exist in storyboard")
        }
        // Configure the cell with recipe data
        if let recipe = viewModel.getRecipe(at: indexPath.row) {
            cell.name.text = recipe.name
            if recipe.calories != "" {
                cell.calories.text = "\(recipe.calories)"
            } else {
                cell.calories.text = "not specified"
            }
            // Save user's favorite recipe
            cell.heartImage.isHidden = UserDefaults().bool(forKey: recipe.name) ? false : true
            
            // Load the recipe image asynchronously
            if recipe.image != nil {
                viewModel.getImage(for: recipe) { image in
                    if let image = image {
                        cell.recipeImage.image = image
                        self.spinner.stopAnimating()
                        UIView.animate(withDuration: 0.2) {
                            self.tableView.alpha = 1.0
                        }
                    } else {
                        print("Couldn't fetch the image")
                    }
                }
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationController = segue.destination as? RecipeDetailView,
                  let recipe = viewModel.getRecipe(at: indexPath.row) else {
                return
            }
            // Force the user to login first
            if !UserDefaults.standard.bool(forKey: "loggedIn") {
                showError(message: "We can't proceed to details as you didn't log in")
            } else {
                // Pass the recipe details to the detail view controller
                destinationController.recipeTitle = recipe.name
                destinationController.recipeCalories = recipe.calories
                destinationController.recipeImageUrl = recipe.image ?? ""
                destinationController.recipeDescription = recipe.description
                destinationController.recipeIngredients = recipe.ingredients.joined(separator: "\n")
            }
        }
    }
    
    // MARK: - Helper Methods
    func initSpinner() {
        spinner.style = .large
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150.0),
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func refresherStopAnimating() {
        if let refreshControl = refreshControl, refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
    }
}

extension RecipeListView: RecipeListViewModelDelegate {
    // MARK: - RecipeListViewModelDelegate Methods
    func recipesUpdated() {
        tableView.reloadData()
        refresherStopAnimating()
    }
    
    func showError(message: String) {
        // Display an error message using an alert controller
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}

