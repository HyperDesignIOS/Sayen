//
//	Default_MDefault_Root_M.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class Default_Root_M {


	private var data_ : [Default_MData]!
		var data : [Default_MData] { return data_}
		
	private var errorMessage_ : String!
		var errorMessage : String { return errorMessage_}
		
	private var success_ : Bool!
		var success : Bool { return success_}
		

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		
		data_ = [Default_MData]()
		let data_Array = json["Data"].arrayValue
		for data_Json in data_Array{
			let value = Default_MData(fromJson: data_Json)
			data_.append(value)
		}
        errorMessage_ = json["ErrorMessage"].string ??  json["Message"].stringValue
		success_ = json["Success"].boolValue
	}

}
