//
//  OrderWorkerCell.swift
//  Sayen  Worker
//
//  Created by Maher on 6/17/20.
//

import UIKit

class OrderWorkerCell: UITableViewCell {

    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var kindWork: UILabel!
    @IBOutlet weak var mapbtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
