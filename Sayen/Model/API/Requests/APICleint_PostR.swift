//
//  APICleint_PostR.swift
//  Theme
//
//  Created by Eslam Abo El Fetouh on 3/21/20.
//  Copyright © 2020 Eslam Abo El Fetouh. All rights reserved.
//

import Foundation
 import Alamofire
 import SwiftyJSON


extension APIClient {
    
    
    
    //MARK: Login
    static func loginRequest(mobile : String ,password:String,country_code:String, completionHandler:@escaping (Bool,String,Int)->Void , completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .login(phone: mobile, password: password,country_code: country_code)  ,headers: ["lang":"\(Constants.current_Language)"] ,  { (jsonData) in
            let json = JSON(jsonData)
            
            DispatchQueue.main.async {
                let sms  = json["message"].string ?? json["error"].stringValue
                guard let token = json["token"].string , token.count > 4 else {
                    guard json["status_code"].intValue != 409 else {
                        
                        completionHandler(false,sms,409)
                        return
                    }
                    guard json["status_code"].intValue != 400 else {
                        
                        completionHandler(false,sms,400)
                        return
                    }
                    guard json["status_code"].intValue != 401 else {
                        
                        completionHandler(false,sms,401)
                        return
                    }
                    defer{ completionHandler(false ,sms,404) }
                    let x = HTTPStatusCode(rawValue: json["status_code"].int ?? 404)
                    completionHandler(false,sms,0)
                    print(x.debugDescription)
                    
                    //ad.CurrentRootVC()?.showApiErrorSms(err: sms)
                    return
                }
                UserDefaults.standard.set(1, forKey: "banned")
                Constants.user_token = json["token"].stringValue
                 Constants.user_ID = json["user"]["id"].int != nil ? "\(json["user"]["id"].intValue)" : ""
                Constants.UserName = json["user"]["name"].string != nil ? "\(json["user"]["name"].stringValue)" : ""
                Constants.phoneNum = mobile
                completionHandler(true,sms,200)
            }
            
        }) { (error) in
            DispatchQueue.main.async {
               // ad.CurrentRootVC()?.showApiErrorSms(err: error.debugDescription)
                print(error.debugDescription)
                completionFaliure(error)
            }
        }
    }
    
    
    /*
     {
       "message" : "Success save",
       "status_code" : 200
     }
     */
    static func registerRequest(mobile : String ,password:String,country_code:String,excellence_client : Int,building_id : Int,flat:String, completionHandler:@escaping (Bool,String)->Void , completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .register(mobile: mobile, password: password, country_code: country_code, excellence_client: excellence_client,building_id:building_id,flat:flat),headers: ["lang":"\(Constants.current_Language)"] ,  { (jsonData) in
             let json = JSON(jsonData)
            print(json)
            let sms = json["message"].string ?? json["error"].stringValue
            let state = json["status_code"].int == 200 ? true : false
           
            completionHandler(state,sms)
        }){ (error) in
            DispatchQueue.main.async {
              //   ad.CurrentRootVC()?.showApiErrorSms(err: error.debugDescription)
                print(error.debugDescription)
                completionFaliure(error)
            }
        }
        
    }
    
    
    //MARK: Team Register
    static func registerTeamRequest(name:String,mobile : String,email:String ,password:String,country_code:String, completionHandler:@escaping (Bool,String)->Void , completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .registerTeam(name:name,mobile: mobile,email:email, password: password, country_code: country_code),headers: ["lang":"\(Constants.current_Language)"] ,  { (jsonData) in
             let json = JSON(jsonData)
            print(json)
            let sms = json["message"].string ?? json["error"].stringValue
            let state = json["status_code"].int == 200 ? true : false
           
            completionHandler(state,sms)
        }){ (error) in
            DispatchQueue.main.async {
              //   ad.CurrentRootVC()?.showApiErrorSms(err: error.debugDescription)
                print(error.debugDescription)
                completionFaliure(error)
            }
        }
        
    }
    
    //MARK: verifyCode
    static func verifyCodeReuqest(mobile : String,code : String , country_code : String , code_type : String,user_type : String ,type : type, completionHandler:@escaping (Bool,String)->Void , completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .verifyCode(phone: mobile, country_code: country_code, code: code, code_type: code_type ,user_type : user_type) ,headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
              let json = JSON(jsonData)
              let sms  = json["message"].string ?? json["error"].stringValue

              DispatchQueue.main.async {
                  let data = DefaultModel(fromJson: json)
                   guard data.success else {
                      defer{ completionHandler(false ,data.message) }
                      let x = HTTPStatusCode(rawValue: json["status_code"].int ?? 404)
                      print(x.debugDescription)
                     // ad.CurrentRootVC()?.showApiErrorSms(err: sms)
                      return
                  }
                if type == .register {
                    Constants.user_token = json["token"].stringValue
                    Constants.user_ID = json["user"]["id"].int != nil ? "\(json["user"]["id"].intValue)" : ""
                    Constants.UserName = json["user"]["name"].string != nil ? "\(json["user"]["name"].stringValue)" : ""
                    Constants.phoneNum = mobile
                }
                if type == .forgetPass {
                     Constants.token2 = json["token"].stringValue
                }
                  UserDefaults.standard.set(1, forKey: "banned")
                  completionHandler(true,sms)
              }
              
          }) { (error) in
              DispatchQueue.main.async {
               //   ad.CurrentRootVC()?.showApiErrorSms(err: error.debugDescription)
                  print(error.debugDescription)
                  completionFaliure(error)
              }
          }
      }
  //MARK: ForgetPass
    static func forgetPassRequest(mobile : String ,country_code:String, user_type : String, completionHandler:@escaping (Bool,String)->Void , completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .forgotPass(mobile: mobile, country_code: country_code , user_type : user_type) ,headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
            let json = JSON(jsonData)
            let sms  = json["message"].string ?? json["error"].stringValue

            DispatchQueue.main.async {
                guard json["status_code"].intValue == 200  else {
                    defer{ completionHandler(false ,sms) }
                    let x = HTTPStatusCode(rawValue: json["status_code"].int ?? 404)
                    
                    print(x.debugDescription)
                   // ad.CurrentRootVC()?.showApiErrorSms(err:sms )
                    return
                }

                completionHandler(true,sms)
            }
            
        }) { (error) in
            DispatchQueue.main.async {
               //ad.CurrentRootVC()?.showApiErrorSms(err: error.debugDescription)
                print(error.debugDescription)
                completionFaliure(error)
            }
        }
    }
    
    
    
    
    //MARK: resendCode
      static func resendCodeReqeust(mobile : String, country_code : String , code_type : String,user_type : String  , completionHandler:@escaping (Bool,String)->Void , completionFaliure:@escaping (_ error:Error?)->Void){
          ad.isLoading()
          performSwiftyRequest(route: .resendCode(phone: mobile, country_code: country_code, code_type: code_type ,user_type : user_type) ,  { (jsonData) in
              let json = JSON(jsonData)
              let sms  = json["message"].string ?? json["error"].stringValue

              DispatchQueue.main.async {
                  let data = DefaultModel(fromJson: json)
                  ad.killLoading()
                  guard data.success else {
                      defer{ completionHandler(false ,sms) }
                      let x = HTTPStatusCode(rawValue: json["status_code"].int ?? 404)
                       print(x.debugDescription)
                     // ad.CurrentRootVC()?.showApiErrorSms(err: sms)
                      return
                  }
                  
                  completionHandler(true,"")
              }
              
          }) { (error) in
              DispatchQueue.main.async {
                  ad.killLoading()
                 // ad.CurrentRootVC()?.showApiErrorSms(err: error.debugDescription)
                  print(error.debugDescription)
                  completionFaliure(error)
              }
          }
      }

     //MARK: changePassword
       static func changePassRequest(password : String ,user_type : String, completionHandler:@escaping (Bool,String,Int)->Void , completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .changePassword(password: password, user_type : user_type)   ,headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
             let json = JSON(jsonData)

             DispatchQueue.main.async {
                 let sms  = json["message"].string ?? json["error"].stringValue
                 guard let status = json["status_code"].int , status == 200  else {

                    //  ad.CurrentRootVC()?.showApiErrorSms(err: sms)
                   completionHandler(false ,sms,404)
                     return
                 }

                 completionHandler(true,sms,200)
             }

         }) { (error) in
             DispatchQueue.main.async {
                //  ad.CurrentRootVC()?.showApiErrorSms(err: error.debugDescription)
                 print(error.debugDescription)
                 completionFaliure(error)
             }
         }
     }
    
    
    //MARK: resetNewPass
    static func resetPassword(password : String,oldpassword : String ,user_type : String, completionHandler:@escaping (Bool,String,Int)->Void , completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .resetPass(password: password, user_type : user_type , old_password : oldpassword)   ,headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
            let json = JSON(jsonData)

            DispatchQueue.main.async {
                let sms  = json["message"].string ?? json["error"].stringValue
                guard let status = json["status_code"].int , status == 200  else {

                   //  ad.CurrentRootVC()?.showApiErrorSms(err: sms)
                  completionHandler(false ,sms,404)
                    return
                }

                completionHandler(true,sms,200)
            }

        }) { (error) in
            DispatchQueue.main.async {
               //  ad.CurrentRootVC()?.showApiErrorSms(err: error.debugDescription)
                print(error.debugDescription)
                completionFaliure(error)
            }
        }
    }
    
    
    
    //MARK: changePhone
    static func changePhone(phone : String , country_code : String ,user_type : String ,  completionHandler:@escaping (Bool,String)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
        performSwiftyRequest(route: .changePhone(phone: phone, country_code: country_code, user_type: user_type),headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
            let json = JSON(jsonData)
            DispatchQueue.main.async {
                let sms  = json["message"].string ?? json["error"].stringValue
                guard let status = json["status_code"].int , status == 200  else {
                    
                    //  ad.CurrentRootVC()?.showApiErrorSms(err: sms)
                    completionHandler(false ,sms)
                    return
                }
                
                completionHandler(true,sms)
            }
            
            
        }){ (error) in
            DispatchQueue.main.async {
                //  ad.CurrentRootVC()?.showApiErrorSms(err: error.debugDescription)
                print(error.debugDescription)
                completionFaliure(error)
            }
        }
        
        
        
        
    }
    
    
    
    
    static func postProfileUpdate(parameters : [String : Any] ,   imageDict : [String:UIImage],completed : @escaping (Bool,String)->()) {
        let url = "https://sayen.cems-it.com/api/v1/upload-profile-image"
     
        longSessionManager.upload(multipartFormData: { (multipartFormData) in
            for (key,value) in imageDict{
                if let image = value.jpegData(compressionQuality: 0.5){
                    multipartFormData.append(image , withName: key , fileName: "file.jpeg" , mimeType: "image/jpeg")
                    multipartFormData.append(image , withName: key, fileName: "swift_file.jpg", mimeType: "image/jpg")
                    
                }
                
            }
            
            print(imageDict)
            
            for (key, value) in imageDict {
                
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            
            }
            for (key, value) in parameters {
               multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                       }
            print(multipartFormData)
        
        }, to:url, method: .post, headers:["Authorization":"Bearer \(Constants.user_token)"])
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    guard  let value = response.result.value else {
                        completed(false,"tryAgain".localized)
                        return
                    }
                    let json = JSON( value)
                    print("that;s json \(json)")
                    let sms = json["message"].string ?? json["error"].stringValue
                    guard let status = json["status_code"].int , status == 200  else {
                        completed( false ,sms)
                        return
                    }
                    completed(true ,sms)
                }
            case .failure(let encodingError):
                
                print(encodingError.localizedDescription)
                completed(false,"tryAgain".localized)
            }
            
        }
        
         
    }
    
    
    
    
    //MARK: updateProfileInfo
    
    
    static func changeInfoUser(name : String , email : String, excellence_client : String,building_id:Int,flat:String ,  completionHandler:@escaping (Bool,String)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
        
        performSwiftyRequest(route: .update_profile(name: name, excellence_client: excellence_client, email: email,building_id:building_id,flat:flat),headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
            let json = JSON(jsonData)
            DispatchQueue.main.async {
                let sms  = json["message"].string ?? json["error"].stringValue
               
                guard let status = json["status_code"].int , status == 200  else {
                    
                    completionHandler(false ,sms)
                    return
                }
                
                completionHandler(true,sms)
            }
        }) { (error) in
            DispatchQueue.main.async {
               
                print(error.debugDescription)
                completionFaliure(error)
            }
        }
        
    }
    
    
    
    static func changeInfoTeam(name : String , email : String,  completionHandler:@escaping (Bool,String)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
        
        performSwiftyRequest(route: .update_profileT(name: name , email: email),headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
            let json = JSON(jsonData)
            DispatchQueue.main.async {
                let sms  = json["message"].string ?? json["error"].stringValue
                guard let status = json["status_code"].int , status == 200  else {
                    
                    completionHandler(false ,sms)
                    return
                }
                
                completionHandler(true,sms)
            }
        }) { (error) in
            DispatchQueue.main.async {
               
                print(error.debugDescription)
                completionFaliure(error)
            }
        }
        
    }
    
    
  //MARK: logout
    static func logoutHandler(user_type : String , completionHandler:@escaping (Bool)->Void , completionFaliure:@escaping (_ error:Error?)->Void){
      ad.isLoading()
    performSwiftyRequest(route: .logout(user_type:user_type) ,headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
          let json = JSON(jsonData)
          let sms  = json["message"].string ?? json["error"].stringValue
          
          DispatchQueue.main.async {
               ad.killLoading()
              guard json["status_code"] == 200  else {
                  DispatchQueue.main.async {
                  completionHandler(true)
                  let x = HTTPStatusCode(rawValue: json["status_code"].int ?? 404)
                  
                  print(x.debugDescription)
                 
                  }
                  return
              }
              DispatchQueue.main.async {
                  completionHandler(true)
              }
          }
          
      }) { (error) in
          DispatchQueue.main.async {
              ad.killLoading()
             
              print(error.debugDescription)
              completionFaliure(error)
          }
      }
  }
    
    
