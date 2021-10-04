//
//  ProblemCell.swift
//  Sayen  Worker
//
//  Created by Maher on 6/25/20.
//

import UIKit
import DLRadioButton

class ProblemCell: UITableViewCell {

    @IBOutlet weak var selectedBtn: UIButton!
    @IBOutlet weak var radioBtn: DLRadioButton!
    @IBOutlet weak var problemTxt: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
//
//"types" : [
//  {
//    "id" : 1,
//    "problem" : "العميل لم يرد على الهاتف عند وصولي"
//  },
import SwiftyJSON
class ProblemTypes {
    var id : Int?
    var problem : String?
    
    
     init(_ jsonData : JSON) {
        
           self.problem = jsonData["problem"].stringValue
           self.id = jsonData["id"].intValue
    }
}
