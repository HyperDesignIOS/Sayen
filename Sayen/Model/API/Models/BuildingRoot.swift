//
//    RootClass.swift
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import SwiftyJSON

class BuildingRoot{

    private var buildings_ : [BuildingM]!
        var buildings : [BuildingM] { return buildings_}
        
    private var statusCode_ : Int!
        var statusCode : Int { return statusCode_}
        

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        buildings_ = [BuildingM]()
        let buildings_Array = json["buildings"].arrayValue
        for buildings_Json in buildings_Array{
            let value = BuildingM(fromJson: buildings_Json)
            buildings_.append(value)
        }
        statusCode_ = json["status_code"].intValue
    }

}

class BuildingM{


    private var id_ : Int!
        var id : Int { return id_}
        
    private var name_ : String!
        var name : String { return name_}
        
    private var units_ : [String]!
        var units : [String] { return units_}
        
    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        
        units_ = []
        let units = json["units"].arrayValue
        for unit in units{
            let value = unit.stringValue
            units_.append(value)
//            buildings_.append(value)
        }
        id_ = json["id"].intValue
        name_ = json["name"].stringValue
    }

}