//Mark: sendOrder
    
    static func SendOrder(parameters : [String : Any] ,   imageDict : [UIImage],completed : @escaping (Bool,String,String?,Int?)->()) {
        let url = Constants.ProductionServer.baseURL_V2 +  "user/order"
     
        longSessionManager.upload(multipartFormData: { (multipartFormData) in

            for (index,image) in imageDict.enumerated() {
                if let imageData = image.jpegData(compressionQuality: 0.5) {
                    multipartFormData.append(imageData, withName: "images[\(index)]", fileName: "file.jpeg", mimeType: "image/jpeg")
                }
            }
            
            
            for (key, value) in parameters {
               multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                       }
            print(multipartFormData)
        
        }, to:url, method: .post, headers:["Authorization":"Bearer \(Constants.user_token)"])
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    guard  let value = response.result.value else {
                        completed(false,"tryAgain".localized,nil, nil)
                        return
                    }
                    let json = JSON( value)
                    print("that;s json \(json)")
                    let sms = json["message"].string ?? json["error"].stringValue
                    if let status = json["status_code"].int , status == 400 {
                        completed( false ,sms, nil,nil)
                    }else {
                        completed(true ,sms,json["url"].string, json["order_id"].int)
                    }
                    
                }
            case .failure(let encodingError):
                
                print(encodingError.localizedDescription)
                completed(false,"tryAgain".localized,nil,nil)
            }
            
        }
        
         
    }
    
