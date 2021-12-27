//
//  OrderDetails.swift
//  Sayen 
//
//  Created by Maher on 6/14/20.
//

import Foundation
import UIKit
import SwiftyJSON
//
//"order" : {
//    "pay_method" : "1",
//    "id" : 88,
//    "coupon_discount" : 0,
//    "team_added_price" : 0,
//    "notes" : "هلا",
//    "order_status" : "1",
//    "initial_price" : 70,
//    "pay_status" : "0",
//    "team_name" : "",
//    "team_added_price_desc" : null,
//    "images" : [
//      "https:\/\/sayen.cems-it.com\/public\/uploads\/orders\/726634236.jpeg"
//    ],
//    "team_phone" : "",
//    "title" : "خدمة صيانة نظافة وتعقيم",
//    "final_price" : 70,
//    "date" : "20 يونيو, فترة مسائية",
//    "order_number" : "7491",
//    "team_image" : ""
//  }
//}

//
//{

class OrderDetails {
    var id : Int?
    var pay_method : String?
    var coupon_discount : Double?
    var team_added_price : [String] = []
    var notes : String?
    var order_status : String?
    var orderIsFinished: Bool {
         guard let status = Int(order_status ?? "") , status >= 3 else { return false }
        return true
    }
    var initial_price : Double?
    var pay_status : String?
    var team_name : String?
    var team_added_price_desc : [String] = []
    
    var images : [String] = []
    var team_phone : String?
    var title : String?
    var final_price : Double?
    var date : String?
    var order_number : String?
    var team_image : String?
    var probImages : [UIImageView] = []
    var imgSenf : UIImageView = UIImageView()
    var total_before_discount : Double?
    var service_rated : Int?
    var user_accept_added_price : String?
    var total_before_team_add_price : String?
    var pay_by : String?

    var excellence_client : String
       var isExcellenceClient : Bool {
          return excellence_client == "1"
      }
    
    init(_ jsonData : JSON) {

        self.pay_by = jsonData["pay_by"].stringValue

        self.excellence_client = jsonData["excellence_client"].stringValue

        self.id = jsonData["id"].intValue
        self.service_rated = jsonData["service_rated"].intValue
        self.pay_method = jsonData["pay_method"].stringValue
        self.coupon_discount = jsonData["coupon_discount"].doubleValue
        //  self.team_added_price = jsonData["team_added_price"].arrayValue
        for x in jsonData["team_added_price"].arrayValue {
            let str = x.stringValue
            self.team_added_price.append(str)
        }
        
        self.notes = jsonData["notes"].stringValue
        self.order_status = jsonData["order_status"].stringValue
        self.initial_price = jsonData["initial_price"].doubleValue
        self.total_before_discount = jsonData["total_before_discount"].doubleValue
        self.pay_status = jsonData["pay_status"].stringValue
        self.team_name = jsonData["team_name"].stringValue
        self.total_before_team_add_price = jsonData["total_before_team_add_price"].stringValue
        self.user_accept_added_price = jsonData["user_accept_added_price"].stringValue
        //    self.team_added_price_desc = jsonData["team_added_price_desc"].arrayValue
        
        for x in jsonData["team_added_price_desc"].arrayValue {
            let str = x.stringValue
            self.team_added_price_desc.append(str)
        }
        
        self.team_phone = jsonData["team_phone"].stringValue
        self.title = jsonData["title"].stringValue
        self.date = jsonData["date"].stringValue
        self.final_price = jsonData["final_price"].doubleValue
        self.order_number = jsonData["order_number"].stringValue
        self.team_image = jsonData["team_image"].stringValue
        for imageString in jsonData["images"].arrayValue{
            let str = imageString.stringValue
            self.images.append(str)
        }
        
    }
    
    
    func setImages () -> [UIImageView] {
        for (i,img) in images.enumerated() {
            if let url = URL(string: img) {
                let placeholderImage = UIImage(named: "imageProfile")!
              //  self.probImages.append(img.af_setImage(withURL: url, placeholderImage: placeholderImage))
               
                    self.imgSenf.af_setImage(withURL: url, placeholderImage: placeholderImage)
              
                      self.probImages.append(imgSenf)
         
                  
                    
           
          
               
            }
        }
        print(self.probImages.count)
        return self.probImages
    }
    
}



