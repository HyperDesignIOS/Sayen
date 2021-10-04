//
//  AddPriceVC.swift
//  Sayen 
//
//  Created by Maher on 6/16/20.
//

import UIKit

class AddPriceVC: UIViewController {

    @IBOutlet weak var tableViewHight: NSLayoutConstraint!
    @IBOutlet weak var allhieghtCons: NSLayoutConstraint!
    @IBOutlet weak var newPrice: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var copnPrice: UILabel!
    @IBOutlet weak var endPriceCon: NSLayoutConstraint!
    @IBOutlet weak var totPrice: UILabel!
    @IBOutlet weak var copnTitle: UILabel!
    weak var delegate : AcceptPrice!
    @IBOutlet weak var coponView: UIView!
    
    @IBOutlet weak var btnsStack: UIStackView!
    var team_added_price_desc : [String] = []
    var team_added_price : [String] = []
    var totPriceT : Double = 0.0
    var newPriceT : Double = 0.0
    var CoponDiscount : Double = 0.0
    var order_id = 0
    var status = "1"
    var btnsState = false
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "AddedPriceCell", bundle: nil), forCellReuseIdentifier: "AddedPriceCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.totPrice.text = "\(totPriceT) " + "Rial".localized
        self.newPrice.text = "\(newPriceT) " + "Rial".localized
        if CoponDiscount == 0 {
            self.coponView.alpha = 0
            self.endPriceCon.constant = 20
            self.allhieghtCons.constant = 450
            if self.btnsState  {
                self.btnsStack.alpha = 0
               self.allhieghtCons.constant = 400
            }
        }else{
            self.coponView.alpha = 1
            self.copnPrice.text = "\(CoponDiscount) " + "Rial".localized
            self.endPriceCon.constant = 58
            self.allhieghtCons.constant = 500
            if self.btnsState  {
               self.btnsStack.alpha = 0
               self.allhieghtCons.constant = 450
            }
        }
        
//        if self.btnsState {
//            self.btnsStack.alpha = 0
//            self.allhieghtCons.constant = 450
//        }
       
           
       
        
    }

    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
       // self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func acceptPrice(_ sender: Any) {
        self.status = "1"
        self.btnsStack.alpha = 0
        sendState()
    }
    @IBAction func cancelPrice(_ sender: Any) {
        self.status = "2"
        sendState()
    }
    
    
    
    func sendState () {
        self.delegate.acceptPrice(Status: status)
        self.dismissViewC()
//        APIClient.sendAcceptPrice(order_id: self.order_id, status: self.status, completionHandler: { (state, sms) in
//            guard state else {
//                return
//            }
//
//
//        }) { (err) in
//            print("error")
//        }
    }
}


extension AddPriceVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.team_added_price.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "AddedPriceCell", for: indexPath) as! AddedPriceCell
        cell.price.text = ("\(self.team_added_price[indexPath.row]) " + "Rial".localized)
        cell.priceDesc.text = "" 
        if indexPath.row < self.team_added_price_desc.count  {
        cell.priceDesc.text = self.team_added_price_desc[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.height / 2.3
    }
    
    
    
}


protocol AcceptPrice : class {
    func acceptPrice(Status : String)
}
