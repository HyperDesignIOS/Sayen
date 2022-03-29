//
//  QuModel.swift
//  Sayen 
//
//  Created by Maher on 6/28/20.
//

import Foundation
import SwiftyJSON
//"id" : 2,
//  "question" : "هل يتم اضافه خصم  في حاله انشاء طلب باكثر من خدمة ؟",
//  "answer" : "الخصم يتم بالكوبون علي كل خدمه بمفردها ."


class QuModel {
    var question : String?
    var answer : String?
    var id : Int?
    
    
      init(_ jsonData : JSON) {
         
            self.question = jsonData["question"].stringValue
            self.id = jsonData["id"].intValue
            self.answer = jsonData["answer"].stringValue
    
        }
}

struct DateStr {
    var backendDate : String
    var dateName : String
    var dateNum : String
    var longFormate : String
    var month : String
    var hours : [String]
}
//class CheckDate {
//    var date : String?
//    var time : [CheckDateTime]?
//
//
//
//      init(_ jsonData : JSON) {
//            self.date = jsonData["date"].stringValue
//          self.time = jsonData["time"].arrayValue as? [CheckDateTime]
//        }
//}
//class CheckDateTime {
//    var time : String?
//      init(_ jsonData : JSON) {
//            self.time = jsonData["time"].stringValue
//        }
//}