class TeamOrderDetailes {
    
    
    //  "order" : {
    //    "team_added_price_desc" : null,
    //    "title" : "خدمة صيانة السباكة",
    //    "pay_method" : "1",
    //    "images" : [
    //      "https:\/\/sayen.cems-it.com\/public\/uploads\/orders\/136348929.jpeg"
    //    ],
    //    "user_image" : "https:\/\/sayen.cems-it.com\/public\/uploads\/users\/1591629490.jpg",
    //    "order_number" : "7750",
    //    "lng" : "31.003545038402084",
    //    "final_price" : 20,
    //    "notes" : "ويويو",
    //    "pay_status" : "0",
    //    "coupon_discount" : 0,
    //    "user_name" : "العم زاهر صياد ماهر",
    //    "lat" : "30.782114479218585",
    //    "user_phone" : "966566661234",
    //    "team_added_price" : 0,
    //    "order_status" : "5",
    //    "id" : 83,
    //    "date" : "18 يونيو, فترة صباحية",
    //    "initial_price" : 20
    //  },
    //  "status_code" : 200
    //}
    
    
    
    var id : Int?
    var pay_method : String?
    var coupon_discount : Int?
    var team_added_price : [String] = []
    var notes : String?
    var order_status : String?
    var orderIsFinished: Bool {
        guard let status = Int(order_status ?? "") , status >= 3 else { return false }
        return true
    }
    var floor : Int?
    var address : String?
    var initial_price : Double?
    var pay_status : String?
    var user_name : String?
    var team_added_price_desc : [String] = []
    var images : [String] = []
    var user_phone : String?
    var title : String?
    var final_price : Double?
    var date : String?
    var order_number : String?
    var user_image : String?
    var probImages : [UIImageView] = []
    var imgSenf : UIImageView = UIImageView()
    var lng : String?
    var lat : String?
    var user_accept_added_price : String?
    var total_before_discount : Double?
    var excellence_client : String
    var pay_by : String
    var isExcellenceClient : Bool {
        return excellence_client == "1"
    }
    
    
    
  
    init(_ jsonData : JSON) {
        print(jsonData)
        self.pay_by = jsonData["pay_by"].stringValue
        self.excellence_client = jsonData["excellence_client"].stringValue
        self.user_accept_added_price = jsonData["user_accept_added_price"].stringValue
        self.id = jsonData["id"].intValue
        self.pay_method = jsonData["pay_method"].stringValue
        self.floor = jsonData["floor"].intValue
        self.address = jsonData["address"].stringValue
        self.coupon_discount = jsonData["coupon_discount"].intValue
        for x in jsonData["team_added_price"].arrayValue {
            let str = x.stringValue
            self.team_added_price.append(str)
        }
        self.notes = jsonData["notes"].stringValue
        self.order_status = jsonData["order_status"].stringValue
        self.initial_price = jsonData["initial_price"].doubleValue
        self.pay_status = jsonData["pay_status"].stringValue
        self.user_name = jsonData["user_name"].stringValue
        for x in jsonData["team_added_price_desc"].arrayValue {
            let str = x.stringValue
            self.team_added_price_desc.append(str)
        }
        self.user_phone = jsonData["user_phone"].stringValue
        self.title = jsonData["title"].stringValue
        self.date = jsonData["date"].stringValue
        self.final_price = jsonData["final_price"].doubleValue
        self.order_number = jsonData["order_number"].stringValue
        self.user_image = jsonData["user_image"].stringValue
        self.lat = jsonData["lat"].stringValue
        self.lng = jsonData["lng"].stringValue
        self.total_before_discount = jsonData["total_before_discount"].doubleValue
        for imageString in jsonData["images"].arrayValue{
            let str = imageString.stringValue
            self.images.append(str)
        }
        
    }
    
    
    func setImages () -> [UIImageView] {
        for (i,img) in images.enumerated() {
            if let url = URL(string: img) {
                let placeholderImage = UIImage(named: "imageProfile")!
                //  self.probImages.append(img.af_setImage(withURL: url, placeholderImage: placeholderImage))
                
                self.imgSenf.af_setImage(withURL: url, placeholderImage: placeholderImage)
                
                self.probImages.append(imgSenf)
                
                
                
                
                
                
            }
        }
        print(self.probImages.count)
        return self.probImages
    }
    
}
