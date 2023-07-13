//
//  RecipeListView.swift
//  Appetizer
//
//  Created by Shady Adel on 13/07/2023.
//

import UIKit

class RecipeListView: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)
        as! RecipeListViewCell
        
        cell.name.text = "xy"
        cell.calories.text = "z"
        
        return cell
    }

}
