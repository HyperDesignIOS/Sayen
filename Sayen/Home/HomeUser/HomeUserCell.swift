//
//  HomeUserCell.swift
//  Sayen 
//
//  Created by Maher on 6/9/20.
//

import UIKit

class HomeUserCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var labelCell: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mainView.layer.cornerRadius = 5
    }

}
