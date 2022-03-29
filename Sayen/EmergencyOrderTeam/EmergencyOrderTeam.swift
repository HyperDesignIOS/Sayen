//
//  EndOrdersTeam.swift
//  Sayen  Worker
//
//  Created by ME-MAC on 2/17/22.
//

import UIKit

class EmergencyOrderTeam: UIViewController {

    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var data : [TeamOrderList] = []
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var toptableConst: NSLayoutConstraint!
    @IBOutlet weak var monthLBL: UILabel!
    @IBOutlet weak var filterOut: UIButton!
    @IBOutlet weak var dateView: UIView!
    let datePicker = UIPickerView()
    var returnDateM = ReturnDate()
    var mydayNum : [String] = []
    var mydayName : [String] = []
    var rotationAngle : CGFloat!
    var dateSelected : String = ""
    var transformeDate = ""
    var dateBackEnd = ""
    var offset = 0
    var total = 0
    var filter = false
//    lazy var refresher : UIRefreshControl = {
//         let refresher = UIRefreshControl()
//         refresher.addTarget(self, action: #selector(getData), for: .valueChanged)
//         return refresher
//       }()
    override func viewDidLoad() {
        super.viewDidLoad()
        createAllPicker ()
        rightButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        self.tableView.register(UINib(nibName: "OrderWorkerCell", bundle: nil), forCellReuseIdentifier: "OrderWorkerCell")
        tableView.delegate = self
        tableView.dataSource = self
   //     self.tableView.addSubview(refresher)
        getDate()
        self.mydayNum = returnDateM.returndayesNumF()
        self.mydayName = returnDateM.returnDayNameF()
        selecytedIndex()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          getData()
    }
    override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()

    }
        
        
    @objc func getData () {
        ad.isLoading()
        APIClient.getWorkerEmergencyOrders( completionHandler: { (state, data) in
            ad.killLoading()
            guard state else {
                 self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                return
            }
            if let data = data {
                self.data = data
                if data.count == 0 {
                    self.noDataLbl.alpha = 1
                    self.tableView.reloadData()
                   // self.tableView.alpha = 0
                }else{
                    self.noDataLbl.alpha = 0
                  //  self.tableView.alpha = 1
                    self.tableView.reloadData()
                }
            }
        }) { (err) in
            ad.killLoading()
            self.data = []
            self.noDataLbl.alpha = 1
            self.tableView.reloadData()
               self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            print(err)
        }
    }
    
    func loadMore () {
//        self.filter = false
//        APIClient.teamInvoices(offset: self.offset, completionHandler: { (state,data,total)  in
//            ad.killLoading()
//            guard state else {
//                self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
//                return
//            }
//            if let data = data {
//                if data.count == 0{
//                    self.noDataLbl.alpha = 1
//                }else{
//                    self.noDataLbl.alpha = 0
//
//                }
//                self.offset += 1
//                self.data.append(contentsOf: data)
//                self.tableView.reloadData()
//            }
//        }) { (err) in
//            ad.killLoading()
//            print("error")
//        }

    }
    
    func createAllPicker () {
         rotationAngle = -90 * (.pi/180)
         
         rightButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
         datePicker.delegate = self
         datePicker.dataSource = self
         datePicker.transform = CGAffineTransform(rotationAngle: rotationAngle)
         datePicker.frame = CGRect(x: 0, y : 16, width: self.dateView.frame.width, height: self.dateView.frame.height)
         self.dateView.addSubview(datePicker)
    }
    
    
    func getDate() {
           let date = Date()
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
           formatter.locale = Locale(identifier: "ar")
           // formatter.dateFormat = "EEEE, d, MMMM"
           formatter.dateFormat = "MMMM"
           let outputDate = formatter.string(from: date)
           self.monthLBL.text = outputDate
       }
       func getDateSelected( date : Date) {
          
              let formatter = DateFormatter()
              formatter.dateFormat = "yyyy-MM-dd"
              formatter.locale = Locale(identifier: "ar")
              // formatter.dateFormat = "EEEE, d, MMMM"
              formatter.dateFormat = "MMMM"
              let outputDate = formatter.string(from: date)
              self.monthLBL.text = outputDate
          }
    
    
    func selecytedIndex () {
        for (index , day) in returnDateM.AllDaysFuncF().enumerated() {
            if day == returnDateM.returnCurrntdateDay() {
               // self.datePicker.selectedRow(inComponent: index)
                datePicker.selectRow(index, inComponent: 0, animated: true)
                
            }
        }
     }
    
    
    func filterOrders(dateFrom : String){
        ad.isLoading()
        APIClient.filterWorkerEmergencyOrders(date: dateFrom, completionHandler: { (state, data) in
            ad.killLoading()
            print(state)
            guard state else {
                   self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                   return
               }
               if let data = data {
                   if data.count == 0{
                       self.noDataLbl.alpha = 1
                   }else{
                       self.noDataLbl.alpha = 0
                       
                   }
                   self.data = data
                   self.tableView.reloadData()
               }
        }) { (err) in
            ad.killLoading()
            print("error")
        }
    }
    

        @IBAction func nextMonth(_ sender: Any) {
            
                   var isoDate = dateSelected
                   if isoDate == "" {
                       isoDate = returnDateM.returnCurrntdateDay()
                   }
                   let dateFormatter = DateFormatter()
                   dateFormatter.locale = Locale(identifier: "ar")
                   dateFormatter.dateFormat = "EEEE, d, MMMM, yyyy"
                   let date = dateFormatter.date(from:isoDate)!
                   var dateComponent = DateComponents()
                   dateComponent.month = 1
                   
                   let futureDate = Calendar.current.date(byAdding: dateComponent, to: date)
                   print(futureDate!)
                   let dateString = dateFormatter.string(from: futureDate!)
                   for (index , day) in returnDateM.AllDaysFuncF().enumerated() {
                       if day == dateString {
                           // self.datePicker.selectedRow(inComponent: index)
                           datePicker.selectRow(index, inComponent: 0, animated: true)
                           
                       }
                   }
        }
        
        @IBAction func previousMonth(_ sender: Any) {
           var isoDate = dateSelected
                     if isoDate == "" {
                         isoDate = returnDateM.returnCurrntdateDay()
                     }
                     let dateFormatter = DateFormatter()
                     dateFormatter.locale = Locale(identifier: "ar")
                     dateFormatter.dateFormat = "EEEE, d, MMMM, yyyy"
                     let date = dateFormatter.date(from:isoDate)!
                     var dateComponent = DateComponents()
                     dateComponent.month = -1
                     
                     let futureDate = Calendar.current.date(byAdding: dateComponent, to: date)
                     print(futureDate!)
                     let dateString = dateFormatter.string(from: futureDate!)
                     for (index , day) in returnDateM.AllDaysFuncF().enumerated() {
                         if day == dateString {
                             // self.datePicker.selectedRow(inComponent: index)
                             datePicker.selectRow(index, inComponent: 0, animated: true)
                             
                         }
                     }
            
        }

        
    
    
    @IBAction func filterHandler(_ sender: Any) {
        self.filter = true
        if transformeDate == "" {
            let currentday = returnDateM.returnCurrntdateDay()
            self.dateBackEnd = returnDateM.getdateinBackFormate(date12: currentday)
            transformeDate = currentday
        }
        if toptableConst.constant == 20 {
         
            self.filterOut.setImage(UIImage(named: "interface (8)"), for: .normal)
           toptableConst.constant = 158
            self.filterView.alpha = 1
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            self.filterOrders(dateFrom: self.dateBackEnd)
        }else{
           
            self.filterOut.setImage(UIImage(named:"tools-and-utensils (1)"), for: .normal)
            toptableConst.constant = 20
            self.filterView.alpha = 0
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
            self.getData()
            
        }
    
    }

}


