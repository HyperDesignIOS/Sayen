//
//  APIRoute.swift
//  Eyas
//
//  Created by emad ios on 12/12/18.
//  Copyright © 2018 emad ios. All rights reserved.
//

import Alamofire

enum APIRouter: URLRequestConvertible {
    //user/order?order_type=current&limit={limit}&offset={offset}
    //user/order/{order_id}
    case login(phone : String , password : String , country_code : String)
    case register(name: String, lastName: String, email: String, mobile : String ,password:String,country_code:String,excellence_client:Int,building_id:Int,flat:String)
    case registerTeam(name:String,mobile : String ,email:String,password:String,country_code:String)

    case verifyCode(phone : String ,country_code : String, code : String ,code_type : String ,user_type : String)
    case forgotPass(mobile:String,country_code:String , user_type: String)
    case resendCode(phone : String ,country_code : String,code_type : String ,user_type : String)
    case resetPass(password : String , user_type : String)
    case changePassword(password : String , user_type : String , old_password : String)
    case createOTP(id: Int)
    case changePhone(phone : String , country_code : String , user_type : String)
    case update_profile(name : String ,lastName : String , excellence_client : String , email : String,building_id:String,flat:String)
    case update_profileT(name : String , email : String)
    case get_profile(user_type : String)
    case logout(user_type : String)
    case service
    case subService(serviceId : Int)
    case emergencyOrder(noteStr : String, serviceId: Int)
    case currentOrder(offset : Int)
    case previousOrder(offset : Int)
    case currentِEmergencyOrder(offset : Int, lang: String)
    case previousِEmergencyOrder(offset : Int, lang: String)
    case userOrder(order_id : Int)
    case userEmergencyOrder(order_id : Int)
    case teamOrder(order_id : Int)
    case cancel_order(order_id : Int)
    case requestWarranty(order_id : Int)
    case getTeamOrders(date : String)
    case getTeamEmergencyOrders
    case filterTeamEmergencyOrders(date : String)
    case teamEmergencyOrder(order_id : Int)
    case checkTimeDate(date : String, serviceId: Int)
    case checkDate(serviceId: Int)
    case teamStartWork(order_id : Int)
    case teamGoWork(order_id : Int)
    case teamEndWork(order_id : Int)
    case teamfinishWork(order_id : Int,pay_by:String?)
    case teamEmergencyOrderStartWork(order_id : Int)
    case teamEmergencyOrderGoWork(order_id : Int)
    case teamEmergencyOrderEndWork(order_id : Int)
    case teamEmergencyOrderfinishWork(order_id : Int)
    case teamAddService(orderId : Int, service: String)
    case teamEmergencyOrderAddService(orderId : Int, service: String)
    case teamAddMaterial(orderId : Int, material: String)
    case teamEmergencyOrderAddMaterial(orderId : Int, material: String)
    case teamAddPrice (order_id : Int , price : [String] , price_desc : [String] )
    case setPlayerId (player_id : String , user_type : String)
    case validateCoupon(code : String , total_price : String , service_id : Int)
    case userAcceptPrice(order_id : Int , status : String )
    case rateWorker(order_id : Int  , rate_service_value : Int ,rate_team_value : Int ,rate_service_comment : String ,rate_team_comment : String ,type: String)
    case teamreportProblem( order_id : Int  , problem_type : Int)
    case teaminvoices(offset : Int)
    case filterOrders(date_from : String)
    case notifications ( user_type : String , offset : Int)
    case notification_seen (user_type : String , notification_id : Int)
    case problem_types
    case common_questions
    case static_page(id : Int)
    case userSendMessage(name : String , message : String)
  case user_buildings
    case updateLocation(lat:Double,lng:Double)
    case moyaserSuccessPay(orderId : Int ,id : String , status : String)
    case offers(service_id : Int)
    case makePdf(order_id : Int)
    case showInvoice(order_id : Int)
    //v1/common-questions
  
