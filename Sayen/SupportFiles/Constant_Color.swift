//
//  Constant_Color.swift
//  Theme
//
//  Created by Eslam Abo El Fetouh on 3/15/20.
//  Copyright © 2020 Eslam Abo El Fetouh. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
   static let mainColor =  #colorLiteral(red: 0.01960784314, green: 0.2, blue: 0.4509803922, alpha: 1)
    static let brownMainColor =  #colorLiteral(red: 0.7647058824, green: 0.6274509804, blue: 0.3411764706, alpha: 1)
    static let secondaryColor =  #colorLiteral(red: 0.6078431373, green: 0.6784313725, blue: 0.7803921569, alpha: 1)
    static let secondaryWhiteColor = #colorLiteral(red: 0.9490196078, green: 0.9607843137, blue: 0.9725490196, alpha: 1)
    static let backgroundMainColor = #colorLiteral(red: 0.968627451, green: 0.9764705882, blue: 0.9921568627, alpha: 1)
    static let greenColor  = #colorLiteral(red: 0.4196078431, green: 0.6549019608, blue: 0.1843137255, alpha: 1)
    static let redColor =  #colorLiteral(red: 0.8352941176, green: 0.2705882353, blue: 0.2705882353, alpha: 1)
    static let defaultBlack =  #colorLiteral(red: 0.1333139837, green: 0.1333444417, blue: 0.1333120763, alpha: 1)
    static let defaultLightBlack =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6)
    static let defaultGray =  #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
  
    
    /*
     #053373
      #C3A057
     #9BADC7
      #F2F5F8
      #F7F9FD color of background screens
      #6BA72F
     #D54545
     */
  
 
}
 
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
