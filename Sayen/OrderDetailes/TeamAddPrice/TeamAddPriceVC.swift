//
//  TeamAddPriceVC.swift
//  Sayen  Worker
//
//  Created by Maher on 6/17/20.
//

import UIKit

protocol DidUpdatePrice :class {
    
    func didUpdatePrice(_ price:Double)
}
class TeamAddPriceVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var numOfRows = 1
    var total  : Double = 0.0
    weak var delegtea : DidUpdatePrice?
    
    var priceDescDict = [Int:String](){
        didSet {
            print(priceDescDict)
        }
    }
    var priceNumDict = [Int:String](){
        didSet {
            print(priceNumDict)
        }
    }

    var priceNum : [String] = []{
        didSet {
            print(priceDesc , priceNum)
        }
    }
    var priceDesc : [String] = [] {
        didSet {
            print(priceDesc, priceNum)
        }
    }
    var id = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TeamAddPriceCell", bundle: nil), forCellReuseIdentifier: "TeamAddPriceCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self

      
    }

    @IBAction func dismiss(_ sender: Any) {
        self.dismissViewC()
    }
    
    @IBAction func sendNewPrice(_ sender: Any) {
         self.view.endEditing(true)
        
        self.total = 0
        self.priceDesc.removeAll()
        self.priceNum.removeAll()
        
     let countRowsOne = tableView.numberOfRows(inSection: 0)
 
        guard self.priceNumDict.count == countRowsOne  else {
            self.showDAlert(title: "Error".localized, subTitle: "من فضلك قم بإضافة المبلغ اولا", type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            return
         }
        
        
               guard   self.priceDescDict.count == self.priceNumDict.count else {
                   self.showDAlert(title: "Error".localized, subTitle: "من فضلك ادخل وصف المبلغ", type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                   return
                }
        for (_,value) in priceNumDict {
            if value == "" {
                self.showDAlert(title: "Error".localized, subTitle: "من فضلك قم بإضافة المبلغ اولا", type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                return
            }else {
                self.priceNum.append(value)
            }
        }
        for (_,value) in priceDescDict {
            if value == "" {
                self.showDAlert(title: "Error".localized, subTitle: "من فضلك ادخل وصف المبلغ", type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                return
            }else {
                if let price = Double(value) {
                    total += price
                }
                self.priceDesc.append(value)
            }
        }
        
        ad.isLoading()
        APIClient.teamAddPrice(order_id: self.id, price: self.priceNum, price_desc: self.priceDesc, completionHandler: { (state, sms) in
             ad.killLoading()
            guard state else {
               
                self.showDAlert(title: "Error".localized, subTitle: sms, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                self.priceNum.removeAll()
                self.priceDesc.removeAll()
                self.tableView.reloadData()
                return
            }
       
            self.showDAlert(title: "", subTitle: "تم ارسال التكلفة الجديدة للعميل", type: .success, buttonTitle: "") { (ـ) in
                self.delegtea?.didUpdatePrice(self.total)
                self.dismissViewC()
            }
            
        }) { (err) in
             ad.killLoading()
            self.showDAlert(title: "Error".localized, subTitle: "", type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            self.priceNum.removeAll()
            self.priceDesc.removeAll()
            self.tableView.reloadData()
            print(err)
        }
        
    }
    
    
    

}

extension TeamAddPriceVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamAddPriceCell", for: indexPath) as! TeamAddPriceCell
        print(indexPath)
        if indexPath.last == numOfRows-1 {
            cell.addView.alpha = 1
            cell.addView.isUserInteractionEnabled = true
            cell.rowHightCons.constant = 259
            cell.addRow.addTarget(self, action: #selector(addRow), for: .touchUpInside)
  
            
        }else{
            cell.addView.alpha = 0
            cell.addView.isUserInteractionEnabled = false
            cell.rowHightCons.constant = 190
            
            
            
        }
        cell.priceAdd.tag = indexPath.row
        cell.discribeTf.tag = indexPath.row

        cell.priceAdd.addTarget(self, action: #selector(setTextFPrice(_:)), for: .editingDidEnd)
        cell.discribeTf.addTarget(self, action: #selector(setTextFDesc(_:)), for: .editingDidEnd)
        
        cell.deleteRowBtn.layer.setValue(indexPath.row, forKey: "index")
        cell.deleteRowBtn.addTarget(self, action: #selector(deleteRow(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.last == numOfRows-1 {
            return self.tableView.frame.height / 1.9
        }else{
            return self.tableView.frame.height / 2.4
        }
    }
    
    @objc func addRow () {
        self.numOfRows += 1
     
        self.tableView.reloadData()
        if let cell = tableView.cellForRow(at: IndexPath(row: numOfRows-1, section: 0)) as? TeamAddPriceCell {
                cell.discribeTf.text = ""
                cell.priceAdd.text = ""
            }
    }
    @objc func deleteRow (sender:UIButton) {
        if numOfRows == 1 {return}
           self.numOfRows -= 1
           self.tableView.reloadData()
       }
    
    
    @objc func setTextFPrice(_ sender : UITextField ) {
        
        
        self.priceNumDict[sender.tag] = sender.text ?? ""
    }
    
    @objc func setTextFDesc(_ sender : UITextField ) {
          
          self.priceDescDict[sender.tag] = sender.text ?? ""

      }
}


 
