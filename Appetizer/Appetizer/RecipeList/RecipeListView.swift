//
//  RecipeListView.swift
//  Appetizer
//
//  Created by Shady Adel on 13/07/2023.
//

import UIKit

class RecipeListView: UITableViewController {
    
    
    lazy var recipeListViewModel : RecipeListViewModel = {
        return RecipeListViewModel()
    }()
    
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    let urlString = "https://api.npoint.io/43427003d33f1f6b51cc"
    var spinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDataFromAPI()
        initSpinner()
        navigationItem.backButtonTitle = ""
        tableView.alpha = 0.5
        
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recipeListViewModel.recipesCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeListViewCell
        
        let recipeCell = recipeListViewModel.recipes[indexPath.row]
        
        cell.name.text = recipeCell.name
        if recipeCell.calories != ""{
            cell.calories.text = "\(recipeCell.calories )"
        }
        else {
            cell.calories.text = "not specified"
        }
        
        let imageUrl = URL(string: recipeCell.image!)
        getImageFromCache(url: imageUrl!) { image in
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
    //MARK: Caching image to reduce network comsuption
    func getImageFromCache(url: URL, completion: @escaping (UIImage?) -> Void) {
        // Check if the image is already in the cache
        if let cachedImage = imageCache.object(forKey: url as AnyObject) as? UIImage {
            completion(cachedImage)
            return
        }
        
        // If the image is not in the cache, load it from the URL
        DispatchQueue.global().async { [self] in
            if let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) {
                // Store the loaded image in the cache
                imageCache.setObject(image, forKey: url as AnyObject)
                
                // Return the image
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
    
    func initSpinner() {
        spinner.style = .large
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        NSLayoutConstraint.activate([ spinner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150.0),
                                      spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
    }
    
    
    @objc func fetchDataFromAPI() {
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
                        self.recipeListViewModel.recipes = try decoder.decode([Recipe].self, from: data)
                        
                        // Reload the table view on the main thread
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            if let refreshControl = self.refreshControl {
                                if refreshControl.isRefreshing { refreshControl.endRefreshing() } }
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
    
   
}
