//
//  TeamAddPriceCell.swift
//  Sayen  Worker
//
//  Created by Maher on 6/17/20.
//

import UIKit

class TeamAddPriceCell: UITableViewCell {

    @IBOutlet weak var rowHightCons: NSLayoutConstraint!
    @IBOutlet weak var addRow: UIButton!
    @IBOutlet weak var priceAdd: UITextField!
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var deleteRowBtn: UIButton!
    @IBOutlet weak var discribeTf: UITextField!
    var price : [String] = []
    var desc : [String] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        discribeTf.delegate = self
        priceAdd.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension TeamAddPriceCell : UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let priceAdd = priceAdd.text ,let discribeTf = discribeTf.text else{
            return
        }
        self.price.append(priceAdd)
        self.desc.append(discribeTf)
       }

}
