//
//  InvoiceDetailes.swift
//  Sayen  Worker
//
//  Created by Maher on 6/22/20.
//
//@IBOutlet weak var inWayV: UIView!
//@IBOutlet weak var inWayImg: UIImageView!
import UIKit

class InvoiceDetailes: UIViewController {
    @IBOutlet weak var finalPriceTopCons: NSLayoutConstraint!
    @IBOutlet weak var payState: UILabel!
    //    @IBOutlet weak var mainViewHieght: NSLayoutConstraint!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var orderNum: UILabel!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var inWayTitle: UILabel!
    @IBOutlet weak var endTitle: UILabel!
    @IBOutlet weak var inProgTitle: UILabel!
    @IBOutlet weak var newOrderTite: UILabel!
    @IBOutlet weak var newOrderImg: UIImageView!
    @IBOutlet weak var inWayImg: UIImageView!
    @IBOutlet weak var inProgImg: UIImageView!
    @IBOutlet weak var endImg: UIImageView!
    @IBOutlet weak var inProgV: UIView!
    @IBOutlet weak var inWayV: UIView!
    @IBOutlet weak var gotoEndV: UIView!
    @IBOutlet weak var copounView: UIView!
    @IBOutlet weak var initPrice: UILabel!
    @IBOutlet weak var discountPrice: UILabel!
    @IBOutlet weak var endPrice: UILabel!
    @IBOutlet weak var cashImgeTrue: UIImageView!
    @IBOutlet weak var clientTypeContainerV: UIView!
    @IBOutlet weak var clientTypeLbl: UILabel!
    @IBOutlet weak var paymentSourceContainerV: UIView!
    @IBOutlet weak var paymentSourceLbl: UILabel!
    var data : TeamOrderDetailes?
    var order_id : Int = 0
    var order_status : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabbar = self.tabBarController as? TabBarController
        self.clientTypeContainerV.isHidden = true
        self.paymentSourceContainerV.isHidden = true
        tabbar?.hideTab()
        getOrderData ()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        let tabbar = self.tabBarController as? TabBarController
        self.dismissViewC()
        tabbar?.showTab()
    }
    
    
    func getOrderData () {
        ad.isLoading()
        APIClient.getTOrder(order_id: self.order_id, completionHandler: { (state, sms, data) in
            ad.killLoading()
            guard state else {
                self.showDAlert(title: "Error".localized, subTitle: sms, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                
                return
            }
            
            if let data = data {
                
                self.clientTypeContainerV.isHidden = !data.isExcellenceClient
                self.paymentSourceContainerV.isHidden = !data.isExcellenceClient
                
                self.clientTypeLbl.text = data.isExcellenceClient ? "special".localized : "other".localized
                self.paymentSourceLbl.text = data.pay_by == "1" ? "client".localized :
                    "owner".localized
                print(data)
                DispatchQueue.main.async {
                    self.data = data
                    var initPrice = ""
                    //                    if let total = data.total_before_discount , let startP = data.initial_price {
                    //                        let v = total - startP
                    //                        let isInt = floor(v) == v
                    //                        initPrice = isInt ? "\(Int(v))" : "\(v)"
                    //                    }else {
                    //                       initPrice = "\(data.total_before_discount!)"
                    //                    }
                    self.mainTitle.text = data.title
                    self.orderNum.text = "#\(data.order_number ?? "")" 
                    self.dateLbl.text = data.date
                    self.initPrice.text = "\(data.initial_price ?? 0.0) " + "Rial".localized
                    self.discountPrice.text = "\(data.final_price!) " + "Rial".localized
                    self.endPrice.text = "\(data.final_price!) " + "Rial".localized
                    self.setOrderState(orderStatus: data.order_status!)
                }
                
            }
        }) { (err) in
            ad.killLoading()
            self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            
            print(err)
        }
    }
    
    func setOrderState (orderStatus : String) {
        if orderStatus == "2"{
            //To in progress
            self.inWayImg.image = UIImage(named: "Group 1069")
            self.inProgImg.image =  UIImage(named: "Group 1069")
            self.endImg.image = UIImage(named: "Ellipse 69")
            self.inWayV.backgroundColor = UIColor.brownMainColor
            self.inProgV.backgroundColor = UIColor.brownMainColor
            self.newOrderTite.textColor = UIColor.brownMainColor
            self.inWayTitle.textColor = UIColor.brownMainColor
            self.inProgTitle.textColor = UIColor.brownMainColor
            self.gotoEndV.backgroundColor = UIColor.brownMainColor
            self.cashImgeTrue.alpha = 1
            if data!.coupon_discount == 0 {
                self.copounView.alpha = 0
                self.finalPriceTopCons.constant = 16
                //                self.mainViewHieght.constant = 150
            }
        }else if orderStatus == "3"{
            //To end prog
            self.inWayImg.image = UIImage(named: "Group 1069")
            self.inProgImg.image  =  UIImage(named: "Group 1069")
            self.endImg.image  =  UIImage(named: "Group 1069")
            self.inWayV.backgroundColor = UIColor.brownMainColor
            self.inProgV.backgroundColor = UIColor.brownMainColor
            self.gotoEndV.backgroundColor = UIColor.brownMainColor
            self.newOrderTite.textColor = UIColor.brownMainColor
            self.inWayTitle.textColor = UIColor.brownMainColor
            self.inProgTitle.textColor = UIColor.brownMainColor
            self.endTitle.textColor = UIColor.brownMainColor
            self.cashImgeTrue.alpha = 1
            if data!.coupon_discount == 0 {
                self.copounView.alpha = 0
                self.finalPriceTopCons.constant = 16
                //                self.mainViewHieght.constant = 150
            }
        }else if (orderStatus == "4") {
            self.newOrderImg.image = UIImage(named: "Group 1069")
            self.inWayV.backgroundColor = UIColor.brownMainColor
            self.newOrderTite.textColor = UIColor.brownMainColor
            self.inWayImg.image = UIImage(named: "Group 1070")
            self.inWayTitle.textColor = UIColor.red
            self.inWayTitle.text = "canceled".localized
            self.inProgV.alpha = 0
            self.gotoEndV.alpha = 0
            self.inProgImg.alpha = 0
            self.endImg.alpha = 0
            self.inProgTitle.alpha = 0
            self.endTitle.alpha = 0
            self.cashImgeTrue.alpha = 0
            self.payState.text = "unpaid".localized
            if data!.coupon_discount == 0 {
                self.copounView.alpha = 0
                self.finalPriceTopCons.constant = 16
                //                self.mainViewHieght.constant = 150
            }
        }  else if orderStatus == "6"{
            //To in way
            self.inWayImg.image = UIImage(named: "Group 1069")
            self.inProgImg.image = UIImage(named: "Ellipse 69")
            self.inWayTitle.textColor = UIColor.brownMainColor
            self.inProgV.backgroundColor = UIColor.brownMainColor
            self.cashImgeTrue.alpha = 1
            if data!.coupon_discount == 0 {
                self.copounView.alpha = 0
                self.finalPriceTopCons.constant = 16
                //                self.mainViewHieght.constant = 150
            }
        }
    }
    
    
}
