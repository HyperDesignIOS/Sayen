//
//  RTLImgV.swift
//  Theme
//
//  Created by Eslam Abo El Fetouh on 3/21/20.
//  Copyright © 2020 Eslam Abo El Fetouh. All rights reserved.
//

import Foundation
import MOLH
class RTLImgV :  UIImageView {
    
    override func awakeFromNib() {
        
        if MOLHLanguage.currentAppleLanguage()  == "ar" {
            self.transform = CGAffineTransform(rotationAngle: .pi)
        }else {
            self.transform = CGAffineTransform.identity
            
        }
    }
    
}

class HorizontallyFlippedImgV :  UIImageView {
    
    override func awakeFromNib() {
        
        if MOLHLanguage.currentAppleLanguage()  == "ar" {
            self.image = self.image?.withHorizontallyFlippedOrientation()
        }else {
//            self.transform = CGAffineTransform.identity
            
        }
    }
    
}




class RTLBtn :  UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if MOLHLanguage.currentAppleLanguage()  != "ar" {
            self.transform = CGAffineTransform(rotationAngle: .pi)
        }else {
            self.transform = CGAffineTransform.identity
            
        }
    }
    
}

class RTLSwitch :  UISwitch {
    
    override func awakeFromNib() {
        
        if MOLHLanguage.currentAppleLanguage()  != "ar" {
            self.transform = CGAffineTransform(rotationAngle: .pi)
        }else {
            self.transform = CGAffineTransform.identity
            
        }
    }
    
}



class RTL_label : UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textAlignment = MOLHLanguage.currentAppleLanguage() == "ar" ? .right : .left
    }
    
}
