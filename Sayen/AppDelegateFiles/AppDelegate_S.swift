//
//  AppDelegate_S.swift
//  Takaful
//
//  Created by Eslam Abo El Fetouh on 3/15/20.
//  Copyright © 2020 Eslam Abo El Fetouh. All rights reserved.
//

import NVActivityIndicatorView
import Locksmith
import MOLH
 
extension AppDelegate {
    
    func isLoading() {
                NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
     }
    
    func killLoading() {
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
     }
//
//    func isLoading() {
////        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
//        AMProgressHUD.show()
//    }
//
//    func killLoading() {
////        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
//        AMProgressHUD.dismiss()
//    }
}


let ad = UIApplication.shared.delegate as! AppDelegate

extension AppDelegate : MOLHResetable{
    func reset() {
        ad.restartApplicationToHome()
    }
    
 
    func changeLang(){
        if MOLHLanguage.isArabic() {
             MOLH.setLanguageTo("en")
            Constants.current_Language = "en"
            
         }
        else
        {
             MOLH.setLanguageTo("ar")
            Constants.current_Language = "ar"
//            SideMenuController.preferences.basic.direction = .left
         }
//        MOLH.reset()
        restartApplicationToHome()
    }
    
    
    func updateKeyChainValue(key:String,value:Any?) {
        guard let value = value else {
              do {
                try Locksmith.deleteDataForUserAccount( userAccount: key)
                return
            } catch {
                print("Couldn't delete \(key) ")
                return
            }
            return
        }
        do {
            try Locksmith.updateData(data: [key: value], forUserAccount: key)
            ////print("Saved Token \(newToken)⚛️")
        } catch {
            ////print("Couldn't save token ")
            do {
                try Locksmith.saveData(data: [key: value], forUserAccount: key)
                ////print("☸️Updated Token \(newToken)⚛️")
                
            } catch {
                ////print("Couldn't save token ")
            }
        }
    }
    
    func CurrentRootVC() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                 let sceneDelegate = windowScene.delegate as? SceneDelegate
               else {
                 return nil

               }
        
