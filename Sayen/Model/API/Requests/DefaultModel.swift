//
//  DefaultModel.swift
//  Takaful
//
//  Created by Eslam Abo El Fetouh on 4/26/20.
//  Copyright © 2020 Eslam Abo El Fetouh. All rights reserved.
//

import Foundation
import SwiftyJSON

class DefaultModel{


 
    private var statusCode_ : Int!
        var statusCode : Int { return statusCode_}
        
    private var message_ : String!
        var message : String { return message_}

    var success : Bool {
        
        return statusCode == 200
    }
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON){
 
        statusCode_ = json["status_code"].intValue
        message_ = json["message"].string ??  json["error"].stringValue
        
    }

}