//extension EmergencyOrderTeam : UITableViewDelegate , UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data.count
//     }
//     
//     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//         let cell = self.tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
//         cell.title.text = self.data[indexPath.row].title
//         cell.date.text = self.data[indexPath.row].date
//         cell.orderNum.text = "#\(self.data[indexPath.row].order_number)"
//         cell.setStatus(orderStatus: self.data[indexPath.row].order_status)
//         return cell
//     }
//     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//         return 170
//     }
//     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//         guard ad.isOnline() else{return}
//          let vc = InvoiceDetailes()
//          vc.order_id = data[indexPath.row].id
//          vc.order_status = data[indexPath.row].order_status
//         self.navigationController?.pushViewController(vc, animated: true)
//     }
//    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let count = self.data.count
//        if indexPath.row == count-1 {
//            if count < total && !filter{
//                
//               loadMore()
//            }
//       
//        }
//    }
//    
//    
//}



extension EmergencyOrderTeam : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

            return mydayNum.count
      
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
   
            return mydayNum[row]
     
       
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
            print(row)
            print(returnDateM.AllDaysFuncF()[row])
            
            dateSelected = (returnDateM.AllDaysFuncF()[row])
         //   let datett = (returnDateM.getdateinBackFormate(date12: dateSelected))
            self.transformeDate = dateSelected
            self.dateBackEnd = returnDateM.getdateinBackFormate(date12: dateSelected)
            self.monthLBL.text = returnDateM.returnMounthF()[row]
            self.filterOrders(dateFrom: self.dateBackEnd)
     
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
       
                return 60
          
     
    }
//    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
//        return 60
//    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
       
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: 60, height: 90)
            let day = UILabel()
            day.frame = CGRect(x: 0, y: 10, width: 60, height: 30)
            day.text = mydayNum[row]
            day.textColor = UIColor.brownMainColor
            day.font = UIFont(name: "Tajawal-Bold", size: 17)
            day.textAlignment = .center
            view.addSubview(day)
            let dayName = UILabel()
            dayName.frame = CGRect(x: 0, y: 35, width: 60, height: 30)
            dayName.text = mydayName[row]
            dayName.textColor = UIColor.brownMainColor
            dayName.font = UIFont(name: "Tajawal-Bold", size: 15)
            dayName.textAlignment = .center
            view.addSubview(dayName)
            view.transform = CGAffineTransform(rotationAngle: 90 * (.pi/180))
            return view
      
        }
        
    }
    

