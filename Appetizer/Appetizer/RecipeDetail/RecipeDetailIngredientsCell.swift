//
//  RecipeDetailIngredientsCell.swift
//  Appetizer
//
//  Created by Shady Adel on 14/07/2023.
//

import UIKit

class RecipeDetailIngredientsCell: UITableViewCell {
    
    @IBOutlet var ingredientsLabel: UILabel! {
        didSet {
            ingredientsLabel.numberOfLines = 0
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
