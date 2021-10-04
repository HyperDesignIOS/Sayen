//
//  EditPhoneVM.swift
//  Sayen 
//
//  Created by Maher on 6/7/20.
//

import Foundation
class EditPhoneVM {
    
    var phone : String?
    
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
        
        
        guard let phonenum = phone , phonenum != "" , phonenum.count == 10 , phonenum.prefix(2) == "05"  else{
            print("noooospace")
            if self.phone == "" {
                alertMessage = "EnterPhone".localized
            }else{
                alertMessage = "phoneVaildationMsg".localized
            }
            return false
        }
        
        return true
    }
    
    
    func changePhone (){
        guard validateRows()else{return}
        
        state = .loading
        APIClient.changePhone(phone: self.phone!, country_code: "966", user_type: ad.user_type(), completionHandler: { (state, sms) in
            guard state else{
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