    //v1/static-page/{id}
    
    //team/invoices?offset={offset}&limit={limit}
     // MARK: - HTTPMethod
     var method: HTTPMethod {
        switch self {
        case .login , .register  ,.createOTP  , .verifyCode , .forgotPass ,.resendCode , .changePhone ,.logout ,.cancel_order , .requestWarranty ,.validateCoupon ,.userAcceptPrice ,.rateWorker , .teamreportProblem , .userSendMessage , .registerTeam , .subService , .emergencyOrder , .checkTimeDate, .checkDate, .teamAddService , .teamEmergencyOrderAddService, .teamAddMaterial, .teamEmergencyOrderAddMaterial  :
            return .post
        case .changePassword, .resetPass , .update_profile , .update_profileT , .teamStartWork , .teamGoWork , .teamAddPrice , .setPlayerId ,.teamEndWork , .teamfinishWork , .notification_seen,.updateLocation, .teamEmergencyOrderStartWork, .teamEmergencyOrderGoWork, .teamEmergencyOrderEndWork, .teamEmergencyOrderfinishWork:
            return .put
        case .get_profile ,.service  , .currentOrder , .previousOrder , .userOrder , .userEmergencyOrder, .currentِEmergencyOrder , .previousِEmergencyOrder , .getTeamOrders , .teamOrder , .teaminvoices , .filterOrders , .notifications , .problem_types ,.common_questions , .static_page,.user_buildings , .moyaserSuccessPay  , .getTeamEmergencyOrders,  .teamEmergencyOrder   , .filterTeamEmergencyOrders , .offers , .makePdf, .showInvoice:
           return .get

        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .login : if ad.user_type() == "1" {return "user/login"}else{return "team/login"}
        case .register : return "user/register"
        case .verifyCode : return "verify-code"
        case .forgotPass : return "forget-password"
        case .resendCode : return "resend-code"
        case .changePassword : return "change-password"
        case .createOTP : return "user/createOTP"
        case .resetPass : return "change-password"
        case .changePhone : return "change-phone"
        case .update_profile: return "user/update-profile"
        case .checkTimeDate : return "user/checkTimeDate"
        case .checkDate : return "user/checkDate"
        case .update_profileT: return "team/update-profile"
        case .get_profile(let user_type): return "profile?user_type=\(user_type)"
        case .logout : return "logout"
        case .service : return "services"
        case .subService : return "subServices"
        case .emergencyOrder : return "user/emergency-order"
        case .currentOrder(let offset): return "user/order?order_type=current&limit=20&offset=\(offset)"
        case .previousOrder(let offset): return "user/order?order_type=previous&limit=20&offset=\(offset)"
        case .currentِEmergencyOrder(let offset, let lang): return "user/emergency-order?order_type=current&limit=10&offset=\(offset)&lang=\(lang)"
        case .previousِEmergencyOrder(let offset, let lang): return "user/emergency-order?order_type=previous&limit=20&offset=\(offset)&lang=\(lang)"
        case .userOrder(let order_id) : return "user/order/\(order_id)"
        case .userEmergencyOrder(let order_id) : return "user/emergency-order/\(order_id)"
        case .teamOrder(let order_id) : return "team/order/\(order_id)"
        case .cancel_order: return "user/cancel-order"
        case .requestWarranty: return "user/warranty-order"
        case .getTeamOrders(let date): return "team/order?date=\(date)&offset=0&limit=200"
        case .filterTeamEmergencyOrders(let date): return "team/emergency-order?limit=10&offset=0&date_from=\(date)&date_to=\(date)"
        case .getTeamEmergencyOrders: return "team/emergency-order?limit=200&offset=0"
        case .teamEmergencyOrder(let order_id) : return "team/emergency-order/\(order_id)"
        case .teamStartWork : return "team/start-work"
        case .teamGoWork : return "team/go-work"
        case .teamEndWork : return "team/end-work"
        case .teamfinishWork : return "team/finish-work"
        case .teamEmergencyOrderStartWork : return "team/emergency-order/start-work"
        case .teamEmergencyOrderGoWork : return "team/emergency-order/go-work"
        case .teamEmergencyOrderEndWork : return "team/emergency-order/end-work"
        case .teamEmergencyOrderfinishWork : return "team/emergency-order/finish-work"
        case .teamAddService : return "team/add-service"
        case .teamEmergencyOrderAddService :   return "team/emergency-order/add-service"
        case .teamAddMaterial : return "team/add-material"
        case .teamEmergencyOrderAddMaterial :   return "team/emergency-order/add-material"
            
        case .teamAddPrice : return "team/add-price"
        case .setPlayerId : return "set-player-id"
        case .validateCoupon : return "user/validate-coupon"
        case .userAcceptPrice : return "user/accept-added-price"
        case .rateWorker : return "user/rate-order"
        case .teamreportProblem : return "team/report-problem"
        case .teaminvoices(let offset) : return "team/invoices?offset=\(offset)&limit=20"
        case .filterOrders(let date_from ): return "team/invoices?offset=0&limit=100&date_from=\(date_from)"
        case .notifications(let user_type , let offset) : return "notifications?user_type=\(user_type)&offset=\(offset)&limit=200"
        case .notification_seen : return "notification-seen"
        case .problem_types : return "team/report-problem-types"
        case .common_questions : return "common-questions"
        case .static_page(let id) : return "static-page/\(id)"
        case .userSendMessage : return "user/send-message"
        case .user_buildings : return "user/buildings"
        case .updateLocation(let lat,let lng) : return "team/update-location?lat=\(lat)&lng=\(lng)"
        case .registerTeam : return "team/register"
        case .moyaserSuccessPay : return "user/success-pay"
        case .offers(let service_id): return "offers?service_id=\(service_id)"
        case .makePdf(let orderId): return "makePdf/\(orderId)"
        case .showInvoice(let orderId): return "show-invoice/\(orderId)"
         }
    }

