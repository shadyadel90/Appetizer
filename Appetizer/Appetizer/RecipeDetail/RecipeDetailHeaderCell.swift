//
//  RecipeDetailHeaderCell.swift
//  Appetizer
//
//  Created by Shady Adel on 14/07/2023.
//

import UIKit

class RecipeDetailHeaderCell: UITableViewCell {

    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var caloriesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
