//
//  AddedPriceCell.swift
//  Sayen 
//
//  Created by Maher on 6/16/20.
//

import UIKit

class AddedPriceCell: UITableViewCell {

    @IBOutlet weak var priceDesc: UITextView!
    @IBOutlet weak var price: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        priceDesc.semanticContentAttribute = .forceRightToLeft
    }
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
