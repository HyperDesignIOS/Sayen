//
//  ServiceOfferTableViewCell.swift
//  Sayen 
//
//  Created by ME-MAC on 3/2/22.
//

import UIKit

class ServiceOfferTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
//    5482740419549396
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configerCell(title: String, price: String){
        titleLabel.text = title
        priceLabel.text = price
    }
}
