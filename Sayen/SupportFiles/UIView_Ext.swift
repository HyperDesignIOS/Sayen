//
//  UIView_Ext.swift
//  Theme
//
//  Created by Eslam Abo El Fetouh on 3/21/20.
//  Copyright © 2020 Eslam Abo El Fetouh. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher


extension UIView {

    func  getImage_KF(imgV:UIImageView,urlS : String,placeHolderImg: UIImage? = UIImage(named:"placeholder-image-icon")) {
                    imgV.kf.indicatorType = .activity
                    if let url = URL(string: urlS) {
                        imgV.kf.setImage(with: url, placeholder: placeHolderImg, options: [KingfisherOptionsInfoItem.transition(ImageTransition.fade(0.5))])

        }
 }

    
    
}
