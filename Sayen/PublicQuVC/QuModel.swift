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
