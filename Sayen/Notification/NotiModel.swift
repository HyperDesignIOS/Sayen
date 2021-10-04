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
