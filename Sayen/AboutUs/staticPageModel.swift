//
//  staticPageModel.swift
//  Sayen 
//
//  Created by Maher on 6/28/20.
//

import Foundation
import SwiftyJSON
class StaticPageModel {
//    "page" : {
//      "content" : "محتوى عنا تعديل",
//      "id" : 1,
//      "telegram" : null,
//      "twitter" : null,
//      "whatsapp" : null,
//      "instagram" : null,
//      "facebook" : null,
//      "title" : "عنا التطبيق"
//    }
    
    
    var content : String?
    var id : Int?
    var telegram : String?
    var twitter : String?
    var whatsapp : String?
    var instagram : String?
    var facebook : String?
    var title : String?
    
    
    init(_ json : JSON) {
        self.content = json["content"].stringValue
        self.telegram = json["telegram"].stringValue
        self.twitter = json["twitter"].stringValue
        self.whatsapp = json["whatsapp"].stringValue
        self.facebook = json["facebook"].stringValue
        self.title = json["title"].stringValue
        self.instagram = json["instagram"].stringValue
        self.id = json["id"].intValue
    }
    
}
