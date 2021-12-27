//
//  PayMentVC.swift
//  Sayen 
//
//  Created by Maher on 6/11/20.
//

import UIKit
import PassKit
import DLRadioButton

class PaymentVC: UIViewController {

    @IBOutlet weak var initPrice: UILabel!
    @IBOutlet weak var copounPrice: UILabel!
    @IBOutlet weak var bankBtn: DLRadioButton!
    @IBOutlet weak var copunView: UIView!
    @IBOutlet weak var applePayBtn: DLRadioButton!
    @IBOutlet weak var topPriceCons: NSLayoutConstraint!
 //   @IBOutlet weak var applePayView: UIView!
    var initPricePay = ""
    var price = ""
    var service = ""
    var pricebeforeDis = ""
    var CouponBool = false
    let paymentHandler = PaymentHandler()
    weak var delegate : finallySendOrder!
    @IBOutlet weak var cashBtn: DLRadioButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setinit ()
      //  initApplePay()
    }

    
    func setinit (){
        self.bankBtn.isSelected = true
       
        if !CouponBool {
            self.initPrice.text = initPricePay
            self.copunView.alpha = 0
            self.topPriceCons.constant = 30
        }else{
            self.copunView.alpha = 1
            self.initPrice.text = pricebeforeDis
            self.copounPrice.text = initPricePay
            self.topPriceCons.constant = 56
        }
    }
//    func initApplePay(){
//        let result = PaymentHandler.applePayStatus()
//        var button: UIButton?
//
//        if result.canMakePayments {
//            button = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .white)
//        } else if result.canSetupCards {
//            button = PKPaymentButton(paymentButtonType: .setUp, paymentButtonStyle: .black)
//        }
//
//        if let applePayButton = button {
//            let constraints = [
//                applePayButton.centerXAnchor.constraint(equalTo: applePayView.centerXAnchor),
//                applePayButton.centerYAnchor.constraint(equalTo: applePayView.centerYAnchor)
//            ]
//            applePayButton.translatesAutoresizingMaskIntoConstraints = false
//            applePayButton.isEnabled = false
//            applePayView.addSubview(applePayButton)
//            NSLayoutConstraint.activate(constraints)
//        }
//    }
//    @objc func payPressed(sender: AnyObject) {
//        paymentHandler.startPayment() { (success) in
//            if success {
//                self.performSegue(withIdentifier: "Confirmation", sender: self)
//            }
//        }
//    }
//
//    @objc func setupPressed(sender: AnyObject) {
//        let passLibrary = PKPassLibrary()
//        passLibrary.openPaymentSetup()
//    }
  
    @IBAction func dismiss(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func SendOrder(_ sender: Any) {
        if applePayBtn.isSelected {
            self.delegate.finallySendOrder(payType: .apple)
        }else if bankBtn.isSelected {
            self.delegate.finallySendOrder(payType: .cards)
        } else {
            self.delegate.finallySendOrder(payType: .cash)
        }
    }
    
}

protocol finallySendOrder : class{
    func finallySendOrder(payType: PaymentType)
 }

