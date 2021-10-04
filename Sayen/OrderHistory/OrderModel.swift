//
//  OrderModel.swift
//  Sayen 
//
//  Created by Maher on 6/14/20.
//

import Foundation
import SwiftyJSON


//"orders" : [
//{
//  "order_number" : "9615",
//  "date" : "14 يونيو, فترة مسائية",
//  "order_status" : "1",
//  "id" : 87,
//  "title" : "خدمة صيانة الكهرباء"
//}
class Orders {
    private var _order_number : String?
    private var _date : String?
    private var _order_status : String?
    private var _id : Int?
    private var _title : String?
    
    
    var order_number : String {
        guard let x = self._order_number else {return ""}
        return x
    }
    var date : String {
        guard let x = self._date else {return ""}
        return x
    }
    var order_status : String {
           guard let x = self._order_status else {return ""}
           return x
       }
    
    var title : String {
              guard let x = self._title else {return ""}
              return x
          }
    var id : Int {
                 guard let x = self._id else {return 0}
                 return x
             }
    
    init(_ jsonData : JSON) {
        
           self._order_number = jsonData["order_number"].stringValue
           self._id = jsonData["id"].intValue
           self._date = jsonData["date"].stringValue
           self._order_status = jsonData["order_status"].stringValue
           self._title = jsonData["title"].stringValue
 
       }
    
}
