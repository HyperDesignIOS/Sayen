//
//  UIViewX.swift
//  Sayen 
//
//  Created by ME-MAC on 2/3/22.
//


import UIKit

@IBDesignable
class UIViewX:  UIView {
    
    @IBInspectable var cornerRadios : CGFloat = 0 {didSet{self.layer.cornerRadius = cornerRadios}}
    @IBInspectable var borderwidth : CGFloat = 0 {didSet{self.layer.borderWidth = borderwidth}}
    @IBInspectable var borderColor : UIColor = UIColor.clear{didSet{self.layer.borderColor = borderColor.cgColor}}
    @IBInspectable var shadowColor : UIColor =  UIColor.clear{didSet{self.layer.shadowColor = shadowColor.cgColor}}
    @IBInspectable var shadowRadius : CGFloat = 0 {didSet {self.layer.shadowRadius = shadowRadius }}
    @IBInspectable var shadowOpacity : Float = 0 {didSet {self.layer.shadowOpacity = shadowOpacity }}
    @IBInspectable var shadowOffset : CGSize =  CGSize(width:3 ,height: 3 ) {didSet {self.layer.shadowOffset = shadowOffset }}

}
