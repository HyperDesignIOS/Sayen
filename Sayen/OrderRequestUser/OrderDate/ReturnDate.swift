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
    func returndayesNum (date: String) -> (dateName:String, dateNum: String,longFormate : String, month: String){
        
        var dateName = ""
        var dateNum = ""
        var longFormate = ""
        var month = ""
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Constants.current_Language)
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: date){
            formatter.dateFormat =  "EEEE"
            dateName = formatter.string(from: date)
            formatter.dateFormat = "d"
            dateNum = formatter.string(from: date)
            formatter.dateFormat = "EEEE, d, MMMM, yyyy"
            longFormate = formatter.string(from: date)
            formatter.dateFormat = "MMMM"
            month = formatter.string(from: date)
        }
        return (dateName:dateName, dateNum: dateNum, longFormate: longFormate, month: month)
    }
    func returndayesNumForCheckAPIRequest() -> [String]{
    
        let fmt = DateFormatter()
        fmt.dateFormat = "yyy-MM-dd"
        dateFrom = Date()
        let Todate = Calendar.current.date(byAdding: .month, value: 1, to: dateFrom)!
        dateTo = fmt.date(from: endDate)!
        fmt.locale = Locale(identifier: "en")
        fmt.dateFormat = "yyyy-MM-dd"
        mydayNum.removeAll()
        while dateFrom <= Todate {
            mydayNum.append(fmt.string(from: dateFrom))
            dateFrom = Calendar.current.date(byAdding: .day, value: 1, to: dateFrom)!
        }
        
        return mydayNum
    }
    func getCurrentMonthStr() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: Constants.current_Language)
        // formatter.dateFormat = "EEEE, d, MMMM"
        formatter.dateFormat = "MMMM"
        let outputDate = formatter.string(from: date)
        return outputDate

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
    func returnDayNameAfterCheck (days: [String]) -> [String]{
        var outDays : [String] = []
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: Constants.current_Language)
        formatter.dateFormat = "yyyy-MM-dd"
        for day in days {
            if let date = formatter.date(from: day){
                formatter.dateFormat =  "EEEE"
                outDays.append(formatter.string(from: date))
            }
        }
        return outDays
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
    
    func getBackTime(Time:String)->(backEnd:String , trsaform: String){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier: Constants.current_Language) // fixes nil if device time in 24 hour format
        var date24 = ""
        var transform = ""
        if let date =  dateFormatter.date(from: Time)  {
          
            dateFormatter.dateFormat = "hh:mm a"
            transform = dateFormatter.string(from: date)
            dateFormatter.locale = Locale(identifier: "en")
            dateFormatter.dateFormat = "HH:mm:ss"
             date24 = dateFormatter.string(from: date)
        }
      
        return (backEnd:date24 , trsaform: transform)
        
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
    func getCurrentDate ()->String{
        let date = Date()
        let fmt = DateFormatter()
//        fmt.locale = Locale(identifier: Constants.current_Language)
        fmt.dateFormat =  "yyyy-MM-dd"
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

//    private func nextMonth() {
//       var isoDate = dateSelected
//                 if isoDate == "" {
//                     isoDate = returnDateM.returnCurrntdateDay()
//                 }
//                 let dateFormatter = DateFormatter()
//                 dateFormatter.locale = Locale(identifier: Constants.current_Language)
//                 dateFormatter.dateFormat = "EEEE, d, MMMM, yyyy"
//        if let date = dateFormatter.date(from:isoDate){
//            var dateComponent = DateComponents()
//            dateComponent.month = -1
//
//            let futureDate = Calendar.current.date(byAdding: dateComponent, to: date)
//            print(futureDate!)
//            let dateString = dateFormatter.string(from: futureDate!)
//            for (index , day) in returnDateM.AllDaysFunc().enumerated() {
//                if day == dateString {
//                    // self.datePicker.selectedRow(inComponent: index)
//                    datePicker.selectRow(index, inComponent: 0, animated: true)
//
//                }
//            }
//        }
//    }
//    private func prevMonth() {
//               var isoDate = dateSelected
//               if isoDate == "" {
//                   isoDate = returnDateM.returnCurrntdateDay()
//               }
//               let dateFormatter = DateFormatter()
//               dateFormatter.locale = Locale(identifier: Constants.current_Language)
//               dateFormatter.dateFormat = "EEEE, d, MMMM, yyyy"
//        if let date = dateFormatter.date(from:isoDate){
//            var dateComponent = DateComponents()
//            dateComponent.month = 1
//
//            let futureDate = Calendar.current.date(byAdding: dateComponent, to: date)
//            print(futureDate!)
//            let dateString = dateFormatter.string(from: futureDate!)
//            for (index , day) in returnDateM.AllDaysFunc().enumerated() {
//                if day == dateString {
//                    // self.datePicker.selectedRow(inComponent: index)
//                    datePicker.selectRow(index, inComponent: 0, animated: true)
//
//                }
//            }
//        }
//    }
