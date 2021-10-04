//
//  PubLicQuCell.swift
//  Sayen 
//
//  Created by Maher on 6/28/20.
//

import UIKit

class PubLicQuCell: UICollectionViewCell {

    @IBOutlet weak var answerText: UITextView!
    @IBOutlet weak var qusionText: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.answerText.semanticContentAttribute = .forceRightToLeft
        self.qusionText.semanticContentAttribute = .forceRightToLeft
        
      
    }

}
