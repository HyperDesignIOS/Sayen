//
//  APIClient_GetR.swift
//  Theme
//
//  Created by Eslam Abo El Fetouh on 3/21/20.
//  Copyright © 2020 Eslam Abo El Fetouh. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


//MARK: GetRequests
extension APIClient {
    
    //MARK: getProfileInfo
    static func getProfileData(user_type : String,completionHandler:@escaping (Bool,String,UserProfile_Data?)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
        performSwiftyRequest(route: .get_profile(user_type: user_type),headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
            let json = JSON(jsonData)
            print(json)
            DispatchQueue.main.async {
                let sms  = json["message"].string ?? json["error"].stringValue
                guard let status = json["status_code"].int , status == 200  else {
                    
                    completionHandler(false ,sms , nil)
                    return
                }
                let data = UserProfile_Data(json["user"])
                print(data)
                completionHandler(true,sms , data)
            }
        }) { (error) in
            DispatchQueue.main.async {
                
                print(error.debugDescription)
                completionFaliure(error)
            }
        }
    }
    
//    user/success-pay
    static func sendGetRequestWithParamter(_ url: String, parameters: [String: String], completion: @escaping ([String: Any]?, Error?) -> Void) {
        var components = URLComponents(string: url)!
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        let request = URLRequest(url: components.url!)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,                              // is there data
                let response = response as? HTTPURLResponse,  // is there HTTP response
                200 ..< 300 ~= response.statusCode,           // is statusCode 2XX
                error == nil                                  // was there no error
            else {
                completion(nil, error)
                return
            }
            
            let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
            completion(responseObject, nil)
        }
        task.resume()
    }
    
    //MARK: Get Services
    
  static func getServices (completionHandler:@escaping (Bool, [HomeData]? , [OfferService]? , UserProfile_Data?, Setting_Data? , [EmService] )->Void , completionFaliure:@escaping (_ error:Error?)->Void){
    performSwiftyRequest(route: .service , headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
              let json = JSON(jsonData)
              print(json)
              DispatchQueue.main.async {

                var data : [HomeData] = []
                let user : UserProfile_Data? = UserProfile_Data(json["user_data"])
                let versionData : Setting_Data = Setting_Data(json["setting"])
                var emergencyServices : [EmService] = []
                for (_,jsn) in json["services"] {
                        data.append(HomeData(jsn))
                    }
                
                  var OfferData : [OfferService] = []
                  for (_,jsn) in json["offers"] {
                      let offerService : HomeData = HomeData(jsn["service"])
                      let offer = OffersRoot(jsn)
                      OfferData.append(OfferService(offer: offer, service: offerService))
                  }
                  for (_,jsn) in json["emergencyServices"] {
                      emergencyServices.append(EmService(jsn))
                      }
                  
                  print(OfferData)
//                let sms  = json["message"].string ?? json["error"].stringValue
                 let status = data.count > 0 ? true : false
                if !status {
                    
                    completionHandler(status,nil, nil ,nil,nil,[])
                    return
                }
                  completionHandler(status,data, OfferData , user,versionData , emergencyServices)
            }
          }) { (error) in
              DispatchQueue.main.async {
                  
                  print(error.debugDescription)
                  completionFaliure(error)
              }
          }
        
    }
    
    static func getSubServices (serviceId : Int , completionHandler:@escaping (Bool,[HomeData]? , UserProfile_Data?)->Void , completionFaliure:@escaping (_ error:Error?)->Void){
      performSwiftyRequest(route: .subService(serviceId: serviceId) , headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
                let json = JSON(jsonData)
                print(json)
                DispatchQueue.main.async {

                  var data : [HomeData] = []
                  let user : UserProfile_Data? = UserProfile_Data(json["user_data"])
                  for (_,jsn) in json["services"] {
                          data.append(HomeData(jsn))
                      }
                  
                    print(data)
  //                let sms  = json["message"].string ?? json["error"].stringValue
                   let status = data.count >= 0 ? true : false
                  if !status {
                      
                      completionHandler(status,nil, nil)
                      return
                  }
                    completionHandler(status,data, user)
              }
            }) { (error) in
                DispatchQueue.main.async {
                    
                    print(error.debugDescription)
                    completionFaliure(error)
                }
            }
          
      }
      
    
        //MARK: Get current Order
        
    static func getCurrentOrder (offset : Int , completionHandler:@escaping (Bool,[Orders]? , Int)->Void , completionFaliure:@escaping (_ error:Error?)->Void){
            performSwiftyRequest(route: .currentOrder(offset: offset) ,headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
                  let json = JSON(jsonData)
                  print(json)
                  DispatchQueue.main.async {
                    var data : [Orders] = []
                    for (_,jsn) in json["orders"] {
                        data.append(Orders(jsn))
                    }
                    let total = json["count_data"].intValue
   //                let sms  = json["message"].string ?? json["error"].stringValue
                     let status = data.count >= 0 ? true : false
                    if !status {
                        
                        completionHandler(status,nil , 0)
                        return
                    }
                 
                      completionHandler(status,data , total)
                }
              }) { (error) in
                  DispatchQueue.main.async {
                      
                      print(error.debugDescription)
                      completionFaliure(error)
                  }
              }
            
        }
         //MARK: Get previous Order
         
    static func getPreviousOrder ( offset : Int,completionHandler:@escaping (Bool,[Orders]?, Int)->Void , completionFaliure:@escaping (_ error:Error?)->Void){
             performSwiftyRequest(route: .previousOrder(offset: offset) ,headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
                   let json = JSON(jsonData)
                   print(json)
                   DispatchQueue.main.async {
                     var data : [Orders] = []
                     for (_,jsn) in json["orders"] {
                         data.append(Orders(jsn))
                     }
                    let total = json["count_data"].intValue
             
    //                let sms  = json["message"].string ?? json["error"].stringValue
                     let status = data.count >= 0 ? true : false
                     if !status {
                         
                         completionHandler(status,nil, 0)
                         return
                     }
                  
                       completionHandler(status,data , total)
                 }
               }) { (error) in
                   DispatchQueue.main.async {
                       
                       print(error.debugDescription)
                       completionFaliure(error)
                   }
               }
             
         }

    static func getCurrentEmergencyOrder (offset : Int,lang: String , completionHandler:@escaping (Bool,[Orders]? , Int)->Void , completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .currentِEmergencyOrder(offset: offset,lang: lang) ,headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
                  let json = JSON(jsonData)
                  print(json)
                  DispatchQueue.main.async {
                    var data : [Orders] = []
                    for (_,jsn) in json["orders"] {
                        data.append(Orders(jsn))
                    }
                    let total = json["count_data"].intValue
   //                let sms  = json["message"].string ?? json["error"].stringValue
                     let status = data.count >= 0 ? true : false
                    if !status {
                        
                        completionHandler(status,nil , 0)
                        return
                    }
                 
                      completionHandler(status,data , total)
                }
              }) { (error) in
                  DispatchQueue.main.async {
                      
                      print(error.debugDescription)
                      completionFaliure(error)
                  }
              }
            
        }
         //MARK: Get previous Order
         
    static func getPreviousEmergencyOrder ( offset : Int,lang: String,completionHandler:@escaping (Bool,[Orders]?, Int)->Void , completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .previousِEmergencyOrder(offset: offset,lang: lang) ,headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
                   let json = JSON(jsonData)
                   print(json)
                   DispatchQueue.main.async {
                     var data : [Orders] = []
                     for (_,jsn) in json["orders"] {
                         data.append(Orders(jsn))
                     }
                    let total = json["count_data"].intValue
             
    //                let sms  = json["message"].string ?? json["error"].stringValue
                     let status = data.count >= 0 ? true : false
                     if !status {
                         
                         completionHandler(status,nil, 0)
                         return
                     }
                  
                       completionHandler(status,data , total)
                 }
               }) { (error) in
                   DispatchQueue.main.async {
                       
                       print(error.debugDescription)
                       completionFaliure(error)
                   }
               }
             
         }

    //MARK: getUserOrder
    static func getUserOrder(order_id : Int,completionHandler:@escaping (Bool,String,OrderDetails?)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
             performSwiftyRequest(route: .userOrder(order_id: order_id),headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
              let json = JSON(jsonData)
              print(json)
              DispatchQueue.main.async {
                  let sms  = json["message"].string ?? json["error"].stringValue
                  guard let status = json["status_code"].int , status == 200  else {
                      
                      completionHandler(false ,sms,nil)
                      return
                  }
                  let data = OrderDetails(json["order"])
                  print(data)
                  completionHandler(true,sms,data)
              }
          }) { (error) in
              DispatchQueue.main.async {
                  
                  print(error.debugDescription)
                  completionFaliure(error)
              }
          }
      }
    

    //MARK: getUserEmergencyOrder
    static func getUserEmergencyOrder(order_id : Int,completionHandler:@escaping (Bool,String,OrderDetails?)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
             performSwiftyRequest(route: .userEmergencyOrder(order_id: order_id),headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
              let json = JSON(jsonData)
              print(json)
              DispatchQueue.main.async {
                  let sms  = json["message"].string ?? json["error"].stringValue
                  guard let status = json["status_code"].int , status == 200  else {
                      
                      completionHandler(false ,sms,nil)
                      return
                  }
                  let data = OrderDetails(json["order"])
                  print(data)
                  completionHandler(true,sms,data)
              }
          }) { (error) in
              DispatchQueue.main.async {
                  
                  print(error.debugDescription)
                  completionFaliure(error)
              }
          }
      }
        //MARK: getWorkerOrders
    static func getWorkerOrders(date : String,completionHandler:@escaping (Bool,[TeamOrderList]?, String?)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
        performSwiftyRequest(route: .getTeamOrders(date: date),headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
            let json = JSON(jsonData)
            print(json)
            DispatchQueue.main.async {
                var data : [TeamOrderList] = []
                let versionData : Setting_Data = Setting_Data(json["setting"])
                  
                for (_,jsn) in json["orders"] {
                    data.append(TeamOrderList(jsn))
                }
                //   let sms  = json["message"].string ?? json["error"].stringValue
                let status = data.count >= 0 ? true : false
                if !status {
                    completionHandler(status,nil,nil)
                    return
                }
                completionHandler(status,data,versionData.userAppIosVersion)
            }
        }) { (error) in
            DispatchQueue.main.async {
                print(error.debugDescription)
                completionFaliure(error)
            }
        }
    }
    
    //MARK: getWorkerOrders
