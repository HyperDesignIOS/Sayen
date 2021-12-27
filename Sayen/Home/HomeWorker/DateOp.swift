//
//  DateOp.swift
//  Sayen  Worker
//
//  Created by Maher on 6/17/20.
//

import Foundation
class dateOp {
    
    var dateArr : [dateModel] = []
    
    let endDate   = "2025-01-01"
    var dateTo = Date()
    
    var mydayNum : [String] = []
    var mydayName : [String] = []
    var allDays : [String] = []
    var myMounthName : [String] = []
    
    init() {
        self.mydayNum = returnDayNum ()
        self.myMounthName = returnMounth()
    }
    
    func returnDayNum () -> [String]{
          let fmt2 = DateFormatter()
          fmt2.dateFormat = "yyy-MM-dd"
          var dateFrom = Date()
          dateTo = fmt2.date(from: endDate)!
          fmt2.locale = Locale(identifier: "ar")
          fmt2.dateFormat = "d"
          while dateFrom <= dateTo {
              mydayName.append(fmt2.string(from: dateFrom))
              dateFrom = Calendar.current.date(byAdding: .day, value: 1, to: dateFrom)!
              
          }
          return mydayName
      }
    
    func returnMounth() -> [String]{
        let fmt3 = DateFormatter()
        fmt3.dateFormat = "yyy-MM-dd"
        var dateFrom = Date()
        dateTo = fmt3.date(from: endDate)!
        fmt3.locale = Locale(identifier: "ar")
        fmt3.dateFormat = "MMMM"
        while dateFrom <= dateTo {
            myMounthName.append(fmt3.string(from: dateFrom))
            dateFrom = Calendar.current.date(byAdding: .day, value: 1, to: dateFrom)!
            
            
        }
        return myMounthName
        
    }
    
    func getdateinBackFormate(date12 : String)->String{
           let formatter = DateFormatter()
           formatter.locale = Locale(identifier: "ar")
           formatter.dateFormat = "EEEE, d, MMMM, yyyy"
          //"MM-dd-yyyy"
           let date = formatter.date(from: date12)!
           let fmt = DateFormatter()
           fmt.locale = Locale(identifier: "en")
           fmt.dateFormat = "dd-MM-yyyy"
           let outPut = fmt.string(from: date)
           return outPut
      }
    
    
    
    func AllDaysFunc () -> [String]{
           let fmt2 = DateFormatter()
           fmt2.dateFormat = "yyy-MM-dd"
           var dateFrom = Date()
           dateTo = fmt2.date(from: endDate)!
           fmt2.locale = Locale(identifier: "ar")
           fmt2.dateFormat = "EEEE, d, MMMM, yyyy"
           while dateFrom <= dateTo {
               allDays.append(fmt2.string(from: dateFrom))
               dateFrom = Calendar.current.date(byAdding: .day, value: 1, to: dateFrom)!
               
           }
           return allDays
       }
    
    
    
    func returnCurrntdateDay () ->String{
      
        let date = Date()

        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"

        formatter.locale = Locale(identifier: "en")
        
        let outputDate = formatter.string(from: date)

        return outputDate

       }
}

class dateModel {
    var dayNum : String?
    var Month : String?
    var year : String?
}
