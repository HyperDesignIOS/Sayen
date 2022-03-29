//
//  String.swift
//  Eyas
//
//  Created by emad ios on 12/12/18.
//  Copyright © 2018 emad ios. All rights reserved.
//

import Foundation
import UIKit
extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        return self.substring(from: self.index(self.startIndex, offsetBy: from))
    }
    
    var length: Int {
        return self.count
    }
    
    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    var isValidIBAN : Bool {
        get {
            let ibanRegEx = "[a-zA-Z]{2}+[0-9]{2}+[a-zA-Z0-9]{4}+[0-9]{7}([a-zA-Z0-9]?){0,16}"
            let ibanTest = NSPredicate(format:"SELF MATCHES %@", ibanRegEx)
            return ibanTest.evaluate(with: self)
        }
    }
    
    var isValidBankAccountNumber : Bool {
        get {
            return self.count > 5 && self.count < 26
        }
    }
    
    //Validate Phone
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    
    var isValidPhoneNumber : Bool  {
        //        print("that is the phone : \(self)")
//    let PHONE_REGEX = "^(009665|9665|\\+9665|05|5)?(5|0|3|6|4|9|1|8|7)([0-9]{7,14})$"
        let PHONE_REGEX = "^(009665|9665|\\+9665|05|5)([0-9]{7,15})$"

        //let PHONE_REGEX = "^(5)(5|0|3|6|4|9|1|8|7|2)([0-9]{7,11})$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        print("that is the phone result : \(result)")
        return result
        return true

    }
    
    var isValidPhoneNumberKsa : Bool  {
        //        print("that is the phone : \(self)")
//                let PHONE_REGEX = "^(009665|9665|\\+9665)?(5|0|3|6|4|9|1|8|7)([0-9]{7})$"
        
        let PHONE_REGEX = "^(05|5)(5|0|3|6|4|9|1|8|7|2)([0-9]{7,10})$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        print("that is the phone result : \(result)")
        return result
        return true
    }
    
    //Validate Email
    //    var isEmail: Bool {
    //        do {
    //            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
    //            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
    //
    //        } catch {
    //            return false
    //        }
    //    }
    //
    var isEmail : Bool {
        // here, `try!` will always succeed because the pattern is valid
        do {
            
            let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        } catch {
            return false
        }
        
    }
    
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    func isPasswordConfirm(password: String , confirmPassword : String) -> Bool {
        if password == confirmPassword{
            return true
        }else{
            return false
        }
    }
    
    var isNumber : Bool {
        get{
            return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
    }
    
    //validate Password
    var isValidPassword: Bool {
//        if self.count >= 4 {
//            return true
//        }else {
//            return false
//        }
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-6]).{6,}")
        return passwordTest.evaluate(with: self)
    }
    
    var isValidateSocialPassword : Bool {

        if(self.count>=6 && self.count<=20){
        }else{
            return false
        }
        let nonUpperCase = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
        let letters = self.components(separatedBy: nonUpperCase)
        let strUpper: String = letters.joined()

        let smallLetterRegEx  = ".*[a-z]+.*"
        let samlltest = NSPredicate(format:"SELF MATCHES %@", smallLetterRegEx)
        let smallresult = samlltest.evaluate(with: self)

        let numberRegEx  = ".*[0-9]+.*"
        let numbertest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = numbertest.evaluate(with: self)

        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: NSRegularExpression.Options())
        var isSpecial :Bool = false
        if regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(), range:NSMakeRange(0, self.count)) != nil {
            print("could not handle special characters")
            isSpecial = true
        }else{
            isSpecial = false
        }
        return (strUpper.count >= 1) && smallresult && numberresult && isSpecial
    }
    
    var isValidPassportNumber : Bool {
        do {
            let regex = try! NSRegularExpression(pattern: "^(?!^0+$)[a-zA-Z0-9]{3,20}$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        } catch {
            return false
        }
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
    

    
    func returndayesNum() -> (dateName:String, dateNum: String,longFormate : String, month: String){
         let date = self
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
    
    
    var dateName: String {
        return self.returndayesNum().dateName
    }
    
    var dateNum: String {
        return self.returndayesNum().dateNum
    }
    
    var longFormate: String {
        return self.returndayesNum().longFormate
    }
    
    var month: String {
        return self.returndayesNum().month
    }
    
    
    
}