static func getWorkerEmergencyOrders(completionHandler:@escaping (Bool,[TeamOrderList]?)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
    performSwiftyRequest(route: .getTeamEmergencyOrders,headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
        let json = JSON(jsonData)
        print(json)
        DispatchQueue.main.async {
            var data : [TeamOrderList] = []
            for (_,jsn) in json["orders"] {
                data.append(TeamOrderList(jsn))
            }
            //   let sms  = json["message"].string ?? json["error"].stringValue
            let status = data.count >= 0 ? true : false
            if !status {
                completionHandler(status,nil)
                return
            }
            completionHandler(status,data)
        }
    }) { (error) in
        DispatchQueue.main.async {
            print(error.debugDescription)
            completionFaliure(error)
        }
    }
}
    static func filterWorkerEmergencyOrders(date: String, completionHandler:@escaping (Bool,[TeamOrderList]?)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
        performSwiftyRequest(route: .filterTeamEmergencyOrders(date: date),headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
            let json = JSON(jsonData)
            print(json)
            DispatchQueue.main.async {
                var data : [TeamOrderList] = []
                for (_,jsn) in json["orders"] {
                    data.append(TeamOrderList(jsn))
                }
                //   let sms  = json["message"].string ?? json["error"].stringValue
                let status = data.count >= 0 ? true : false
                if !status {
                    completionHandler(status,nil)
                    return
                }
                completionHandler(status,data)
            }
        }) { (error) in
            DispatchQueue.main.async {
                print(error.debugDescription)
                completionFaliure(error)
            }
        }
    }
    //MARK: getTeamOrder
    static func getTOrder(order_id : Int,completionHandler:@escaping (Bool,String,TeamOrderDetailes?)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
             performSwiftyRequest(route: .teamOrder(order_id: order_id),headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
              let json = JSON(jsonData)
              print(json)
              DispatchQueue.main.async {
                  let sms  = json["message"].string ?? json["error"].stringValue
                  guard let status = json["status_code"].int , status == 200  else {
                      
                      completionHandler(false ,sms,nil)
                      return
                  }
                  let data = TeamOrderDetailes(json["order"])
                  print(data)
                  completionHandler(true,sms,data)
              }
          }) { (error) in
              DispatchQueue.main.async {
                  
                  print(error.debugDescription)
                  completionFaliure(error)
              }
          }
      }
    
    
    //MARK: getTeamOrder
    static func getToEmergancyOrder(order_id : Int,completionHandler:@escaping (Bool,String,TeamOrderDetailes?)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
             performSwiftyRequest(route: .teamEmergencyOrder(order_id: order_id),headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
              let json = JSON(jsonData)
              print(json)
              DispatchQueue.main.async {
                  let sms  = json["message"].string ?? json["error"].stringValue
                  guard let status = json["status_code"].int , status == 200  else {
                      
                      completionHandler(false ,sms,nil)
                      return
                  }
                  let data = TeamOrderDetailes(json["order"])
                  print(data)
                  completionHandler(true,sms,data)
              }
          }) { (error) in
              DispatchQueue.main.async {
                  
                  print(error.debugDescription)
                  completionFaliure(error)
              }
          }
      }
    
    //MARK: Team Go Work
    
    static func goWork(order_id : Int , completionHandler:@escaping (Bool,String)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
            
            performSwiftyRequest(route: .teamGoWork(order_id: order_id) ,  headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
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
    
    
    
    //MARK: makePdf
    
    static func makePdf(order_id : Int , completionHandler:@escaping (Bool,String)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
            
        performSwiftyRequest(route: .makePdf(order_id: order_id) ,  headers: [:] ,  { (jsonData) in
                let json = JSON(jsonData)
                DispatchQueue.main.async {
                    if let pdfPath  = json["path"].string {
                        completionHandler(true, pdfPath)
                    }
                }
            }) { (error) in
                DispatchQueue.main.async {
                   
                    print(error.debugDescription)
                    completionFaliure(error)
                }
            }
        }
    static func showInvoice(order_id : Int , completionHandler:@escaping (Bool,OrderDetails?)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
            
        performSwiftyRequest(route: .showInvoice(order_id: order_id) ,  headers: [:] ,  { (jsonData) in
            let json = JSON(jsonData)
            print(json)
            DispatchQueue.main.async {
                guard let status = json["status_code"].int , status == 200  else {
                    completionHandler(false ,nil)
                    return
                }
                let data = OrderDetails(json["invoice"])
                print(data)
                completionHandler(true,data)
            }
        }) { (error) in
                DispatchQueue.main.async {
                   
                    print(error.debugDescription)
                    completionFaliure(error)
                }
            }
        }
    
    //MARK: Team Start Work
    
    static func startWork(order_id : Int , completionHandler:@escaping (Bool,String)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
            
            performSwiftyRequest(route: .teamStartWork(order_id: order_id),headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
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
    
    //MARK: Team End Work
    
    static func EndWork(order_id : Int , completionHandler:@escaping (Bool,String)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
            
            performSwiftyRequest(route: .teamEndWork(order_id: order_id),headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
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
    //MARK: Team Finish Work
    
    static func finishWork(order_id : Int,pay_by: String? , completionHandler:@escaping (Bool,String)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
            
        performSwiftyRequest(route: .teamfinishWork(order_id: order_id, pay_by: pay_by),headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
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
   
    //MARK: Team Go Work

    static func emergencyGoWork(order_id : Int , completionHandler:@escaping (Bool,String)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
            
            performSwiftyRequest(route: .teamEmergencyOrderGoWork(order_id: order_id) ,  headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
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
    
    //MARK: Team Start Work
    
    static func emergencyStartWork(order_id : Int , completionHandler:@escaping (Bool,String)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
            
            performSwiftyRequest(route: .teamEmergencyOrderStartWork(order_id: order_id),headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
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
    
    //MARK: Team End Work
    
    static func emergencyEndWork(order_id : Int , completionHandler:@escaping (Bool,String)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
            
            performSwiftyRequest(route: .teamEmergencyOrderEndWork(order_id: order_id),headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
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
    //MARK: Team Finish Work
    
    static func emergencyFinishWork(order_id : Int , completionHandler:@escaping (Bool,String)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
            
        performSwiftyRequest(route: .teamEmergencyOrderfinishWork(order_id: order_id),headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
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
   
    
    
    static func offers(service_id : Int , completionHandler:@escaping (Bool,[OfferData]?)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
            
        performSwiftyRequest(route: .offers(service_id: service_id),headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
                let json = JSON(jsonData)
                DispatchQueue.main.async {
                   
                    var data : [OfferData] = []
                    for (_,jsn) in json["offers"] {
                        data.append(OfferData(offer: OffersRoot(jsn), isSelected: false))
                    }
                   
                    print(data)
                    completionHandler(true,data)
                }
            }) { (error) in
                DispatchQueue.main.async {
                   
                    print(error.debugDescription)
                    completionFaliure(error)
                }
            }
        }
   
      //MARK: Team Add Price
      
    static func teamAddPrice(order_id : Int , price : [String] , price_desc : [String] , completionHandler:@escaping (Bool,String)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
              
              performSwiftyRequest(route: .teamAddPrice(order_id: order_id, price: price, price_desc: price_desc),headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
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
    
    
    static func requestUpdatePlayerID(playerID: String,user_type : String , completionHandler: @escaping (Bool, String?) -> (), failureHandler: @escaping (_ error: Error?) -> ()) {
        performSwiftyRequest(route: .setPlayerId(player_id: playerID, user_type: user_type),headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
            let json = JSON(jsonData)
            let sms  = json["message"].string ?? json["error"].stringValue
            guard let status = json["status_code"].int , status == 200  else {
                
                completionHandler(false ,sms)
                return
            }
            completionHandler(true, sms)
        }) { (error) in
            failureHandler(error)
        }
    }
    
    
    
    
    //MARK: teamInvoices
    static func teamInvoices(offset : Int , completionHandler:@escaping (Bool,[Orders]? , Int)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
        performSwiftyRequest(route: .teaminvoices(offset : offset),headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
                           let json = JSON(jsonData)
                           print(json)
                           DispatchQueue.main.async {
                             var data : [Orders] = []
                             for (_,jsn) in json["orders"] {
                                 data.append(Orders(jsn))
                             }
                            let total = json["count_data"].intValue
            //                let sms  = json["message"].string ?? json["error"].stringValue
                              let status = data.count >= 0 ? true : false
                             if !status {
                                 
                                 completionHandler(status,nil , 0)
                                 return
                             }
                          
                               completionHandler(status,data , total)
                         }

          }) { (error) in
              DispatchQueue.main.async {
                  
                  print(error.debugDescription)
                  completionFaliure(error)
              }
          }
      }
    
    
    
    //MARK: FilterOrders
    static func filterOrders(date_from : String , completionHandler:@escaping (Bool,[Orders]?)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
             performSwiftyRequest(route: .filterOrders(date_from: date_from),headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
                           let json = JSON(jsonData)
                           print(json)
                           DispatchQueue.main.async {
                             var data : [Orders] = []
                             for (_,jsn) in json["orders"] {
                                 data.append(Orders(jsn))
                             }
                     
            //                let sms  = json["message"].string ?? json["error"].stringValue
                              let status = data.count >= 0 ? true : false
                             if !status {
                                 
                                 completionHandler(status,nil)
                                 return
                             }
                          
                               completionHandler(status,data)
                         }

          }) { (error) in
              DispatchQueue.main.async {
                  
                  print(error.debugDescription)
                  completionFaliure(error)
              }
          }
      }
    
    
    
    
    //MARK: BuildingsNames
    static func getBuildingsNames( completionHandler:@escaping (BuildingRoot)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
        ad.isLoading()
             performSwiftyRequest(route: .user_buildings,headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
                           let json = JSON(jsonData)
//                           print(json)
                let data = BuildingRoot(fromJson: json)
                           DispatchQueue.main.async {
                            ad.killLoading()
                            guard data.statusCode == 200 else {
                                completionFaliure(nil)
                                return
                            }
                     completionHandler(data)
                }
          }) { (error) in
              DispatchQueue.main.async {
                  ad.killLoading()
                  print(error.debugDescription)
                  completionFaliure(error)
              }
          }
      }
    
    //MARK: getNotification
    static func getNotification(user_type : String , offset : Int, completionHandler:@escaping (Bool , Bool ,[NotiModel]? , [NotiModel]? , Int)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
        performSwiftyRequest(route: .notifications(user_type: user_type , offset : offset),headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
                            let json = JSON(jsonData)
                            print(json)
                            DispatchQueue.main.async {
                              let total = json["count_data"].intValue
                              var newNoti : [NotiModel] = []
                              var oldNoti : [NotiModel] = []
                              for (_,jsn) in json["notifications"] {
                                let seen : String = jsn["seen"].stringValue
                                if seen == "0"{
                                    newNoti.append(NotiModel(jsn))
                                }else{
                                    oldNoti.append(NotiModel(jsn))
                                }
                                  
                              }
                      
             //                let sms  = json["message"].string ?? json["error"].stringValue
                               let status1 = newNoti.count >= 0 ? true : false
                                let  status2 = oldNoti.count >= 0 ? true : false
                              if !status1 && !status2 {
                                  completionHandler(status1 , status2 , nil , nil , 0)
                                  return
                              }
                           
                               completionHandler(status1 , status2 , newNoti , oldNoti , total)
                          }

           }) { (error) in
               DispatchQueue.main.async {
                   
                   print(error.debugDescription)
                   completionFaliure(error)
               }
           }
       }
    
    
    //MARK: problem type
    
    static func problemType( completionHandler:@escaping (Bool,[ProblemTypes]?)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
            
        performSwiftyRequest(route: .problem_types,headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
            let json = JSON(jsonData)
            DispatchQueue.main.async {
                
                var data : [ProblemTypes] = []
                for (_,jsn) in json["types"] {
                    data.append(ProblemTypes(jsn))
                }
                
                
                let status = data.count >= 0 ? true : false
                if !status {
                    
                    completionHandler(status,nil)
                    return
                }
                
                completionHandler(status,data)
            }
        }) { (error) in
                DispatchQueue.main.async {
                   
                    print(error.debugDescription)
                    completionFaliure(error)
                }
            }
            
        }
    
    
    
    //MARK: common_questions
       
       static func commonQuestions( completionHandler:@escaping (Bool,[QuModel]?)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
               
        performSwiftyRequest(route: .common_questions ,headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
               let json = JSON(jsonData)
               DispatchQueue.main.async {
                   
                   var data : [QuModel] = []
                   for (_,jsn) in json["questions"] {
                       data.append(QuModel(jsn))
                   }
                   
                   
                   let status = data.count >= 0 ? true : false
                   if !status {
                       
                       completionHandler(status,nil)
                       return
                   }
                   
                   completionHandler(status,data)
               }
           }) { (error) in
                   DispatchQueue.main.async {
                      
                       print(error.debugDescription)
                       completionFaliure(error)
                   }
               }
               
           }
    
    
    //MARK: common_questions
         
    static func static_page( id : Int , completionHandler:@escaping (StaticPageModel?)->Void , completionFaliure:@escaping (_ error:Error?)->Void) {
                 
          performSwiftyRequest(route: .static_page(id: id) ,headers: ["lang":"\(Constants.current_Language)", "Authorization": "bearer \(Constants.user_token)"] ,  { (jsonData) in
                 let json = JSON(jsonData)
            DispatchQueue.main.async {
             //   let sms  = json["message"].string ?? json["error"].stringValue
//                guard let status = json["status_code"].int , status == 200  else {
//
//                    completionHandler(nil)
//                    return
//                }
                let data = StaticPageModel(json["page"])
                print(data)
                completionHandler(data)
            }
             }) { (error) in
                     DispatchQueue.main.async {
                        
                         print(error.debugDescription)
                         completionFaliure(error)
                     }
                 }
                 
             }
}