    // MARK: - Parameters
     var parameters: Parameters? {
        switch self {
        case.login(let phone,let password ,let country_code):
            return ["phone":phone,"password":password , "country_code" : country_code]
        case .register(let name, let lastName, let email, let mobile, let password,let country_code, let excellence_client,let building_id , let flat ):
            return ["name" : name, "email" : email, "last_name" : lastName, "phone" : mobile , "password" : password , "country_code" : country_code , "excellence_client" : excellence_client , "building_id" : building_id , "flat":flat ]
        case .verifyCode(let phone,let country_code,let code,let code_type , let user_type):
            return ["phone": phone , "country_code" : country_code , "code" : code ,"code_type" : code_type ,"user_type" : user_type ]
        case .forgotPass(let mobile,let country_code, let user_type ):
            return ["phone":mobile , "country_code":country_code , "user_type" : user_type]
        case .resendCode(let phone,let country_code,let code_type , let user_type):
            return ["phone": phone , "country_code" : country_code ,"code_type" : code_type ,"user_type" : user_type ]
        case .resetPass(let password, let user_type ):
            return ["password":password , "user_type":user_type]
        case .changePassword(let password, let user_type , let old_password):
            return ["password":password , "user_type":user_type , "old_password" : old_password]
        case .createOTP(let id):
            return ["id":id ]            
        case .changePhone(let phone , let country_code , let user_type):
            return ["phone":phone,"country_code" : country_code ,"user_type" : user_type]
        case .update_profile(let name, let lastName, let excellence_client ,let email,let buildingID  ,let flat ):
            return ["name":name ,"last_name":lastName ,"excellence_client" : excellence_client , "email" : email, "building_id" : buildingID , "flat":flat ]
       case .update_profileT(let name,let email):
            return ["name":name , "email" : email]
        case .get_profile: return nil
        case .logout(let user_type):
            return ["user_type" : user_type]
        case .service: return nil
        case .subService(let serviceId):
            return ["service_id" : serviceId]
        case .emergencyOrder(let noteStr, let serviceId):
            return ["note" : noteStr , "service_id" : serviceId]
        case .checkTimeDate(let date, let serviceId):
            return ["date" : date , "service_id" : serviceId]
        case .checkDate(let serviceId):
            return ["service_id" : serviceId]
        case .teamAddService(let orderId, let service):
            return ["order_id" : orderId , "service" : service]
        case .teamEmergencyOrderAddService(let orderId, let service):
            return ["order_id" : orderId , "service" : service]
        case .teamAddMaterial(let orderId, let material):
            return ["order_id" : orderId , "material" : material]
        case .teamEmergencyOrderAddMaterial(let orderId, let material):
            return ["order_id" : orderId , "material" : material]
        case .currentOrder: return nil
        case .previousOrder: return nil
        case .currentِEmergencyOrder: return nil
        case .previousِEmergencyOrder: return nil
        case .userOrder : return nil
        case .userEmergencyOrder : return nil
        case .teamOrder : return nil
        case .static_page : return nil
        case .problem_types : return nil
        case .teaminvoices : return nil
        case .cancel_order(let order_id) : return ["order_id" : order_id]
        case .requestWarranty(let order_id) : return ["order_id" : order_id]
        case .getTeamOrders : return nil
        case .filterTeamEmergencyOrders : return nil
        case .teamStartWork(let order_id) :return ["order_id" : order_id]
        case .teamGoWork(let order_id) :return ["order_id" : order_id]
        case .teamEndWork(let order_id) :return ["order_id" : order_id]
        case .teamfinishWork(let order_id,let pay_by) :
            var dict : [String:Any] =  ["order_id" : order_id]
            if let pay = pay_by {
                dict["pay_by"] = pay
            }
            print(dict)
            return dict
        case .getTeamEmergencyOrders : return nil
        case .teamEmergencyOrder(let order_id) :return ["order_id" : order_id]
        case .teamEmergencyOrderStartWork(let order_id) :return ["order_id" : order_id]
        case .teamEmergencyOrderGoWork(let order_id) :return ["order_id" : order_id]
        case .teamEmergencyOrderEndWork(let order_id) :return ["order_id" : order_id]
        case .teamEmergencyOrderfinishWork(let order_id) :return ["order_id" : order_id]
        case .teamAddPrice(let order_id,let  price,let price_desc): return ["order_id" : order_id ,"price" : price , "price_desc" : price_desc]
        case .setPlayerId (let player_id, let user_type) : return ["player_id" : player_id , "user_type" : user_type]
        case .validateCoupon(let code , let total_price , let serviceid) : return ["code" : code , "total_price" : total_price , "service_id" : serviceid ]
        case .userAcceptPrice(let order_id, let status) : return ["order_id" : order_id , "status" : status]
        case .rateWorker(let order_id, let rate_service_value ,let rate_team_value , let rate_service_comment , let rate_team_comment, let type):
            return ["order_id" : order_id ,"rate_service_value" : rate_service_value , "rate_team_value" : rate_team_value , "rate_service_comment" : rate_service_comment , "rate_team_comment" : rate_team_comment, "type" : type ]
        case .teamreportProblem(let order_id,let problem_type) : return ["order_id" : order_id , "type_id" : problem_type]
        case .filterOrders: return nil
        case .notifications : return nil
        case .common_questions : return nil
        case .notification_seen(let user_type,let notification_id) : return ["user_type" : user_type , "notification_id" : notification_id]
        case .userSendMessage(let name ,let message) : return ["name" : name , "message" : message]
        case .user_buildings : return nil
        case .updateLocation  : return nil
            case .registerTeam(let name,let mobile,let email, let password,let country_code ):
                return ["name":name,"phone": mobile , "email":email, "password" : password , "country_code" : country_code  ]
        case .moyaserSuccessPay(let orderId,let id, let status) : return ["order_id" : orderId , "id" : id , "status" : status]
        case .offers : return nil
        case .makePdf : return nil
        case .showInvoice : return nil
     }
    }
    
   
    var requestURL: URL? {
        var main_api_url = ""
        
        main_api_url = Constants.ProductionServer.baseURL_V2 + path
//        if path == "user/buildings"  ||  path == "team/finish-work" || path == "team/register" {
//            main_api_url = Constants.ProductionServer.baseURL_V2 + path
//        }
        guard let mainUrl = URLComponents(string: main_api_url) else {
            return  URL(string: Constants.ProductionServer.baseURL)
            
        }
        let urlComponents = mainUrl
        let url = urlComponents.url
        
        return url
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        var main_api_url = ""
        
        main_api_url = Constants.ProductionServer.baseURL_V2 + path
//        if path == "user/buildings"  ||  path == "team/finish-work" || path == "team/register" {
//            main_api_url = Constants.ProductionServer.baseURL_V2 + path
//        }
        guard let mainUrl = URLComponents(string: main_api_url) else {
            return URLRequest(url: URL(string: Constants.ProductionServer.baseURL)!)
            
        }
        let urlComponents = mainUrl
        let url = urlComponents.url!
        var urlRequest = URLRequest(url: url)
        print("URLS REQUEST :\(urlRequest)")
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HTTPHeaderField.contentType.rawValue)
     
