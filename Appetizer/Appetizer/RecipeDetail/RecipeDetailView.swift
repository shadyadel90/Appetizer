//
//  RecipeDetailView.swift
//  Appetizer
//
//  Created by Shady Adel on 14/07/2023.
//

import UIKit

class RecipeDetailView: UIViewController {
    
    
    let userDefaults = UserDefaults()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: RecipeDetailHeaderView!
    
    @IBAction func heartPressed(_ sender: UIButton) {
        if headerView.heartButton.currentImage == UIImage(systemName: "heart")
        {
            headerView.heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            UserDefaults().set(true, forKey: recipeTitle)
        }
        else {
            headerView.heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
            UserDefaults().set(false, forKey: recipeTitle)
        }
        
    }
   
    
    
    var recipeTitle = ""
    var recipeCalories = ""
    var recipeImageUrl = ""
    var recipeFav = true
    var recipeDescription = ""
    var recipeIngredients = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        navigationController?.navigationBar.prefersLargeTitles = false
        // Configure header view
        headerView.nameLabel.text = recipeTitle
        headerView.caloriesLabel.text = recipeCalories
        Setimage(imageUrl: recipeImageUrl)
        favouriteButton()
        
    }
    
    func favouriteButton (){
        if userDefaults.bool(forKey: recipeTitle)
        {
            headerView.heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        else {
            headerView.heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        view.reloadInputViews()
    }
    
  
    func Setimage(imageUrl: String){
       
        if let imageURL = URL(string: imageUrl) {
            URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                if let error = error {
                    print("Error loading image: \(error)")
                    return
                }
                else {
                    print("Success")
                }
                if let data = data {
                    DispatchQueue.main.async { [self] in
                    let image = UIImage(data: data)
                        self.headerView.headerImageView.image = image
                    }
                }
            }.resume()
            
        }
    }

   

}
extension RecipeDetailView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section : Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionDetailViewCell", for: indexPath) as! RecipeDetailDescriptionCell
            cell.descriptionLabel.text = recipeDescription
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientsDetailViewCell", for: indexPath) as! RecipeDetailIngredientsCell
            cell.ingredientsLabel.text = recipeIngredients
            
            return cell
        default:
            fatalError("Failed to instantiate the table view cell for deta il view controller")
            
        }
        
    }
}
