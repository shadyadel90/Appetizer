//
//  RecipeListView.swift
//  Appetizer
//
//  Created by Shady Adel on 13/07/2023.
//

import UIKit

class RecipeListView: UITableViewController {
    
    
    lazy var ViewModel : RecipeListViewModel = {
        return RecipeListViewModel()
    }()
    
    let urlString = "https://api.npoint.io/43427003d33f1f6b51cc"
    var spinner = UIActivityIndicatorView()
    let userDefault = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewModel.fetchData()
        initSpinner()
        navigationItem.backButtonTitle = ""
        tableView.alpha = 0.5
        fetchDataFromAPI()
        
    }
    
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ViewModel.recipesCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? RecipeListViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        
        let recipeCell = ViewModel.recipes[indexPath.row]
        
        cell.name.text = recipeCell.name
        if recipeCell.calories != ""{
            cell.calories.text = "\(recipeCell.calories )"
        }
        else {
            cell.calories.text = "not specified"
        }
        
        let imageUrl = URL(string: recipeCell.image!)
        ViewModel.getImageFromCache(url: imageUrl!) { image in
            if image != nil {
                cell.recipeImage.image = image
                self.spinner.stopAnimating()
                UIView.animate(withDuration: 0.2) {
                    self.tableView.alpha = 1.0
                }
                
            } else {
                print("Couldn't fetch the image")
            }
        }
        
        return cell
    }
    
    
    func initSpinner() {
        spinner.style = .large
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        NSLayoutConstraint.activate([ spinner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150.0),
                                      spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
    }
    
    
    
    
    func fetchDataFromAPI() {
        spinner.startAnimating()
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        self.ViewModel.recipes = try decoder.decode([Recipe].self, from: data)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.ViewModel.refresherStopAnimating()
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
                else {
                    print("No data recieved")
                }
            }.resume()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let recipes = ViewModel.recipes
        if segue.identifier == "showDetail"{
            if !userDefault.bool(forKey: "logedin"){
                showAlert()
            }
            else {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let destinationController = segue.destination as! RecipeDetailView
                    destinationController.recipeTitle = recipes[indexPath.row].name
                    destinationController.recipeCalories = recipes[indexPath.row].calories
                    destinationController.recipeImageUrl = recipes[indexPath.row].image!
                    destinationController.recipeDescription = recipes[indexPath.row].description
                    var ingredients = ""
                    for i in recipes[indexPath.row].ingredients {
                        ingredients.append("\(i) \n")
                    }
                    destinationController.recipeIngredients = ingredients
                }
            }
        }
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Oops", message: "We can't proceed to details as you didn't log in", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
}
