//
//  K.swift
//  Eyas
//
//  Created by emad ios on 12/12/18.
//  Copyright © 2018 emad ios. All rights reserved.
//
import Alamofire
import Locksmith
import UIKit

class Constants {
   
    //    static var lang = L102Language.currentAppleLanguage() == "ar" ? true : false
    static var deviceID = UIDevice.current.identifierForVendor!.uuidString
    static let randomQueue =  DispatchQueue(label: "randomQueue", qos: .utility)
    static let contentSizeObserverKey = "contentSize"
    static let userAppstoreUrl = "https://apps.apple.com/us/app/sayen-user/id1536317315"
    static let workerAppstoreUrl = "https://apps.apple.com/us/app/sayen-team/id1536320901"
    static let invoicePdf = "https://sayen.co/api/v2/makePdf/"
    static var firebaseTokenKey = "firebaseToken"
    static var merchantName = "Sayn App (Yaqoub Alarfaj)"
    static var deviceType = "iOS"
    static let  selectedImg = UIImage(named:"Radio-On-Enabled")
    static let deSelectedImg = UIImage(named:"Radio-Off-Enabled")
//    static let GOOGLE_MAPS_API_KEY = "AIzaSyAwyQnnV0Z4PaFX645Ua1PMX56qlbuHvls"
    static let GOOGLE_MAPS_API_KEY = "AIzaSyD0lvyEMmVw-jCqobmghYJaopzaks9M83A"
    static var contactUsNumober = "0509997657"

    static var currency = "SAR"
      static var user_token  : String {
         set {
             
             ad.updateKeyChainValue(key: "token", value: newValue)
         }
         get {
             guard let dict = Locksmith.loadDataForUserAccount(userAccount: "token") , let tkn  = dict["token"] as? String else {
                 return ""
             }
             print("user_token:💮\(tkn) 💮")
             
             return tkn
         }
     }
    
    
    static var apiToken  : String {
        get {
            guard let tkn  = UserDefaults.standard.value(forKey: "apiToken") as? String else {
                return ""
            }
            return tkn
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "apiToken")
        }
    }
    
    
    static var shoppingCartID  : Int {
        get {
            guard let tkn  = UserDefaults.standard.value(forKey: "shoppingCartID") as? Int else {
                return 0
            }
            return tkn
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "shoppingCartID")
        }
    }
    
    
      static var user_ID  : String {
        set {
            
            ad.updateKeyChainValue(key: "UserId", value: newValue)
        }
        get {
            guard let dict = Locksmith.loadDataForUserAccount(userAccount: "UserId") , let UserId  = dict["UserId"] as? String else {
                return "0"
            }
            print("UserId:💮\(UserId) 💮")
            
            return UserId
        }
    }

    static var texsPercentge  : Int {
        get {
            guard let tkn  = UserDefaults.standard.value(forKey: "texsPercentge") as? Int else {
                return 0
            }
            return tkn
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "texsPercentge")
        }
    }
