//
//  UIView+Shadow.swift
//  janah
//
//  Created by Smaat2 on 5/28/17.
//  Copyright © 2017 Smaat. All rights reserved.
//

import UIKit

extension UIView {

    @IBInspectable var shadow: Bool {
      
        get {
        
            return layer.shadowOpacity > 0.0
        }
        
        set {
        
            if newValue == true {
            
                self.addShadow()
            }
        }
    }
    
//    @IBInspectable var cornerRadius: CGFloat {
//       
//        get {
//        
//            return self.layer.cornerRadius
//        }
//        
//        set {
//        
//            self.layer.cornerRadius = newValue
//            
//            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
//            if shadow == false {
//            
//                self.layer.masksToBounds = true
//            }
//        }
//    }

    func addShadow() {
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.07
        self.layer.shadowRadius = 4
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func addShadowWithCornerRadius() {
        
        // corner radius
        self.layer.cornerRadius = 15
        
        // shadow
//        self.layer.shadowColor = UIColor.lightGray.cgColor
//        self.layer.shadowOffset = CGSize(width: 1, height: 1)
//        self.layer.shadowOpacity = 3
//        self.layer.shadowRadius = 3
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 15).cgPath
        self.layer.shouldRasterize = true
        self.clipsToBounds = true
        layer.masksToBounds = true
        self.layer.rasterizationScale = UIScreen.main.scale

    }
}


//class RoundShadowView: UIView {
//
//    let containerView = UIView()
//    let cornerRadius: CGFloat = 6.0
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        layoutView()
//    }
//
//
//
//    func layoutView() {
//
//        // set the shadow of the view's layer
//        layer.backgroundColor = UIColor.clear.cgColor
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 1.0)
//        layer.shadowOpacity = 0.2
//        layer.shadowRadius = 4.0
//
//        // set the cornerRadius of the containerView's layer
//        containerView.layer.cornerRadius = cornerRadius
//        containerView.layer.masksToBounds = true
//
//        addSubview(containerView)
//
//        //
//        // add additional views to the containerView here
//        //
//
//        // add constraints
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//
//        // pin the containerView to the edges to the view
//        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
//        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
//        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//    }
//}
