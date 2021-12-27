//
//  OrderDate.swift
//  Sayen 
//
//  Created by Maher on 6/9/20.
//

import UIKit


class OrderDate: UIViewController {
    
    
    
    @IBOutlet weak var monthLBL: UILabel!
    @IBOutlet weak var mainView: CardView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var timeView: UIView!
 
    @IBOutlet weak var nextMonthButtonOutlet: UIButton!
    @IBOutlet weak var lastMonthButtonOutlet: UIButton!
    @IBOutlet weak var amPmView: UIView!
  
    
   
    weak var delegate : SendDate!
    let datePicker = UIPickerView()
    let timePicker = UIPickerView()
    let amPmPicker = UIPickerView()
    var dateSelected : String = ""
    var addMonth = 0
    let timeArr = ["01:00", "02:00","03:00","04:00","05:00","06:00","07:00","08:00","09:00","10:00","11:00","12:00"]
    let amPmArr = ["AM" , "PM"]
    var returnDateM = ReturnDate()
    var mydayNum : [String] = []
    var mydayName : [String] = []
    var myMounthName : String = ""
    var transformeDate = ""
    var TransformTime = ""
    var transformeAmPm = ""
    var dateBackEnd = ""
    var timeBackEnd = ""
    var currentTime : String = ""
    var currentTimeAm : String = ""
    var rotationAngle : CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createAllPicker ()

        timePicker.selectRow(6, inComponent: 0, animated: true)
        getDate()
        self.mydayNum = returnDateM.returndayesNum()
        self.mydayName = returnDateM.returnDayName()
        mydayNum = Array(mydayNum.prefix(32))
        mydayName = Array(mydayName.prefix(32))
        selecytedIndex()
        self.currentTime = returnDateM.getCurrentTime(addHours:2)
        self.currentTimeAm = returnDateM.getCurrentTimeAm(addHours:2)
        self.dateView.semanticContentAttribute = .forceLeftToRight
        self.timeView.semanticContentAttribute = .forceRightToLeft
        self.amPmView.semanticContentAttribute = .forceRightToLeft
//        
    }
    
    func getDate() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: Constants.current_Language)
        // formatter.dateFormat = "EEEE, d, MMMM"
        formatter.dateFormat = "MMMM"
        let outputDate = formatter.string(from: date)
        self.monthLBL.text = outputDate
    }
    func getDateSelected( date : Date) {
       
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
           formatter.locale = Locale(identifier: Constants.current_Language)
           // formatter.dateFormat = "EEEE, d, MMMM"
           formatter.dateFormat = "MMMM"
           let outputDate = formatter.string(from: date)
           self.monthLBL.text = outputDate
       }
    

    func selecytedIndex () {
        for (index , day) in returnDateM.AllDaysFunc().enumerated() {
            if day == returnDateM.returnCurrntdateDay() {
               // self.datePicker.selectedRow(inComponent: index)
                datePicker.selectRow(index, inComponent: 0, animated: true)
                
            }
        }
        
        for (index , time) in timeArr.enumerated() {
            if time == self.returnDateM.getCurrentTime(addHours:2){
                timePicker.selectRow(index, inComponent: 0, animated: true)
            }
        }
        for (index , timeAm) in amPmArr.enumerated() {
            if timeAm == self.returnDateM.getCurrentTimeAm(addHours:2){
                amPmPicker.selectRow(index, inComponent: 0, animated: true)
            }
        }
        
    
     }
    
    func createAllPicker () {
        rotationAngle = 90 * (.pi/180)
        
        lastMonthButtonOutlet.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        datePicker.delegate = self
        datePicker.dataSource = self
        datePicker.transform = CGAffineTransform(rotationAngle: rotationAngle)
        datePicker.frame = CGRect(x: 0, y : 0, width: self.dateView.frame.width, height: self.dateView.frame.height)
        
        self.dateView.addSubview(datePicker)
        
        timePicker.delegate = self
        timePicker.dataSource = self
        timePicker.transform = CGAffineTransform(rotationAngle: rotationAngle)
        timePicker.frame = CGRect(x: 0, y : 0, width: self.timeView.frame.width, height: self.timeView.frame.height)
        self.timeView.addSubview(timePicker)
        
        amPmPicker.delegate = self
        amPmPicker.dataSource = self
        amPmPicker.transform = CGAffineTransform(rotationAngle: rotationAngle)
        amPmPicker.frame = CGRect(x: 0, y : 0, width: self.amPmView.frame.width, height: self.amPmView.frame.height)
        self.amPmView.addSubview(amPmPicker)
    }

    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
