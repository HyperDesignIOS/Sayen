//
//  LoginVM.swift
//  Sayen
//
//  Created by Maher on 5/31/20.
//  Copyright © 2020 maher. All rights reserved.
//

import Foundation


class LoginVM {
    
    var getDataClosure : (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    var phonenum : String?
    var pass : String?
   
    var goAhead : String = "" {
        didSet{
            self.getDataClosure?()
        }
    }
    
    
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
        if self.pass == "" {
            alertMessage = "enterPassword".localized
            return false
        }
        guard let pass = pass ,pass != "", pass.count >= 8 , pass.count <= 15 else{
            alertMessage = "passwordValidation".localized
            return false
        }
        
        return true
    }
    
    
    func initLogin () {
    
        
        guard let phonenum = phonenum , let pass = pass else {return}
        guard validateRows()else{return}
       
        state = .loading
        APIClient.loginRequest(mobile: phonenum, password: pass, country_code: "966", completionHandler: { [weak self](state, sms,status) in
            
            guard state else {
                if status == 401 {
                 self?.alertMessage = sms
                 self?.state = .verfy
               
                 return
                }
                self?.alertMessage = sms
                self?.state = .error
                
                return
             
            }
            self?.state = .populated
            print("ok done")
            
        }) {[weak self ] (err) in
            self?.alertMessage = "tryAgain".localized
            self?.state = .error
     
            }
            
        }
    }
    
    

