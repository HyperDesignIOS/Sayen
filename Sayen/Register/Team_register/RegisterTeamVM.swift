//
//  RegisterTeamVM.swift
//  Sayen  Worker
//
//  Created by Eslam Abo El Fetouh on 10/25/20.
//

import Foundation


class RegisterTeamVM {
    var getDataClosure : (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var passConfirme : String?
    var name : String?

     var phonenum : String?
    var pass : String?
    var email : String?


   
     var state: State = .empty {
              didSet {
                  self.updateLoadingStatus?()
              }
          }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
      
    
   
    func validateRows ()->Bool{
        guard let name = name else {
            
            alertMessage = "فضلا ادخل الإسم بالكامل"

            return false
        }
        guard name.count >= 2 else {
            
            alertMessage = "فضلا ادخل الإسم بالكامل"

            return false
        }
        guard let phonenum = phonenum , phonenum != "" , phonenum.count == 10 , phonenum.prefix(2) == "05" else{
            print("noooospace")
            if self.phonenum == "" {
                alertMessage = "EnterPhone".localized
            }else{
                alertMessage = "phoneVaildationMsg".localized
            }
            return false
        }
        
        guard let email = email else {
            
            alertMessage = "من فضلك إدخل البريد الإلكتروني"
            return false
        }
        
        guard email.isEmail else {
            
            alertMessage = "صيغة البريد الإلكتروني غير صحيحة"
            return false
        }
        if self.pass == "" {
             alertMessage = "enterPassword".localized
             return false
        }
        if self.passConfirme == "" {
             alertMessage = "confirmPassword".localized
             return false
        }
        guard let pass = pass ,pass != "", pass.count >= 8 , pass.count <= 15 else{
            alertMessage = "passwordValidation".localized
            return false
        }
        guard let passConfirem = passConfirme ,passConfirem != "", passConfirem.count >= 8 , passConfirem.count <= 15 else{
                  alertMessage = "passwordValidation".localized
                  return false
              }
        
 
        if pass != passConfirme {
            alertMessage = "passwordDontMatch".localized
            return false
        }
        return true
    }
    
    func confirmRegister(){
        guard validateRows() else{
            return
        }
       state = .loading
       guard let phonenum = phonenum , let pass = pass  , let email = email, let name = name else {return}
        
        APIClient.registerTeamRequest(name:name,mobile: phonenum,email:email, password: pass, country_code: "966", completionHandler: { (state, sms) in
            guard state else{
                self.alertMessage = sms
                self.state = .error
                return
            }
//            self.state = .populated
            DispatchQueue.main.async {
                ad.CurrentRootVC()?.showDAlert(title: "", subTitle: sms, type: .success, completionHandler: { (_) in
//                DispatchQueue.main.async {
//                ad.restartApplication()
//                }
            })
            }
        }) { (err) in
            self.alertMessage = "tryAgain".localized
            self.state = .error
          
        }
    }
}
