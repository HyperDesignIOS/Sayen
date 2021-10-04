//
//  String+Date.swift
//  Theme
//
//  Created by Eslam Abo El Fetouh on 4/1/20.
//  Copyright © 2020 Eslam Abo El Fetouh. All rights reserved.
//

import Foundation


extension String {
     
    func getPriceValue()->String {
        
        guard  let initP = Double(self)  else { return self }
 let isInt = floor(initP) == initP
 return  isInt ? "\(Int(initP))" : "\(initP)"

         
        
    }
    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: self) // replace Date String
    }
 
    
    
    func getStringFromGlobal() -> String {
    var date_st = self

     if let index = date_st.range(of: ".")?.lowerBound {
        let substring = date_st[..<index]                 // "ora"
        // or  let substring = word.prefix(upTo: index) // "ora"
        // (see picture below) Using the prefix(upTo:) method is equivalent to using a partial half-open range as the collection’s subscript.
        // The subscript notation is preferred over prefix(upTo:).

        date_st = String(substring)
     }


    print(date_st)
         let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"//this your string date format
    dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        dateFormatter.locale = Locale(identifier: "your_loc_id")
        let convertedDate = dateFormatter.date(from: date_st)

        guard dateFormatter.date(from: date_st) != nil else {
            assert(false, "no date from string")
            
            return ""
        }

        dateFormatter.dateFormat = "dd-MMM YYYY hh:mm aa"///this is what you want to convert format
   
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let timeStamp = dateFormatter.string(from: convertedDate!)

    print(timeStamp)
        return timeStamp
}
    
}