//            for i in [1, 2] {
//
//                datePicker.subviews[i].isHidden = true
//                timePicker.subviews[i].isHidden = true
//                amPmPicker.subviews[i].isHidden = true
//            }
        }

  

    @IBAction func nextMonth(_ sender: Any) {
        lastMonthButtonOutlet.isHidden = false
        nextMonthButtonOutlet.isHidden = true
        prevMonth()
        
    }
    
    @IBAction func previousMonth(_ sender: Any) {
        lastMonthButtonOutlet.isHidden = true
        nextMonthButtonOutlet.isHidden = false
        nextMonth()
    }
    
    private func nextMonth() {
       var isoDate = dateSelected
                 if isoDate == "" {
                     isoDate = returnDateM.returnCurrntdateDay()
                 }
                 let dateFormatter = DateFormatter()
                 dateFormatter.locale = Locale(identifier: Constants.current_Language)
                 dateFormatter.dateFormat = "EEEE, d, MMMM, yyyy"
        if let date = dateFormatter.date(from:isoDate){
            var dateComponent = DateComponents()
            dateComponent.month = -1
            
            let futureDate = Calendar.current.date(byAdding: dateComponent, to: date)
            print(futureDate!)
            let dateString = dateFormatter.string(from: futureDate!)
            for (index , day) in returnDateM.AllDaysFunc().enumerated() {
                if day == dateString {
                    // self.datePicker.selectedRow(inComponent: index)
                    datePicker.selectRow(index, inComponent: 0, animated: true)
                    
                }
            }
        }
    }
    private func prevMonth() {
        
               var isoDate = dateSelected
               if isoDate == "" {
                   isoDate = returnDateM.returnCurrntdateDay()
               }
               let dateFormatter = DateFormatter()
               dateFormatter.locale = Locale(identifier: Constants.current_Language)
               dateFormatter.dateFormat = "EEEE, d, MMMM, yyyy"
        if let date = dateFormatter.date(from:isoDate){
            var dateComponent = DateComponents()
            dateComponent.month = 1
            
            let futureDate = Calendar.current.date(byAdding: dateComponent, to: date)
            print(futureDate!)
            let dateString = dateFormatter.string(from: futureDate!)
            for (index , day) in returnDateM.AllDaysFunc().enumerated() {
                if day == dateString {
                    // self.datePicker.selectedRow(inComponent: index)
                    datePicker.selectRow(index, inComponent: 0, animated: true)
                    
                }
            }
        }
    }
    
    @IBAction func saveDate(_ sender: Any) {
        let currentday = returnDateM.returnCurrntdateDay()
        if transformeDate == "" {
            self.dateBackEnd = returnDateM.getdateinBackFormate(date12: currentday)
            print(self.dateBackEnd)
            transformeDate = currentday
            print("TimeBackEnd \(timeBackEnd)")
            print("returnDateM.getBackTimeCurrent() \(returnDateM.getBackTimeCurrent())")
            
        }
        if TransformTime == "" {
            TransformTime = self.currentTime
            self.timeBackEnd = returnDateM.getBackTimeCurrent()
        }

        if transformeAmPm == "" {
            transformeAmPm = returnDateM.getCurrentTimeAm(addHours:2)
        }
        let ttt = "\(TransformTime) \(transformeAmPm)"
        self.timeBackEnd = (returnDateM.getBackTime(Time: ttt))
        print(dateBackEnd)
        if self.dateBackEnd == returnDateM.getdateinBackFormate(date12: currentday) {
            print("ok \(timeBackEnd)")
           
            let formatter = DateFormatter()
            formatter.dateFormat =  "HH:mm:ss"
            formatter.timeZone = Calendar.current.timeZone
          
            guard let date11 = formatter.date(from: timeBackEnd) else {return}
            guard let date22 = formatter.date(from:  returnDateM.getBackTimeCurrent()) else{return}
            let time1Houres = Calendar.current.component(.hour, from: date11)
            let time2Houres =  Calendar.current.component(.hour, from: date22)
            print(time1Houres)
            print(time2Houres)
 
            
            if time2Houres >= time1Houres  || time2Houres ==  time1Houres - 1  {
                self.showDAlert(title: "Error".localized, subTitle: "selectRightTime".localized, type: .error, buttonTitle: "tryAgain".localized, completionHandler: nil)
                return
            }else if transformeAmPm == "AM" , returnDateM.getCurrentTimeAm(addHours:2) == "PM" {
                self.showDAlert(title: "Error".localized, subTitle: "selectRightTime".localized, type: .error, buttonTitle: "tryAgain".localized, completionHandler: nil)
                return
            }
        }
        self.delegate.sendDate(date: "\(transformeDate), \(TransformTime) \(transformeAmPm)" , backendDate: "\(dateBackEnd) \(timeBackEnd)")
        self.dismissViewC()
        
    }
    @IBAction func dismiss(_ sender: Any) {
        self.dismissViewC()
        
    }
    
}

