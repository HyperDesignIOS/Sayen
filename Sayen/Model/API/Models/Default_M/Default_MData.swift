//
//	Default_MData.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON



protocol BaseCellModel {
    
    var id : Int    { get }
    var image : String  { get }
    var title : String { get }
}
class Default_MData : BaseCellModel {


	private var id_ : Int!
		var id : Int { return id_}
		
	private var image_ : String!
		var image : String { return image_}
		
	private var title_ : String!
		var title : String { return title_}
		
	private var uRL_ : String!
		var uRL : String { return uRL_}
		

	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		 
		id_ = json["Id"].intValue
		image_ = json["Image"].stringValue
		title_ = json["Title"].stringValue
		uRL_ = json["URL"].stringValue
	}

}
