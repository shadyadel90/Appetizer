//  RecipeListView.swift
//  Appetizer
//
//  Created by Shady Adel on 13/07/2023.

import UIKit

class RecipeListView: UITableViewController {
    
    private let viewModel = RecipeListViewModel() // View model for the recipe list
    private var spinner = UIActivityIndicatorView() // Spinner for loading indicator
    var selectedRecipe: Recipe? // Currently selected recipe
    private let searchController = UISearchController(searchResultsController: nil) // Search controller for filtering recipes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self // Set the view model delegate
        viewModel.fetchData() // Fetch recipe data from the server
        
        initSpinner() // Initialize and configure the spinner
        navigationItem.backButtonTitle = "" // Set the title of the back button
        tableView.alpha = 0.5 // Set the initial alpha value of the table view
        
        setupSearchBar() // Configure the search bar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData() // Reload the table view when the view appears
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recipesCount // Return the number of recipes in the view model
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? RecipeListViewCell else {
            fatalError("Cell does not exist in storyboard") // Fatal error if the cell is not found
        }
        
        guard let recipe = viewModel.getRecipe(at: indexPath.row) else {
            return cell // Return the cell if the recipe is not found
        }
        
        // Configure the cell with recipe data
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
                    print("Couldn't fetch the image") // Print an error message if the image couldn't be fetched
                }
            }
        }
        
        return cell
    }
    
    // Seque to detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationController = segue.destination as? RecipeDetailView,
                  let recipe = viewModel.getRecipe(at: indexPath.row) else {
                return // Return if the destination or recipe is not found
            }
            
            // Force the user to log in first
            if !UserDefaults.standard.bool(forKey: "loggedIn") {
                showError(message: "We can't proceed to details as you didn't log in") // Show an error message if the user is not logged in
            } else {
                // Pass the recipe details to the detail view controller
                destinationController.viewModel = RecipeDetailVM(recipe: recipe)
            }
        }
    }
    
    // Intialzing Spinner
    func initSpinner() {
        spinner.style = .large
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150.0),
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        spinner.startAnimating()
    }
    

    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Recipes"
        navigationItem.searchController = searchController // Set the search controller in the navigation item
        definesPresentationContext = true
        viewModel.searchController = searchController // Set the search controller in the view model
    }
}

extension RecipeListView: RecipeListViewModelDelegate {
    func recipesUpdated() {
        tableView.reloadData() // Reload the table view when the recipes are updated
        
    }
    
    func showError(message: String) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert) // Create an alert controller with the error message
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction) // Add an action to the alert controller
        present(alertController, animated: true, completion: nil) // Present the alert controller
    }
}

extension RecipeListView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        viewModel.filterRecipes(for: searchText) // Update the filtered recipes based on the search text
    }
}
