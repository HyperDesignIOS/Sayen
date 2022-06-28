//
//  ProfileData.swift
//  Sayen 
//
//  Created by Maher on 6/8/20.
//

import Foundation
import SwiftyJSON


class UserProfile_Data {
    
    private var _id : Int?
    private var _name  : String?
    private var _image  : String?
    private var _email  : String?
    private var _phone  : String?
    private var _client_type : String?
    private var _excellence_client : String?
    private var _active  : String?
    private var building_id_  : Int?
    private var flat_  : String?
    
    private var _lat  : String?
    private var _lng  : String?
    private var _address  : String?
    private var _floor  : String?
    
    
    
    
    var building_id : Int {
        return   building_id_ ?? 0
    }
    var flat : String {
        return   flat_ ?? ""
    }
    
    var id : Int {
        return   _id ?? 0
    }
    var client_type : String {
        guard let x = _client_type else { return ""}
        return x
    }
    var excellence_client : String {
        guard let x = _excellence_client else { return ""}
        return x
    }
    var active : String {
        guard let x = _active else { return ""}
        return x
    }
    var name : String {
        guard let x =    _name  else { return "" }
        return x
    }
    var imageLink : String {
        guard let x = _image else { return "" }
        return x
        
    }
    
    var email : String {
        guard let x =  _email else { return "" }
        return x
    }
    
    var phone : String {
        guard let x =  _phone else { return "" }
        return x
    }
    
    
    
    var lat : String {
        guard let x =    _lat  else { return "" }
        return x
    }
    var lng : String {
        guard let x = _lng else { return "" }
        return x
        
    }
    
    var address : String {
        guard let x =  _address else { return "" }
        return x
    }
    
    var floor : String {
        guard let x =  _floor else { return "" }
        return x
    }
    
    
    
    init(_ jsonData : JSON) {
        self._client_type = jsonData["client_type"].stringValue
        UserDefaults.standard.setValue(self._client_type, forKey: "client_type")
        self._excellence_client = jsonData["excellence_client"].stringValue
        self._id = jsonData["id"].intValue
        self._image = jsonData["image_path"].stringValue
        self._name = jsonData["name"].stringValue
        self._email = jsonData["email"].stringValue
        self._phone = jsonData["phone"].stringValue
        self._active = jsonData["active"].stringValue
        
        self.building_id_ = jsonData["building_id"].intValue
        self.flat_ = jsonData["flat"].stringValue
        
        self._lat = jsonData["lat"].stringValue
        self._lng = jsonData["lng"].stringValue
        self._address = jsonData["address"].stringValue
        self._floor = jsonData["floor"].stringValue
        
    }
    
    
}


class Setting_Data {
    private var _userAppIosVersion  : String?
    var userAppIosVersion : String {
        guard let x =  _userAppIosVersion else { return "" }
        return x
    }
    
    private var _textEmergency  : String?
    var textEmergency : String {
        guard let x =  _textEmergency else { return "" }
        return x
    }

    init(_ jsonData : JSON) {
        self._userAppIosVersion = jsonData["user_app_ios_version"].stringValue
        self._textEmergency = jsonData["text_emergency"].stringValue
    }
    
    
}
//"setting": {
//      "user_app_android_version": "1.0.30",
//      "user_app_ios_version": "1.8"
//  }
