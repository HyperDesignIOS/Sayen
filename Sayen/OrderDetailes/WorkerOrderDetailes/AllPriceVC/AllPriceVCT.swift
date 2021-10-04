//
//  AllPriceVCT.swift
//  Sayen  Worker
//
//  Created by Maher on 6/17/20.
//

import UIKit
import DLRadioButton

class AllPriceVCT: UIViewController {

    @IBOutlet weak var checkBoxbtn: UIButton!
    var startPrice : String = ""
    var coponPrice : String = ""
    var endPrice : String = ""
    var order_id : Int = 0
    var tabBar : UITabBarController?
    weak var delegate : endFinalWork!
     @IBOutlet weak var coponView: UIView!
    @IBOutlet weak var startLbl: UILabel!
    @IBOutlet weak var discoundLbl: UILabel!
    @IBOutlet weak var endlbl: UILabel!
    @IBOutlet weak var requiredCostLbl: UILabel!
    @IBOutlet weak var cashtrueImg: UIImageView!
    
    @IBOutlet weak var paymentMethodContainerV: CardView!
    @IBOutlet weak var ownerPayBtnOL: DLRadioButton!
    @IBOutlet weak var clientPayBtnOL: DLRadioButton!
    
    @IBOutlet weak var finalCOstContainerV: UIView!
    @IBOutlet weak var costBeforeDiscountV: UIView!
    var cashPrice : Bool = false
    var data: TeamOrderDetailes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startLbl.text = "\(startPrice.getPriceValue()) " + "Rial".localized
        if let total = Double(coponPrice) , let startP = Double(startPrice) {
            let v = total - startP
            let isInt = floor(v) == v
            coponPrice = isInt ? "\(Int(v))" : "\(v)"
        }
        self.discoundLbl.text = "\(coponPrice.getPriceValue()) " + "Rial".localized
        self.endlbl.text = "\(endPrice.getPriceValue()) " + "Rial".localized
        if coponPrice == "0" || data?.coupon_discount == 0  || coponPrice == startPrice {
            self.coponView.isHidden = true
            
         }else{
            self.coponView.isHidden = false
         }
        clientPayBtnOL.isSelected = true
        paymentMethodContainerV.isHidden =  data?.excellence_client != "1"
        
        
        if let data = self.data , data.pay_method == "2" {
            
            if let initP = Double(startPrice) , let finalP = Double(endPrice) {
                self.finalCOstContainerV.isHidden = false
                self.requiredCostLbl.text = "\(finalP - initP)".getPriceValue()

            }
            
        }else {
             self.requiredCostLbl.text = endPrice.getPriceValue()
            self.finalCOstContainerV.isHidden = true
        }
    }

    //Group 1062

    @IBAction func checkhandler(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
            cashPrice = sender.isSelected
            if sender.isSelected {
                sender.setImage(#imageLiteral(resourceName: "Group 1062"), for: .normal)
                self.cashtrueImg.alpha = 1
            }else {
                sender.setImage(#imageLiteral(resourceName: "Rectangle 527"), for: .normal)
                self.cashtrueImg.alpha = 0
            }
    }
    
    
    @IBAction func endWorking(_ sender: Any) {
        guard cashPrice else{
            self.showDAlert(title: "", subTitle: "confirmReceipt".localized, type: .error, buttonTitle: "", completionHandler: nil)
               return
           }
        self.delegate.endFinalWork(state: true, pay_by: clientPayBtnOL.isSelected ? "1" : "2" )
          
    }

    @IBAction func dismiss(_ sender: Any) {
        self.dismissViewC()
   
    }
  

}


protocol endFinalWork : class {
    func endFinalWork (state : Bool,pay_by:String?)
}
