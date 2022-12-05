//
//  HomeData.swift
//  Sayen 
//
//  Created by Maher on 6/13/20.
//

import Foundation
import SwiftyJSON
//"image_path" : "https:\/\/sayen.cems-it.com\/public\/uploads\/services\/1591789302.png",
// "initial_price" : 20,
// "active" : "1",
// "id" : 1,
// "name" : "السباكة"


class HomeData {
    private var _image_path : String?
    private var _initial_price : Double?
    private var _active : String?
    private  var _id : Int?
    private var _name : String?
    private var _text : String?
    private  var _checkSub : Int?
    private  var _offer : Int?
    private  var _numbers : Int?
    private  var _device_number : Int?
    
    
    
    
    var id : Int {
        return   _id ?? 0
    }
    
    var offer : Int {
        return   _offer ?? 0
    }
    
    var name : String {
        guard let x =    _name  else { return "" }
        return x
    }
    var image_path : String {
        guard let x = _image_path else { return "" }
        return x
    }
    var active : String {
        guard let x = _active else { return "" }
        return x
        
    }
    var initial_price_Double : Double {
        guard let x =  _initial_price else { return 0.0 }
        
        return x
    }
    
    var initial_price : String {
        guard let x =  _initial_price else { return "0.0" }
        guard    floor(x) == x else {
            return "\(x)"
        }
        return "\(Int(x))"
    }
    
    
    var checkSub : Int {
        return   _checkSub ?? 0
    }
    
    
    var text : String {
        guard let x =    _text  else { return "" }
        return x
    }
    
    var numbers : Int {
        return   _numbers ?? 0
    }
    
    var deviceNumber : Int {
        return   _device_number ?? 0
    }
    
    init(_ jsonData : JSON) {
        
        self._image_path = jsonData["image_path"].stringValue
        self._id = jsonData["id"].intValue
        self._name = jsonData["name"].stringValue
        self._active = jsonData["active"].stringValue
        self._initial_price = jsonData["initial_price"].doubleValue
        self._checkSub = jsonData["checkSub"].intValue
        self._text = jsonData["text"].stringValue
        self._offer = jsonData["offer"].intValue
        self._numbers = jsonData["numbers"].intValue
        self._device_number = jsonData["device_number"].intValue
    }
    
    
    
}
