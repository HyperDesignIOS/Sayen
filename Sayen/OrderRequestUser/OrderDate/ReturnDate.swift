//
//  ReturnDate.swift
//  Sayen 
//
//  Created by Maher on 6/11/20.
//

import UIKit
class ReturnDate {
    
    
    
    var mydayNum : [String] = []
    var mydayName : [String] = []
    var allDays : [String] = []
    var myMounthName : [String] = []
    let startDate = "2020-01-01"
    let endDate   = "2025-01-01"
    
    var dateFrom =  Date() // First date
    var dateTo = Date()   // Last date
    
    
    
    func returndayesNum () -> [String]{
        // Formatter for printing the date, adjust it according to your needs:
        let fmt = DateFormatter()
        fmt.dateFormat = "yyy-MM-dd"
       // dateFrom = fmt.date(from: startDate)!
        dateFrom = Date()
        dateTo = fmt.date(from: endDate)!
        fmt.locale = Locale(identifier: Constants.current_Language)
        fmt.dateFormat = "d"
        
        
        
        while dateFrom <= dateTo {
            mydayNum.append(fmt.string(from: dateFrom))
            dateFrom = Calendar.current.date(byAdding: .day, value: 1, to: dateFrom)!
            
        }
        return mydayNum
    }
    
    func returndayesNumF () -> [String]{
        // Formatter for printing the date, adjust it according to your needs:
        let fmt = DateFormatter()
        fmt.dateFormat = "yyy-MM-dd"
        dateFrom = fmt.date(from: startDate)!
       // dateFrom = Date()
        dateTo = fmt.date(from: endDate)!
        fmt.locale = Locale(identifier: Constants.current_Language)
        fmt.dateFormat = "d"
        
        
        
        while dateFrom <= dateTo {
            mydayNum.append(fmt.string(from: dateFrom))
            dateFrom = Calendar.current.date(byAdding: .day, value: 1, to: dateFrom)!
            
        }
        return mydayNum
    }
    
    func returnDayName () -> [String]{
        let fmt2 = DateFormatter()
        fmt2.dateFormat = "yyy-MM-dd"
      //  dateFrom = fmt2.date(from: startDate)!
         dateFrom = Date()
        dateTo = fmt2.date(from: endDate)!
        fmt2.locale = Locale(identifier: Constants.current_Language)
        fmt2.dateFormat = "EEEE"
        while dateFrom <= dateTo {
            mydayName.append(fmt2.string(from: dateFrom))
            dateFrom = Calendar.current.date(byAdding: .day, value: 1, to: dateFrom)!
            
        }
        return mydayName
    }
    func returnDayNameF () -> [String]{
        let fmt2 = DateFormatter()
        fmt2.dateFormat = "yyy-MM-dd"
        dateFrom = fmt2.date(from: startDate)!
        // dateFrom = Date()
        dateTo = fmt2.date(from: endDate)!
        fmt2.locale = Locale(identifier: Constants.current_Language)
        fmt2.dateFormat = "EEEE"
        while dateFrom <= dateTo {
            mydayName.append(fmt2.string(from: dateFrom))
            dateFrom = Calendar.current.date(byAdding: .day, value: 1, to: dateFrom)!
            
        }
        return mydayName
    }
    func returnMounth() -> [String]{
        let fmt3 = DateFormatter()
        fmt3.dateFormat = "yyy-MM-dd"
      //  dateFrom = fmt3.date(from: startDate)!
         dateFrom = Date()
        dateTo = fmt3.date(from: endDate)!
        fmt3.locale = Locale(identifier: Constants.current_Language)
        fmt3.dateFormat = "MMMM"
        while dateFrom <= dateTo {
            myMounthName.append(fmt3.string(from: dateFrom))
            dateFrom = Calendar.current.date(byAdding: .day, value: 1, to: dateFrom)!
            
            
        }
        return myMounthName
        
    }
    func returnMounthF() -> [String]{
           let fmt3 = DateFormatter()
           fmt3.dateFormat = "yyy-MM-dd"
           dateFrom = fmt3.date(from: startDate)!
         //   dateFrom = Date()
           dateTo = fmt3.date(from: endDate)!
           fmt3.locale = Locale(identifier: Constants.current_Language)
           fmt3.dateFormat = "MMMM"
           while dateFrom <= dateTo {
               myMounthName.append(fmt3.string(from: dateFrom))
               dateFrom = Calendar.current.date(byAdding: .day, value: 1, to: dateFrom)!
               
               
           }
           return myMounthName
           
       }
    
    
    func AllDaysFunc () -> [String]{
        let fmt2 = DateFormatter()
        fmt2.dateFormat = "yyy-MM-dd"
       // dateFrom = fmt2.date(from: startDate)!
         dateFrom = Date()
        dateTo = fmt2.date(from: endDate)!
        fmt2.locale = Locale(identifier: Constants.current_Language)
        fmt2.dateFormat = "EEEE, d, MMMM, yyyy"
        while dateFrom <= dateTo {
            allDays.append(fmt2.string(from: dateFrom))
            dateFrom = Calendar.current.date(byAdding: .day, value: 1, to: dateFrom)!
            
        }
        return allDays
    }
    func AllDaysFuncF () -> [String]{
         let fmt2 = DateFormatter()
         fmt2.dateFormat = "yyy-MM-dd"
         dateFrom = fmt2.date(from: startDate)!
         // dateFrom = Date()
         dateTo = fmt2.date(from: endDate)!
         fmt2.locale = Locale(identifier: Constants.current_Language)
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
        formatter.dateFormat = "yyyy-MM-dd"
        
        formatter.locale = Locale(identifier: Constants.current_Language)
        formatter.dateFormat = "EEEE, d, MMMM, yyyy"
        let outputDate = formatter.string(from: date)
        
        return outputDate
        
    }
   
