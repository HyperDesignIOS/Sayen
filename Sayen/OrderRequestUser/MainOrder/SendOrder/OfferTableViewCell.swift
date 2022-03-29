//
//  OfferTableViewCell.swift
//  Sayen 
//
//  Created by ME-MAC on 2/28/22.
//

import UIKit

class OfferTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var radioButtonImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configerCell(title: String, isSelected: Bool, price: String){
        titleLabel.text = title
        priceLabel.text = price
        if isSelected {
            radioButtonImage.image = UIImage(named: "AXTT6105")
        }else{
            radioButtonImage.image = UIImage(named: "Ellipse 8")
        }
    }

}
