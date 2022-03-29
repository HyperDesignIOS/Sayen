//
//  RegisterVN.swift
//  Sayen
//
//  Created by Maher on 5/31/20.
//  Copyright © 2020 maher. All rights reserved.
//

import Foundation


class RegisterVM {
    var getDataClosure : (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var passConfirme : String?
    
    var buildingData = [BuildingM]()
    var selectedData : BuildingM?

    var userName : String?
    var phonenum : String?
    var pass : String?
    
    var flatTitle : String?
    var flatNum : String?

    var clint : Int = 0 {
        didSet{
             getDataClosure?()
            }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
      
    
  
    var state: State = .empty {
             didSet {
                 self.updateLoadingStatus?()
             }
         }
    
    func validateRows ()->Bool{
       
        guard let phonenum = phonenum , phonenum != "" , phonenum.count == 10 , phonenum.prefix(2) == "05" else{
            print("noooospace")
            if self.phonenum == "" {
                alertMessage = "EnterPhone".localized
            }else{
                alertMessage = "phoneVaildationMsg".localized
            }
            return false
        }
        guard let userName = userName else {
            
            alertMessage = "من فضلك إدخل اسم المستخدم"
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
        
        if clint == 0 {
                   print("selectClint")
                   alertMessage = "selectClint".localized
                   return false
               }
        
        if clint == 1 {
            guard let title = flatTitle ,title != "" else{
                alertMessage = "selectBuildingName".localized
                return false
            }
            
            guard let num = flatNum ,num != "" else{
                alertMessage = "selectFlateNumber".localized
                return false
            }
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
       guard let  userName = userName,let phonenum = phonenum , let pass = pass else {return}
        
        APIClient.registerRequest(name: userName, mobile: phonenum, password: pass, country_code: "966", excellence_client: clint,building_id: self.selectedData?.id ?? 0 , flat: self.flatNum ?? "" , completionHandler: { (state, sms) in
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
    
    
    func getBuildingsName(completionHandler:@escaping((Bool)->())) {
        
        
        APIClient.getBuildingsNames(completionHandler: { [weak self](rData) in
             DispatchQueue.main.async {
                self?.buildingData = rData.buildings
                completionHandler(true)
            }
            
        }) { (err) in
            
            DispatchQueue.main.async {
                completionHandler(false)
            }
            
        }
    }
}
