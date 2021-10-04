//
//  Ext_GradientView.swift
//  Sreer
//
//  Created by admin on 3/31/19.
//  Copyright © 2019 emad ios. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    
//    func addBackgroundGradient(color_1 : CGColor , color_2 : CGColor) {
//         let gradientLayer = CAGradientLayer()
//        gradientLayer.frame.size = self.frame.size
//        // Start and end for left to right gradient
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//        gradientLayer.colors = [color_1, color_2]
//         self.layer.addSublayer(gradientLayer)
//    }

    
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor,colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1,2]
        gradientLayer.frame = bounds
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
      func setGradientWhite() {
        
        let colorBottomWhite = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.30).cgColor
        let colorTopWhite = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTopWhite, colorBottomWhite]
        gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.frame = self.bounds
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

    
}

//@IBDesignable class GradientView : UIView {
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        sharedInit()
//    }
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        sharedInit()
//    }
//    override func prepareForInterfaceBuilder() {
//        sharedInit()
//    }
//    func sharedInit() {
//        // Common logic goes here
//    }
//
//    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
//        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
//        gradientLayer.locations = [0, 1]
//        gradientLayer.frame = bounds
//
//        layer.insertSublayer(gradientLayer, at: 0)
//    }
//
//}
