//
//  ForgetPassVM.swift
//  Sayen
//
//  Created by Maher on 6/1/20.
//  Copyright © 2020 maher. All rights reserved.
//

import Foundation
class ForgetPassMV {
    var phonenum : String?
    
    

    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var alertMessage : String?{
         didSet{
             self.showAlertClosure?()
         }
     }
     var state: State = .empty {
            didSet {
                self.updateLoadingStatus?()
            }
        }
    
    func validateRows ()->Bool{
           guard let phonenum = phonenum , phonenum != "" , phonenum.count == 10 , phonenum.prefix(2) == "05"  else{
                      print("noooospace")
                      if self.phonenum == "" {
                          alertMessage = "EnterPhone".localized
                      }else{
                           alertMessage = "phoneVaildationMsg".localized
                      }
                      return false
                  }
           return true
       }

    
    func initForget (for user_type : String){
        guard let phoneNum = phonenum else{return}
        guard validateRows()else{return}
        state = .loading
        
        APIClient.forgetPassRequest(mobile: phoneNum, country_code: "966",user_type: user_type, completionHandler: { (status, sms) in
            guard status else{
                self.alertMessage = sms
                self.state = .error
                return
            }
            self.state = .populated
            
        }) { (err) in
            self.alertMessage = "tryAgain".localized
            self.state = .error
        }
    }
    
    
    
    
}
