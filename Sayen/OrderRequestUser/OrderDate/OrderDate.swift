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
    let timeArr = ["06:00 AM","07:00 AM","08:00 AM","09:00 AM","10:00 AM","11:00 AM","12:00 PM","01:00 PM", "02:00 PM","03:00 PM","04:00 PM","05:00 PM","06:00 PM","07:00 PM","08:00 PM","09:00 PM"]
    var returnDateM = ReturnDate()
    var mydayNum : [String] = []
    var mydayName : [String] = []
    var myMounthName : String = ""
    var transformeDate = ""
    var TransformTime = ""
   // var transformeAmPm = ""
    var dateBackEnd = ""
    var timeBackEnd = ""
    var currentTime : String = ""
    var currentTimeAm : String = ""
    var rotationAngle : CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAllPicker ()
        
//        timePicker.selectRow(11, inComponent: 0, animated: true)
        self.monthLBL.text = returnDateM.getCurrentMonthStr()
        self.mydayNum = returnDateM.returndayesNum()
        self.mydayName = returnDateM.returnDayName()
        mydayNum = Array(mydayNum.prefix(32))
        mydayName = Array(mydayName.prefix(32))
        selecytedIndex()
        self.currentTime = returnDateM.getCurrentTime(addHours:2)
        
        self.dateView.semanticContentAttribute = .forceLeftToRight
        self.timeView.semanticContentAttribute = .forceRightToLeft
        self.amPmView.semanticContentAttribute = .forceRightToLeft
//        
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
       
        timePicker.frame = CGRect(x: 0, y : 0, width: self.timeView.frame.width, height: self.timeView.frame.height)
        self.timeView.addSubview(timePicker)

    }

    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()

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

    
        self.timeBackEnd = (returnDateM.getBackTime(Time: TransformTime))
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
            }
        }
        self.delegate.sendDate(date: "\(transformeDate), \(TransformTime)" , backendDate: "\(dateBackEnd) \(timeBackEnd)")
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
        }else{
            return timeArr.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == datePicker {
            return mydayNum[row]
        }else {
            return timeArr[row]
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
        }else  {
            self.TransformTime = timeArr[row]
            print(self.TransformTime)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if pickerView == datePicker {
                return 60
            }else {
                return 30
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
        }else  {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: 120, height: 30)
            let timeLbl = UILabel()
            timeLbl.frame = CGRect(x: 0, y: 0, width: 120, height: 30)
            timeLbl.text = timeArr[row]
            timeLbl.textColor = UIColor.brownMainColor
            timeLbl.font = UIFont(name: "Tajawal-Bold", size: 17)
            timeLbl.textAlignment = .center
            view.addSubview(timeLbl)
           // view.transform = CGAffineTransform(rotationAngle: -90 * (.pi/180))
            return view
        }

    }
    
}
protocol SendDate : class {
    func sendDate (date : String , backendDate : String)
}
