//
//  NewPassVM.swift
//  Sayen
//
//  Created by Maher on 6/2/20.
//

import Foundation
class ChangePassVM {
    var pass : String?
    var confirmPass : String?
    var oldPass : String?
     

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
        guard let oldpass = oldPass ,oldpass != "", oldpass.count >= 8 , oldpass.count <= 15 else{
            print("noooospace")
            if self.pass == "" {
                alertMessage = "enterCurrentPassword".localized
            }else{
                alertMessage = "passwordValidation".localized
            }
            return false
        }
           guard let pass = pass ,pass != "", pass.count >= 8 , pass.count <= 15 else{
                print("noooospace")
                if self.pass == "" {
                    alertMessage = "enterPassword".localized
                }else{
                    alertMessage = "passwordValidation".localized
                }
                return false
            }
             guard let confirmPass = confirmPass ,confirmPass != "", confirmPass.count >= 8 , confirmPass.count <= 15 else{
                print("noooospace")
                if self.confirmPass == "" {
                    alertMessage =  "confirmPassword".localized
                }else{
                    alertMessage = "passwordValidation".localized
                }
                return false
            }
            guard pass == confirmPass else {
                alertMessage = "passwordDontMatch".localized
                return false
            }
        
        
        
        return true
    }
    
    func initForget (for user_type : String){
        
        guard validateRows()else{return}
        state = .loading
        APIClient.changePassRequest(old_password : oldPass!, password: pass!, user_type: user_type, completionHandler: { (state, sms, status) in
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

