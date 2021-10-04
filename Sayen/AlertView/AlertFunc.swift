//
//  AlertFunc.swift
//  Sayen
//
//  Created by Maher on 5/31/20.
//  Copyright © 2020 maher. All rights reserved.
//

import UIKit

enum AlertType {
    case withContent , success , error , net , sucNil
    case imagePopup(url:URL)
}

extension UIViewController {
    
    func setnavigationStyle () {
        if let nav = navigationController {
            nav.navigationBar.backgroundColor = UIColor.white
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mainColor]
        }
    }
    
    final func showDAlert(title:String = "" ,subTitle : String = "",type : AlertType = .success,buttonTitle:String = "", completionHandler:((Bool)->())?) {
       
       if  let parent =  ad.CurrentRootVC() as? AlertViewC , title == parent.title , subTitle == parent.subTitle
       {
           //Kill Dublicated Alert
           return
       }else {
           let vc = AlertViewC()
           vc.modalTransitionStyle = .crossDissolve
           vc.modalPresentationStyle = .overFullScreen
           vc.mainTitle_ = title
           vc.subTitle = subTitle
           vc.type = type
           vc.buttonTitle = buttonTitle
           vc.completionHandler = completionHandler
           DispatchQueue.main.async {
               self.present(vc, animated: false, completion: nil)
           }
      }
   }
    
    
    
    
    //        final func showPermissionPopup(title:String = "" ,subTitle : String = "",image: UIImage ,okTitle:String = L0S.accept.message(),cancelTitle:String = L0S.refuse.message() , completionHandler:((Bool)->())? = nil) {
    //
    //            if  let parent =  ad.CurrentRootVC() as? AlertVC , title == parent.title_ , subTitle == parent.subTitle
    //            {
    //                //Kill Dublicated Alert
    //                return
    //            }else {
    //
    //                let vc = AskPermissionVC()
    //                vc.modalTransitionStyle = .crossDissolve
    //                vc.modalPresentationStyle = .overFullScreen
    //                vc.title_ = title
    //                vc.subTitle = subTitle
    //                vc.image = image
    //                 vc.okTitle = okTitle
    //                vc.cancelTitle = cancelTitle
    //                  vc.completionHandler = completionHandler
    //                DispatchQueue.main.async {
    //                    self.present(vc, animated: false, completion: nil)
    //                }
    //
    //
    //            }
    //        }
    
    final func showSimpleDAlert(title:String = "",subTitle : String = "",type : AlertType = .success ,buttonTitle:String = "", completionHandler:((Bool)->())? = nil) {
        
        self.showDAlert(title: title, subTitle: subTitle , type: type , buttonTitle: buttonTitle  , completionHandler: completionHandler)
    }
    
    final func showImagePopupAlert(  url : URL , completionHandler:((Bool)->())? = nil) {
        
        //    self.showDAlert( type: AlertType.imagePopup(url: url),autoDismiss:false , completionHandler: completionHandler)
    }
}





