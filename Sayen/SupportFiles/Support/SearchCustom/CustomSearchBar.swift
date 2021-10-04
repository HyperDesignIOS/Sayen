//
//  CustomSearchBar.swift
//  CustomSearchBar
//
//  Created by Gabriel Theodoropoulos on 8/9/15.
//  Copyright (c) 2015 Appcoda. All rights reserved.
//

import UIKit
import MOLH
class CustomSearchBar: UISearchBar {

    var preferredFont: UIFont!
    
    var preferredTextColor: UIColor?
    
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        // Find the index of the search field in the search bar subviews.
        if let index = indexOfSearchFieldInSubviews() {
            // Access the search field
            let searchField: UITextField = (subviews[0] ).subviews[index] as! UITextField
            // Set its frame.
            searchField.frame = CGRect(x: 5.0, y: 0.0, width: frame.size.width - 5.0, height: frame.size.height - 0.0)
            // Set the font and text color of the search field.
            searchField.font = preferredFont
            searchField.textColor = preferredTextColor
            
            // Set the background color of the search field.
            searchField.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//            searchField.layer.borderWidth = 1
//            searchField.layer.borderColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0).cgColor

            //searchField.attributedPlaceholder.
//            searchField.font = UIFont(name: "Cairo-Bold", size: 8)
                //UIFont(name: "NeoSansW23", size: 8.0)
            //UIFont(name:"HelveticaCE-Regular", size: 8.0)
            //UIFont(name: "Cairo-Bold", size: 11)!

               if let iconView = searchField.leftView as? UIImageView {
                
                iconView.image = iconView.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                iconView.tintColor = #colorLiteral(red: 0.3696590662, green: 0.2743547559, blue: 0.5441126227, alpha: 1)
                searchField.borderStyle = .none
                
                searchField.backgroundColor = .white
                self.setImage(UIImage(named: "search_nav_icon"), for: .search, state: .normal)

                 var v = UIView()
//                if MOLHLanguage.isRTLLanguage() {
//                    v = UIView.init(frame: CGRect(x: searchField.frame.width - (iconView.frame.width*2.5) , y: searchField.frame.height - (iconView.frame.height*3) , width: 1, height: searchField.frame.height/4))
//
//                }else {'
//                    v = UIView.init(frame: CGRect(x: (iconView.frame.width*2.5) , y: searchField.frame.height - (iconView.frame.height*3) , width: 1, height: searchField.frame.height/4))
//
//                }
                
                if MOLHLanguage.isRTLLanguage() {
                    v = UIView.init(frame: CGRect(x: -2 , y: 0 , width: 1, height: searchField.frame.height/4))

                }else {
                    v = UIView.init(frame: CGRect(x: iconView.frame.width+2 , y: 0 , width: 1, height: searchField.frame.height/4))
                    
                }
                
                v.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                searchField.leftView?.addSubview(v)
                searchField.leftView?.bringSubviewToFront(v)

            }
        
//            (self.value(forKey: "cancelButton") as! UIButton).setTitle("إلغاء", for: .normal)
//            (self.value(forKey: "cancelButton") as! UIButton).setTitleColor(#colorLiteral(red: 0.3696590662, green: 0.2743547559, blue: 0.5441126227, alpha: 1) , for: .normal)
//
//            (self.value(forKey: "cancelButton") as! UIButton).isEnabled = true 

        }
        

        let startPoint = CGPoint(x: 0.0, y: frame.size.height)
        let endPoint = CGPoint(x: frame.size.width, y: frame.size.height)
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = preferredTextColor?.cgColor
        shapeLayer.lineWidth = 2.5

        layer.addSublayer(shapeLayer)
        
        super.draw(rect)
    }
    

    
    init(frame: CGRect, font: UIFont, textColor: UIColor) {
        super.init(frame: frame)
        
        self.frame = frame
        preferredFont = font
        preferredTextColor = textColor
        
        searchBarStyle = UISearchBar.Style.prominent
        isTranslucent = false
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func indexOfSearchFieldInSubviews() -> Int! {
        // Uncomment the next line to see the search bar subviews.
        // println(subviews[0].subviews)
        
        var index: Int!
        let searchBarView = subviews[0] 
        
        for  i in 0..<searchBarView.subviews.count  {
            if searchBarView.subviews[i].isKind(of:UITextField.self) {
                index = i
                break
            }
        }
        
        return index
    }
}
