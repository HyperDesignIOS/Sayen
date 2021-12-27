//
//  NewPassVM.swift
//  Sayen
//
//  Created by Maher on 6/2/20.
//

import Foundation
class NewPassVM {
    var pass : String?
    var confirmPass : String?

     

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
        
        if self.pass == "" {
            alertMessage = "enterPassword".localized
            return false
        }
        if self.confirmPass == "" {
            alertMessage = "confirmPassword".localized
            return false
        }
        guard let pass = pass ,pass != "", pass.count >= 8 , pass.count <= 15 else{
            alertMessage = "passwordValidation".localized
            return false
        }
        guard let passConfirem = confirmPass ,passConfirem != "", passConfirem.count >= 8 , passConfirem.count <= 15 else{
            alertMessage = "passwordValidation".localized
            return false
        }
        
        if pass != confirmPass {
            alertMessage = "passwordDontMatch".localized
            return false
        }
        
        return true
    }
    
    func initForget (for user_type : String){
        
        guard validateRows()else{return}
        state = .loading
        
        APIClient.resetPassword(password: pass!, user_type: user_type, completionHandler: { (state, sms, status) in
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
