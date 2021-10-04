//
//  UIVC_Ext.swift
//  Theme
//
//  Created by Eslam Abo El Fetouh on 3/20/20.
//  Copyright © 2020 Eslam Abo El Fetouh. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    func showApiErrorSms(err : String?) {
        print(err )
        DispatchQueue.main.async {
            guard    let err = err   else {
                ad.window?.showSimpleAlert("",L0S.networkRes.message(), .error)
                
                ad.killLoading()
                return}
            
            guard  !err.contains("500") else {
                print(err)
                ad.window?.showSimpleAlert(L0S.error500.message(),"", .error)
                ad.killLoading()
                return}
            guard err != "" else {
                ad.window?.showSimpleAlert("",L0S.networkRes.message(), .error)
                return
            }
            guard err != " " else {
                ad.window?.showSimpleAlert("",L0S.networkRes.message(), .error)
                return
            }
            ad.window?.showSimpleAlert( err , "", .error)
            ad.killLoading()
        }
    }
    
    func showApiErrorSmsWithDismissModel(err : String?) {
         self.dismiss(animated: true) {
            self.showApiErrorSms(err: err)

        }
    }
    
  
    }


extension UIViewController {
 
    @objc   func dismissViewC() {
        if self.navigationController == nil {
            self.dismiss(animated: true, completion: nil)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    

       func presentInFullScreen(_ viewController: UIViewController,
                               animated: Bool,
                               completion: (() -> Void)? = nil) {
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: animated, completion: completion)
      }
   
}