       return  sceneDelegate.window?.currentViewController()
    }

    
   
    func restartApplicationToLogin () {
        let viewController = LoginVC()
        let navCtrl = UINavigationController(rootViewController: viewController)
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        guard
                let window = keyWindow,
                let rootViewController = window.rootViewController
                else {
            return
        }
        navCtrl.isNavigationBarHidden = true
        navCtrl.view.frame = rootViewController.view.frame

        navCtrl.view.layoutIfNeeded()


        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = navCtrl
        })
        { (_) in

     //               SideMenuController.preferences.basic.direction = Constants.current_Language.contains("en") ? .right : .left

        }
    }
    
    func restartApplicationToHome(){
        //        goToHome
        var tabBar : UITabBarController?
        let navController = UINavigationController()
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        guard let window = keyWindow else {return}
        let storyb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        tabBar = storyb.instantiateViewController(withIdentifier: "rootNav") as? UITabBarController
        navController.navigationBar.isHidden = true
        if let tabBar = tabBar {
            navController.viewControllers = [tabBar]
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
    }
    
    
    
    
    func presenttOrPush(vc : UIViewController) {
        if  self.window?.currentViewController()?.navigationController != nil {
            self.window?.currentViewController()?.navigationController?.pushViewController(vc, animated: true)
        }else {
            self.window?.currentViewController()?.presentInFullScreen(vc, animated: true, completion: nil   )
        }
        //        self.window?.currentViewController()?.present(vc, animated: true, completion: nil   )
        
    }
    func present(vc : UIViewController) {
             self.window?.currentViewController()?.presentInFullScreen(vc, animated: true, completion: nil   )
         //        self.window?.currentViewController()?.present(vc, animated: true, completion: nil   )
        
    }
    
    func Push(vc : UIViewController) {
        self.window?.currentViewController()?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
    
      
         func isOnline()->Bool {
           
           if Reachability.isConnectedToNetwork(){
               print("Internet Connection Available!")
               return true
           }else{
               print("Internet Connection not Available!")
            self.CurrentRootVC()?.showDAlert(title: "NoInternetConnection".localized, subTitle: "connectToInternet".localized, type: .net,buttonTitle: "tryAgain".localized, completionHandler: nil)
               return false
           }
    
       }
    
    

    
    
    //Modals
//
//    func modalInPreview(type:Modal_Types){
//        let modal =  ModalVC()
//        modal.selected_modal_type = type
//        modal.modalPresentationStyle = .overFullScreen
//        modal.modalTransitionStyle = .crossDissolve
//        ad.presenttOrPush(vc: modal)
//    }
//
     

      
      func saveUserLogginData(email:String?,shortName : String? , token : String?,fullName:String?,phoneNum:String?,accountType:Int?,id_number:String?,idExpiryDate:String? = nil,birthdate:String? = nil,userIdType:Int?) {
          
  //        print("saving User Data email: \(String(describing: email)) , photoUrl: \(String(describing: photoUrl)),uid: \(String(describing: uid)),  , photoUrl: \(String(describing: name))")
          
          if email != "X" {
              if   let email = email   {
                  UserDefaults.standard.setValue(email, forKey: "userEmail")
              }else{
                  UserDefaults.standard.setValue(nil, forKey: "userEmail")
                  
              }
          }
          if phoneNum != "X" {
              if   let phoneNum = phoneNum   {
                  UserDefaults.standard.setValue(phoneNum, forKey: "phoneNum")
              }else{
                  UserDefaults.standard.setValue(nil, forKey: "phoneNum")
                  
              }
          }
          
          if shortName != "X" {
              
              if  let shortName = shortName {
                  UserDefaults.standard.setValue(shortName, forKey: "shortName")
                  //              ////print("saing this photo : \(photo)")
              }else {
                  UserDefaults.standard.setValue(nil, forKey: "shortName")
              }
          }
          if token != "X" {
              if let newToken = token {
                  do {
                      try Locksmith.updateData(data: ["UserId": newToken], forUserAccount: "UserId")
                      ////print("Saved Token \(newToken)⚛️")
                  } catch {
                      ////print("Couldn't save token ")
                      do {
                          try Locksmith.saveData(data: ["UserId": newToken], forUserAccount: "UserId")
                          ////print("☸️Updated Token \(newToken)⚛️")
                          
                      } catch {
                          ////print("Couldn't save token ")
                      }
                  }
              }else {
                  print("📌sacingUser data Token == NIL 🖍")
                  UserDefaults.standard.setValue(nil, forKey: "hasSentPlayerID")
                  UserDefaults.standard.setValue(nil, forKey: "hasSentPremiumPlayerID")
                  Constants.hasSentPlayerID = nil
                  
                  do {
                      try Locksmith.deleteDataForUserAccount( userAccount: "token")
                  } catch {
                      ////print("Couldn't save token ")
                  }
              }
          }
          if fullName != "X" {
              
              if let fullName = fullName {
                  UserDefaults.standard.setValue(fullName, forKey: "fullName")
              }else {
                  UserDefaults.standard.setValue(nil, forKey: "fullName")
              }
          }
          
              if let userIdType = userIdType {
                  UserDefaults.standard.setValue(userIdType, forKey: "UserIDTypeID")
              }
              else {
                  UserDefaults.standard.setValue(nil, forKey: "UserIDTypeID")
              }
          
          if let _ = accountType {
              if let accountType = accountType {
                  UserDefaults.standard.setValue(accountType, forKey: "accountType")
              }
              else {
                  UserDefaults.standard.setValue(nil, forKey: "accountType")
              }
          }
        
          
          if let  id_number = id_number {
              UserDefaults.standard.setValue(id_number, forKey: "id_number")
          }
          else
          {
              UserDefaults.standard.setValue(nil, forKey: "id_number")
          }
      }
    
    
    func logout() {
        
        self.save(userId: nil, token: nil    )
        ad.restartApplicationToLogin()
     }
    
    func save(userId:String?,token : String?)-> Bool {
        guard  let userID = userId  , userID != "" else {
             do {
                try Locksmith.deleteDataForUserAccount( userAccount: "UserId")
                saveToken(token)
                return false
            } catch {
                ////print("Couldn't save UserId ")
                saveToken(token)
                return false
            }
            return false }
            do {
                try Locksmith.updateData(data: ["UserId": userID], forUserAccount: "UserId")
               print("Saved UserId \(userID)⚛️")
                return saveToken(token)
            } catch {
               print("Couldn't save token ")
                do {
                    try Locksmith.saveData(data: ["UserId": userID], forUserAccount: "UserId")
                     print("☸️Updated UserId \(userID)⚛️")
                    return saveToken(token)
                } catch {
                    print("Couldn't save UserId ")
                    return false
                }
            }
        
     }
    func user_type () -> String{
          #if Team
          return "2"
          #else
          return "1"
          #endif
      }
    func isUser () -> Bool{
             #if Team
             return false
             #else
             return true
             #endif
         }
    func saveToken(_ token : String? ) -> Bool{
             if let newToken = token , newToken != ""  {
                do {
                    try Locksmith.updateData(data: ["token": newToken], forUserAccount: "token")
                   print("Saved Token \(newToken)⚛️")
                    return true
                } catch {
                   print("Couldn't save token ")
                    do {
                        try Locksmith.saveData(data: ["token": newToken], forUserAccount: "token")
                       print("☸️Updated Token \(newToken)⚛️")
                        return true
                        
                    } catch {
                      print("Couldn't save token ")
                        return false
                    }
                }
            }else {
                 do {
                    try Locksmith.deleteDataForUserAccount( userAccount: "token")
                    return false
                } catch {
                    print("Couldn't delete token ")
                    return false
                }
         }
    }
}

