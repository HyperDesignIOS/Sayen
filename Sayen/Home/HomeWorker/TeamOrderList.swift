//
//  TeamOrderList.swift
//  Sayen 
//
//  Created by Maher on 6/18/20.
//

import Foundation

import SwiftyJSON
//"orders" : [
//  {
//    "user_phone" : "966566661234",
//    "title" : "خدمة صيانة السباكة",
//    "lng" : "31.003545038402084",
//    "time" : "10:23 صباحا",
//    "lat" : "30.782114479218585",
//    "id" : 83
//  }
//]


class TeamOrderList {
    var user_phone : String?
    var title : String?
    var lng  : String?
    var lat : String?
    var time : String?
    var id : Int?
    var date : String?
    
     init(_ jsonData : JSON) {
           
              self.user_phone = jsonData["user_phone"].stringValue
              self.id = jsonData["id"].intValue
              self.title = jsonData["title"].stringValue
              self.lng = jsonData["lng"].stringValue
              self.lat = jsonData["lat"].stringValue
              self.time = jsonData["time"].stringValue
              self.date = jsonData["date"].stringValue
          }
    
    
      
}



