
//
//  CDAlertExt.swift
//  Theme
//
//  Created by Eslam Abo El Fetouh on 3/15/20.
//  Copyright © 2020 Eslam Abo El Fetouh. All rights reserved.
//

import Foundation
import UIKit
import CDAlertView

enum AlertButtonsCount : Int {
    case none , one,two
}

extension UIView {
    
    func showAlert(_ title : String? , _ sms : String? ,_ alertType : CDAlertViewType ,_ action:( ()->())?) {
         let alert = CDAlertView(title: title, message: sms, type: alertType)
        alert.hideAnimations = { (center, transform, alpha) in
            transform = CGAffineTransform(scaleX: 3, y: 3)
            transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 90 ) / 180 )
            alpha = 0
            action?()
        }
        alert.hideAnimationDuration = 0.55
        alert.autoHideTime = 3
        alert.show()
    }

    
    func showAlertWithCompletionHandler(_ title : String? , _ sms : String? ,_ alertType : CDAlertViewType ,_ action:( ()->())?) {
         let alert = CDAlertView(title: title, message: sms, type: alertType)
        alert.hideAnimations = { (center, transform, alpha) in
            transform = CGAffineTransform(scaleX: 3, y: 3)
            transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 90 ) / 180 )
            alpha = 0
            DispatchQueue.main.async {
            action?()
            }
        }
        alert.hideAnimationDuration = 0.55
        alert.autoHideTime = nil
        alert.show()
    }
    func showSimpleAlertConfirm(_ title : String? , _ sms : String? ,_ alertType : CDAlertViewType,ok_action:@escaping ()->Void?,cancel_action:@escaping ()->Void? ) {

             let alert = CDAlertView(title: "", message: sms, type: .warning)
        let doneAction = CDAlertViewAction(title:  L0S.cancel.message(), font: nil, textColor: #colorLiteral(red: 0.1249420419, green: 0.2299498916, blue: 0.3131522536, alpha: 1), backgroundColor: nil){ (_) -> Bool in
                ((cancel_action()) != nil)
            }
        let nevermindAction = CDAlertViewAction(title: L0S.ok.message(), font: nil, textColor:  #colorLiteral(red: 0.1249420419, green: 0.2299498916, blue: 0.3131522536, alpha: 1), backgroundColor: nil){ (_) -> Bool in
                ((ok_action()) != nil)
            }
            alert.add(action: nevermindAction)
            alert.add(action: doneAction)
            alert.show()
    }
    
    func showSimpleTxtFieldAlert(_ title : String? , _ sms : String? ,_ alertType : CDAlertViewType,ok_action:@escaping (String)->(),cancel_action:@escaping ()->() ) {

             let alert = CDAlertView(title: title, message: sms, type: .warning)
        let doneAction = CDAlertViewAction(title:  L0S.cancel.message(), font: nil, textColor: #colorLiteral(red: 0.1249420419, green: 0.2299498916, blue: 0.3131522536, alpha: 1), backgroundColor: nil){ (_) -> Bool in
                ((cancel_action()) != nil)
            }
        let nevermindAction = CDAlertViewAction(title: L0S.ok.message(), font: nil, textColor:  #colorLiteral(red: 0.1249420419, green: 0.2299498916, blue: 0.3131522536, alpha: 1), backgroundColor: nil){ (_) -> Bool in
                ((ok_action(alert.textFieldText ?? "")) != nil)
            }
            alert.add(action: nevermindAction)
            alert.add(action: doneAction)
        alert.isTextFieldHidden = false
        alert.textFieldPlaceholderText = title 
        alert.hideAnimationDuration = 0.55
        alert.autoHideTime = nil
            alert.show()
    }
    
    func showSimpleAlert(_ title : String? , _ sms : String? ,_ alertType : CDAlertViewType ,_ numOfButtons : AlertButtonsCount? = AlertButtonsCount.one ) {
        
        let smsR = sms
        let alert = CDAlertView(title: title, message: smsR, type: alertType)
        alert.hideAnimations = { (center, transform, alpha) in
            transform = CGAffineTransform(scaleX: 3, y: 3)
            transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 90 ) / 180 )
            alpha = 0
        }
        alert.hideAnimationDuration = 0.55
        alert.autoHideTime = 3
        
        alert.show()

    }
    
 
    

}