extension OrderDate : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == datePicker {
            return mydayNum.count
        }else if pickerView == timePicker{
            return timeArr.count
        }else{
            return amPmArr.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == datePicker {
            return mydayNum[row]
        }else if pickerView == timePicker{
            return timeArr[row]
        }else{
            return amPmArr[row]
        }
       
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == datePicker {
            print(row)
            print(returnDateM.AllDaysFunc()[row])
            
            dateSelected = (returnDateM.AllDaysFunc()[row])
         //   let datett = (returnDateM.getdateinBackFormate(date12: dateSelected))
            self.transformeDate = dateSelected
            self.dateBackEnd = returnDateM.getdateinBackFormate(date12: dateSelected)
            print("dateBackEnd : \(self.dateBackEnd)")
            self.monthLBL.text = returnDateM.returnMounth()[row]
        }else if pickerView == timePicker {
            self.TransformTime = timeArr[row]
        }else if pickerView == amPmPicker {
            self.transformeAmPm = amPmArr[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if pickerView == datePicker {
                return 60
            }else if pickerView == timePicker{
                return 60
            }else{
                return 50
            }
     
    }
//    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
//        return 60
//    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if pickerView == datePicker {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: 60, height: 90)
            let day = UILabel()
            day.frame = CGRect(x: 0, y: 20, width: 60, height: 30)
            day.text = mydayNum[row]
            day.textColor = UIColor.brownMainColor
            day.font = UIFont(name: "Tajawal-Bold", size: 17)
            day.textAlignment = .center
            view.addSubview(day)
            let dayName = UILabel()
            dayName.frame = CGRect(x: 0, y: 40, width: 60, height: 30)
            dayName.text = mydayName[row]
            dayName.textColor = UIColor.brownMainColor
            dayName.font = UIFont(name: "Tajawal-Bold", size: 15)
            dayName.textAlignment = .center
            view.addSubview(dayName)
            view.transform = CGAffineTransform(rotationAngle: -90 * (.pi/180))
            return view
        }else if pickerView == timePicker {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
            let timeLbl = UILabel()
            timeLbl.frame = CGRect(x: 0, y: 5, width: 60, height: 30)
            timeLbl.text = timeArr[row]
            timeLbl.textColor = UIColor.brownMainColor
            timeLbl.font = UIFont(name: "Tajawal-Bold", size: 17)
            timeLbl.textAlignment = .center
            view.addSubview(timeLbl)
            view.transform = CGAffineTransform(rotationAngle: -90 * (.pi/180))
            return view
        }else{
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
            let amLbl = UILabel()
            amLbl.frame = CGRect(x: 0, y: 5, width: 50, height: 30)
            amLbl.text = amPmArr[row]
            amLbl.textColor = UIColor.brownMainColor
            amLbl.font = UIFont(name: "Tajawal-Bold", size: 17)
            amLbl.textAlignment = .center
            view.addSubview(amLbl)
            view.transform = CGAffineTransform(rotationAngle: -90 * (.pi/180))
            return view
        }
        
    }
    
}
protocol SendDate : class {
    func sendDate (date : String , backendDate : String)
}