//    { response in
//        guard  let value = response.result.value else {
//            completed(false,"tryAgain".localized,nil, nil)
//            return
//        }
//        let json = JSON( value)
//        print("that;s json \(json)")
//        let sms = json["message"].string ?? json["error"].stringValue
//        if let url = json["url"].string {
//            completed(true ,sms,url)
//        }else {
//            guard let status = json["status_code"].int , status == 200  else {
//                completed( false ,sms, nil,nil)
//                return
//            }
//            completed(true ,sms,json["url"].string, json["order_id"].int)
//        }
//    }
    
    
//MARK: cancelOrder
    static func cancelOrder(order_id : Int , completionHandler:@escaping (Bool,String)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
         
         performSwiftyRequest(route: .cancel_order(order_id: order_id),headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
             let json = JSON(jsonData)
             DispatchQueue.main.async {
                 let sms  = json["message"].string ?? json["error"].stringValue
                 guard let status = json["status_code"].int , status == 200  else {
                     
                     completionHandler(false ,sms)
                     return
                 }
                 
                 completionHandler(true,sms)
             }
         }) { (error) in
             DispatchQueue.main.async {
                
                 print(error.debugDescription)
                 completionFaliure(error)
             }
         }
         
     }
    
    
    
    
    //MARK: validate copon
    static func validateCoupon(code : String,total_price : String , serviceId : Int , completionHandler:@escaping (Bool,String,Double,Double,String)->Void , completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .validateCoupon(code: code, total_price: total_price , service_id : serviceId )  ,headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
            let json = JSON(jsonData)
            DispatchQueue.main.async {
                let sms  = json["message"].string ?? json["error"].stringValue
                guard let status = json["status_code"].int , status == 200  else {
                    
                  
                    completionHandler(false ,sms , 0.0 , 0.0 ,"")
                    return
                }
                let coupon_discount = json["coupon_discount"].doubleValue
                let total_price_after_coupon = json["total_price_after_coupon"].doubleValue
                let total_price_before_coupon = json["total_price_before_coupon"].stringValue

                completionHandler(true,sms ,coupon_discount,total_price_after_coupon,total_price_before_coupon)
            }

        }) { (error) in
            DispatchQueue.main.async {
       
                print(error.debugDescription)
                completionFaliure(error)
            }
        }
    }
    
    
    
    
    //MARK: userAccept Order
    static func sendAcceptPrice(order_id : Int,status : String , completionHandler:@escaping (Bool,String)->Void , completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .userAcceptPrice(order_id: order_id, status: status) ,headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
            let json = JSON(jsonData)
            DispatchQueue.main.async {
                let sms  = json["message"].string ?? json["error"].stringValue
                guard let status = json["status_code"].int , status == 200  else {
                    
                  
                    completionHandler(false ,sms )
                    return
                }
      

                completionHandler(true,sms )
            }

        }) { (error) in
            DispatchQueue.main.async {
       
                print(error.debugDescription)
                completionFaliure(error)
            }
        }
    }
    
    
    
    //MARK: RatingTeam
    static func ratingTeamService(order_id : Int,rate_service_value : Int ,rate_team_value : Int ,rate_service_comment : String ,rate_team_comment : String ,completionHandler:@escaping (Bool,String)->Void , completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .rateWorker(order_id: order_id, rate_service_value: rate_service_value, rate_team_value: rate_team_value, rate_service_comment: rate_service_comment, rate_team_comment: rate_team_comment) ,headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
            let json = JSON(jsonData)
            DispatchQueue.main.async {
                let sms  = json["message"].string ?? json["error"].stringValue
                guard let status = json["status_code"].int , status == 200  else {
                    
                  
                    completionHandler(false ,sms )
                    return
                }
      

                completionHandler(true,sms )
            }

        }) { (error) in
            DispatchQueue.main.async {
       
                print(error.debugDescription)
                completionFaliure(error)
            }
        }
    }
    
    
    //MARK: Reportproblem
     static func teamReportProblem(order_id : Int,problem_type : Int ,completionHandler:@escaping (Bool,String)->Void , completionFaliure:@escaping (_ error:Error?)->Void){
         performSwiftyRequest(route: .teamreportProblem(order_id: order_id, problem_type: problem_type) ,headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
             let json = JSON(jsonData)
             DispatchQueue.main.async {
                 let sms  = json["message"].string ?? json["error"].stringValue
                 guard let status = json["status_code"].int , status == 200  else {
                     
                   
                     completionHandler(false ,sms )
                     return
                 }
       

                 completionHandler(true,sms )
             }

         }) { (error) in
             DispatchQueue.main.async {
        
                 print(error.debugDescription)
                 completionFaliure(error)
             }
         }
     }
    
    
    
    
    //MARK: Notification Seen
     static func notificationSeen(user_type : String ,notification_id : Int ,completionHandler:@escaping (Bool,String)->Void , completionFaliure:@escaping (_ error:Error?)->Void){
         performSwiftyRequest(route: .notification_seen(user_type: user_type, notification_id: notification_id) ,headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
             let json = JSON(jsonData)
             DispatchQueue.main.async {
                 let sms  = json["message"].string ?? json["error"].stringValue
                 guard let status = json["status_code"].int , status == 200  else {
                     
                   
                     completionHandler(false ,sms )
                     return
                 }
       

                 completionHandler(true,sms )
             }

         }) { (error) in
             DispatchQueue.main.async {
        
                 print(error.debugDescription)
                 completionFaliure(error)
             }
         }
     }
    
    
    
    
    //MARK: userSnedMessage
     static func userSnedMessage(name : String , message : String ,completionHandler:@escaping (Bool,String)->Void , completionFaliure:@escaping (_ error:Error?)->Void){
         performSwiftyRequest(route: .userSendMessage(name: name, message: message) ,headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
             let json = JSON(jsonData)
             DispatchQueue.main.async {
                 let sms  = json["message"].string ?? json["error"].stringValue
                 guard let status = json["status_code"].int , status == 200  else {
                     
                   
                     completionHandler(false ,sms )
                     return
                 }
       

                 completionHandler(true,sms )
             }

         }) { (error) in
             DispatchQueue.main.async {
        
                 print(error.debugDescription)
                 completionFaliure(error)
             }
         }
     }
    
    
    //MARK: updateLocation
    static func updateLocation(lat : Double , lng : Double ,completionHandler:@escaping (Bool,String)->Void , completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .updateLocation(lat: lat, lng: lng) ,headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
            let json = JSON(jsonData)
            DispatchQueue.main.async {
                let sms  = json["message"].string ?? json["error"].stringValue
                guard let status = json["status_code"].int , status == 200  else {
                    
                  
                    completionHandler(false ,sms )
                    return
                }
      

                completionHandler(true,sms )
            }

        }) { (error) in
            DispatchQueue.main.async {
       
                print(error.debugDescription)
                completionFaliure(error)
            }
        }
    }
}
