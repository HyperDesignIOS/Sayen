//
//  DateCell.swift
//  Sayen  Worker
//
//  Created by Maher on 6/17/20.
//

import UIKit

class DateCell: UICollectionViewCell {

    @IBOutlet weak var view: CardView!
    @IBOutlet weak var dayNum: UILabel!
    @IBOutlet weak var month: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dayNum.transform = CGAffineTransform(scaleX: -1, y: 1)
        month.transform = CGAffineTransform(scaleX: -1, y: 1)
    }

  
    
}
