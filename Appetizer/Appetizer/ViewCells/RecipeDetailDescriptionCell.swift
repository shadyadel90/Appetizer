//
//  RecipeDetailDescriptionCell.swift
//  Appetizer
//
//  Created by Shady Adel on 14/07/2023.
//

import UIKit

class RecipeDetailDescriptionCell: UITableViewCell {

    @IBOutlet var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.numberOfLines = 0
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
