//
//  NotiModel.swift
//  Sayen 
//
//  Created by Maher on 6/24/20.
//

import Foundation
import SwiftyJSON
class NotiModel {
    
    var user_id : Int?
    var seen : String?
    var user_type : String?
    var created_at : String?
    var id : Int?
    var image_path : String?
    var order_id : Int?
    var message : String?
   
    
    init(_ jsonData : JSON) {
        
        self.user_id = jsonData["user_id"].intValue
        self.id = jsonData["id"].intValue
        self.seen = jsonData["seen"].stringValue
        self.user_type = jsonData["user_type"].stringValue
        self.created_at = jsonData["created_at"].stringValue
        self.image_path = jsonData["image_path"].stringValue
        self.order_id = jsonData["order_id"].intValue
        self.message = jsonData["message"].stringValue
    }
    
    
}


class OffersRoot {
    var id : Int?
    var title : String?
    var title_en : String?
    var price : Float?
    var service_id : Int?
    var from : Int?
    var to : Int?
    var image_path : String?
    
    
    init(_ jsonData : JSON) {
        self.id = jsonData["id"].intValue
        self.title = jsonData["title"].stringValue
        self.title_en = jsonData["title_en"].stringValue
        self.price = jsonData["price"].floatValue
        self.service_id = jsonData["service_id"].intValue
        self.from = jsonData["from"].intValue
        self.to = jsonData["to"].intValue
        self.image_path = jsonData["image_path"].stringValue
    }
    
    
}

struct OfferData {
    var offer: OffersRoot
    var isSelected: Bool
    
}
struct OfferService {
    var offer: OffersRoot
    var service: HomeData
    
}



class EmReasons {
    var id : Int?
    var reason : String?
    var reason_en : String?
    var service_id : Int?
    var status : Int?
    var deleted_at : String?
    
    
    init(_ jsonData : JSON) {
        self.id = jsonData["id"].intValue
        self.reason = jsonData["reason"].stringValue
        self.reason_en = jsonData["reason_en"].stringValue
        self.service_id = jsonData["service_id"].intValue
        self.status = jsonData["status"].intValue
        self.deleted_at = jsonData["deleted_at"].stringValue
    
    }
    
    
}

//struct OfferData {
//    var offer: OffersRoot
//    var isSelected: Bool
//
//}
struct EmService {
    var id: Int
    var title: String
    var reasons: [EmReasons]
    
    init(_ jsonData : JSON) {
        self.id = jsonData["id"].intValue
        self.title = jsonData["title"].stringValue
        self.reasons = [EmReasons]()
        let reason_Array = jsonData["reasons"].arrayValue
        for resons_Json in reason_Array{
            let value = EmReasons(resons_Json)
            reasons.append(value)
        }
    }
    
}


//"id": 1,
//"title": "عرض المميز",
//"title_en": "offer",
//"price": 50,
//"service_id": 26,
//"image_path": "https://sayen.co/public/img/default_offer.png"
//
//
//

//"notifications" : [
//{
//  "user_id" : 38,
//  "seen" : "0",
//  "user_type" : "1",
//  "created_at" : "2020-06-22 18:00:26",
//  "id" : 503,
//  "image_path" : "https:\/\/sayen.cems-it.com\/public\/img\/default_service.png",
//  "order_id" : 179,
//  "message" : "موعدك للصيانة تبقى عليه أقل من ساعة"
//},
