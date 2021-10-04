//
//  MMtextField.swift
//  Theme
//
//  Created by Eslam Abo El Fetouh on 3/30/20.
//  Copyright © 2020 Eslam Abo El Fetouh. All rights reserved.
//

import Foundation
import MMText


extension MMTextField {
    
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.textAlignment = Constants.current_Language == "ar" ? .right : .left
    }
 
//    open override class func awakeFromNib() {
//        super.awakeFromNib()
//        self.textAlignment = .right
//    }
    
}
