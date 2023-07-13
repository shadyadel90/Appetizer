//
//  RecipeListViewCell.swift
//  Appetizer
//
//  Created by Shady Adel on 13/07/2023.
//

import UIKit

class RecipeListViewCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    
    @IBOutlet var calories: UILabel!
    
    @IBOutlet var recipeImage: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
