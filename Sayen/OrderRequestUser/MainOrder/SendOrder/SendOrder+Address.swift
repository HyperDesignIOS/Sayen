//
//  SendOrder+Address.swift
//  Sayen 
//
//  Created by Awab's Mac on 11/11/21.
//

import UIKit

extension SendOrder : sendAddress , SendDate {
  
    
    func sendDate(date: String ,backendDate: String) {
        print(date)
        print(backendDate)
       
       
        for char:Character in date {
           
           
               let numberFormatter: NumberFormatter = NumberFormatter()
               numberFormatter.locale = NSLocale(localeIdentifier: "EN") as Locale?
                if let englishString = numberFormatter.number(from: String(char)) {
                   print(englishString)
                    
                    calenderNewDate.append(englishString.stringValue)
                
            }else{
                calenderNewDate.append(char)
            }
            
            print(calenderNewDate)
          
        }
        
        
        self.dateLbl.text = calenderNewDate
        calenderNewDate = ""
           
        
        self.parameters["visit_date"] = backendDate
    }
    @objc func didChangeText(field: UITextField) {
                   
               }
    
    func sendAddress(address: String, lat: Double, long: Double, floor: String) {
       self.showDAlert(title: "", subTitle:  "addressAdded".localized, type: .success, buttonTitle: "") { (_) in
            self.addressDetaiels = address
        self.addressLbl.text = "\(address) " + "floor".localized + " \(floor)"
            self.lat = lat
            self.long = long
            self.floor = floor
            self.parameters["address"] = address
            self.parameters["lat"] = lat
            self.parameters["lng"] = long
            self.parameters["floor"] = floor
            }
        
    }
    
    
    
}