    func getdateinBackFormate(date12 : String)->String{
         let formatter = DateFormatter()
         formatter.locale = Locale(identifier: Constants.current_Language)
         formatter.dateFormat = "EEEE, d, MMMM, yyyy"
        //"MM-dd-yyyy"
        guard let date = formatter.date(from: date12)else{return ""}
         let fmt = DateFormatter()
         fmt.dateFormat =  "yyyy-MM-dd"
         let outPut = fmt.string(from: date)
         return outPut
    }
    
    func getBackTime (Time:String)->String{
        let formatter = DateFormatter()
     //   formatter.locale = Locale(identifier: Constants.current_Language)
        formatter.timeZone = Calendar.current.timeZone
        formatter.dateFormat = "hh:mm a"
        //"MM-dd-yyyy"
        guard let date = formatter.date(from: Time) else {return ""}
        let fmt = DateFormatter()
        fmt.dateFormat = "HH:mm:ss"
        let outPut = fmt.string(from: date)
        return outPut
        
    }
    func getBackTimeCurrent ()->String{
           let formatter = DateFormatter()
        //   formatter.locale = Locale(identifier: Constants.current_Language)
           formatter.timeZone = Calendar.current.timeZone
           formatter.dateFormat = "hh:mm a"
           //"MM-dd-yyyy"
           let date = Date()
           let fmt = DateFormatter()
           fmt.dateFormat = "HH:mm:ss"
           let outPut = fmt.string(from: date)
           return outPut
           
       }
    func getCurrentTime (addHours:Int? = nil)->String{
          let formatter = DateFormatter()
       //   formatter.locale = Locale(identifier: Constants.current_Language)
          formatter.timeZone = Calendar.current.timeZone
          formatter.dateFormat = "hh:mm a"
          //"MM-dd-yyyy"
          var date = Date()
        if let addH = addHours {
            let calendar = Calendar.current
            let newDate = calendar.date(byAdding: .hour, value: addH, to: date)
            date = newDate ?? Date()

        }
          let fmt = DateFormatter()
          fmt.dateFormat = "hh:00"
          let outPut = fmt.string(from: date)
          return outPut
          
      }
      
    func getCurrentTimeAm (addHours:Int? = nil)->String{
        let formatter = DateFormatter()
     //   formatter.locale = Locale(identifier: Constants.current_Language)
        formatter.timeZone = Calendar.current.timeZone
        formatter.dateFormat = "hh:mm a"
        //"MM-dd-yyyy"
          var date = Date()
        if let addH = addHours {
            let calendar = Calendar.current
            let newDate = calendar.date(byAdding: .hour, value: addH, to: date)
            date = newDate ?? Date()

        }
        let fmt = DateFormatter()
        fmt.dateFormat = "a"
        let outPut = fmt.string(from: date)
        return outPut
        
    }
    
    
    
}