        print(urlRequest.allHTTPHeaderFields)
        // Parameters
        if let parameters = parameters {
            do {
                print(parameters)
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest as URLRequest
    }
}





//func asURLRequest() throws -> URLRequest {
//    var main_api_url = ""
//
//    main_api_url = Constants.ProductionServer.baseURL_V2 + path
////        if path == "user/buildings"  ||  path == "team/finish-work" || path == "team/register" {
////            main_api_url = Constants.ProductionServer.baseURL_V2 + path
////        }
//    guard let mainUrl = URLComponents(string: main_api_url) else {
//        return URLRequest(url: URL(string: Constants.ProductionServer.baseURL)!)
//
//    }
//    let urlComponents = mainUrl
//    let url = urlComponents.url!
//    var urlRequest = URLRequest(url: url)
//    print("URLS REQUEST :\(urlRequest)")
//    // HTTP Method
//    urlRequest.httpMethod = method.rawValue
//    urlRequest.setValue(Constants.ContentType.json.rawValue, forHTTPHeaderField: Constants.HTTPHeaderField.contentType.rawValue)
// //   urlRequest.setValue("8cSpF5mN", forHTTPHeaderField: "X-ApiKey")
//    if Constants.token2 != "" {
//        switch self {
//        case .changePassword:
//             urlRequest.setValue("Bearer \(Constants.token2)", forHTTPHeaderField: Constants.HTTPHeaderField.authentication.rawValue)
//        default:
//            print("ok")
//        }
//
//    }
//
//    if Constants.user_token != "" {
//        Constants.token2 = ""
//        print("didSetToken:\(Constants.user_token)")
//        //            urlRequest.setValue("bearer \(Constants.user_token)", forHTTPHeaderField: Constants.HTTPHeaderField.authentication.rawValue)
//            urlRequest.setValue("Bearer \(Constants.user_token)", forHTTPHeaderField: Constants.HTTPHeaderField.authentication.rawValue)
//    }
//    //        urlRequest.setValue(headers, forHTTPHeaderField: Constants.HTTPHeaderField.authentication.rawValue)
//    //        urlRequest.setValue("ar", forHTTPHeaderField: Constants.HTTPHeaderField.Language.rawValue)
//    print(urlRequest.allHTTPHeaderFields)
//    // Parameters
//    if let parameters = parameters {
//        do {
//            print(parameters)
//            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
//        } catch {
//            throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
//        }
//    }
//
//    return urlRequest as URLRequest
//}
