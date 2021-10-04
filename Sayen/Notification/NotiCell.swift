//
//  NotiCell.swift
//  Sayen 
//
//  Created by Maher on 6/24/20.
//

import UIKit

class NotiCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var maintitle: UILabel!
    @IBOutlet weak var notiImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
