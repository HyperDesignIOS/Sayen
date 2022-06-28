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
    @IBOutlet weak var offerImageView: UIImageView!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var infoTextLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        offerLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        self.mainView.layer.cornerRadius = 5
        
    }
    func configerCell(){
        
    }
    
}