//
    
    static var current_Language : String {
        get {
            guard let current_Language  = UserDefaults.standard.value(forKey: "current_Language") as? String else {
                return "NotSelected"
            }
            return current_Language
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "current_Language")
        }
    }
    
    //    phoneNum
    //    userEmail
      static var phoneNum  : String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "phoneNum")
            UserDefaults.standard.synchronize()
        }
        get {
            guard let tkn  = UserDefaults.standard.value(forKey: "phoneNum") as? String else {
                return ""
            }
            return tkn
        }
    }
    
     static var token2  : String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "token2")
            UserDefaults.standard.synchronize()
        }
        get {
            guard let tkn  = UserDefaults.standard.value(forKey: "token2") as? String else {
                return ""
            }
            return tkn
        }
    }
    
    
    
     static var UserName  : String {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "UserName")
            UserDefaults.standard.synchronize()
        }
        get {
            guard let tkn  = UserDefaults.standard.value(forKey: "UserName") as? String else {
                return ""
            }
            return tkn
        }
    }


    
    static var userEmail  : String {
        get {
            guard let tkn  = UserDefaults.standard.value(forKey: "userEmail") as? String else {
                return ""
            }
            return tkn
        }
    }
    
    
    static var user_activation : Int {
        get {
            guard let user_activation_  = UserDefaults.standard.value(forKey: "user_activation") as? Int else {
                return 0
            }
            print("user_activation:💮\(user_activation_) 💮")
            return user_activation_
        }
    }
    
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0...length-1).map{ _ in letters.randomElement()! })
    }
    static var user_image  : String {
        get {
            guard let tkn  = UserDefaults.standard.value(forKey: "profileImage") as? String else {
                return ""
            }
            return tkn
        }
    }
    
    static var user_name  : String {
        get {
            guard let tkn  = UserDefaults.standard.value(forKey: "userName") as? String else {
                return ""
            }
            return tkn
        }
    }
    
    static var user_rate  : Int {
        get {
            guard let tkn  = UserDefaults.standard.value(forKey: "userRate") as? Int else {
                return 0
            }
            return tkn
        }
    }
    
    static var has_free : Bool {
        get {
            guard let free  = UserDefaults.standard.value(forKey: "has_free") as? Int else {
                return false
            }
            
            return free == 1 ? true : false
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "has_free")
        } 
    }
    
    static var email_verified : Bool {
        get {
            guard let tkn  = UserDefaults.standard.value(forKey: "email_verified") as? Int else {
                return false
            }
            return tkn == 1 ? true : false
        }
    }
    
    
    
    static var updateProfileNeeded : Bool {
        get {
            guard let tkn  = UserDefaults.standard.value(forKey: "updateProfileNeeded") as? Bool else {
                return false
            }
            return tkn
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: "updateProfileNeeded")
            UserDefaults.standard.synchronize()
        }
    }
    
    static var isFirstLogin : Bool {
        get {
            guard let tkn  = UserDefaults.standard.value(forKey: "isFirstLogin") as? Int else {
                return false
            }
            return tkn == 1 ? true : false
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "isFirstLogin")
        }
    }
    
    static var user_debt  : Int {
        get {
            guard let tkn  = UserDefaults.standard.value(forKey: "debt") as? Int else {
                return 0
            }
            return tkn
        }
    }
    
    static var user_balance  : Double {
        get {
            guard let tkn  = UserDefaults.standard.value(forKey: "user_balance") as? Double else {
                return 0.0
            }
            return tkn
        }
    }
    
    static var timerForEnd_Consultation  : Int {
        get {
            guard let tkn  = UserDefaults.standard.value(forKey: "timerForEnd_Consultation") as? Int else {
                return 0
            }
            return tkn
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "timerForEnd_Consultation")
        }
    }
    
    static var timerForLive_Consultation  : Int {
        get {
            guard let tkn  = UserDefaults.standard.value(forKey: "timerForLive_Consultation") as? Int else {
                return 0
            }
            return tkn
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "timerForLive_Consultation")
        }
    }
    static var free_min_cost_Consultation  : Int {
        get {
            guard let tkn  = UserDefaults.standard.value(forKey: "free_min_cost_Consultation") as? Int else {
                return 0
            }
            return tkn
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "free_min_cost_Consultation")
        }
    }
    
    
    static var hasSentPlayerID  : Bool? {
        get {
            guard let tkn  = UserDefaults.standard.value(forKey: "hasSentPlayerID") as? Bool else {
                return nil
            }
            return tkn
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "hasSentPlayerID")
        }
    }
    
    static var oneSignalToken  : String? {
        get {
            guard let tkn  = UserDefaults.standard.value(forKey: "oneSignalToken") as? String else {
                return nil
            }
            return tkn
            
        }
        
        set {
            UserDefaults.standard.setValue(newValue, forKey: "oneSignalToken")
        }
    }
    
    
    
    
    enum S_Code : Int{
        case parameter_faild_validation = 422
        case login_data_not_exist = 401
        case invalid_data = 404
        case account_not_active = 405
        case phone_not_verified = 403
        case success = 200
        case mail_need_verify = 201
    }
    
    struct ProductionServer {
        
         static let baseURL = "https://sayen.co/api/v1/"
        static let baseURL_V2 = "https://sayen.co/api/v2/"
         static let imageURL = "https://sayen.co/api/v1/"
    }
    
    enum APIParameters :String{
        case message
        case code
        case token
        case status_code
    }
    
    enum HTTPHeaderField: String {
        case token = "x-access-token"
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
        case Language = "Accept-Language"
    }
    
    enum ContentType: String {
        case json = "application/json"
    }
}
