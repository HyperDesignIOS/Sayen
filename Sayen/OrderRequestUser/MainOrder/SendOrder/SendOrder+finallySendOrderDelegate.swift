//
//  SendOrder+finallySendOrderDelegate.swift
//  Sayen 
//
//  Created by Awab's Mac on 11/11/21.
//

import Foundation
import SwiftyJSON

extension SendOrder : finallySendOrder , containuToPaymentProtocol , cancelAlertSend , successApplePay {
    func successApplePay(id: String, status: String) {
        print(orderId , id , status)
        
        APIClient.sendGetRequestWithParamter("https://sayen.co/api/v2/user/success-pay", parameters: ["order_id": "\(orderId)", "id": id, "status": status])  { responseObject, error in
            guard let responseObject = responseObject, error == nil else {
                print(error ?? "Unknown error")
                return
            }
            let json = JSON(responseObject)
            let msgStr = json["message"].string ?? ""
            let statusStr = json["status"].string ?? ""
            if statusStr ==  "1" ,msgStr ==  "Success pay" {
                self.showDAlert(title: "thanks".localized, subTitle:  "paymentSuccess".localized, type: .success, buttonTitle: "") { (_) in
                    self.gotoOrders()
                }
            }else {
                self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            }
            print(responseObject)
        }
    }
    
    
    
    func cancelAlertSendFunc() {
     //  let tabBar = self.tabBarController as! TabBarController
       self.dismissViewC()
     //  tabBar.showTab()
    }
    
    func continueToPaymentFunc() {
        self.navigationController?.pushViewController(paymentController, animated: true)
    }
    
    func finallySendOrder(payType: PaymentType) {
        self.paymentType = payType
        parameters["pay_method"] = payType.pay_method
        parameters["pay_type"] = payType.rawValue
        
//        if pay_method == 1 {
            self.sendCashOrder()
//        }
    }
    
    
}






enum PaymentType: String {
    case apple
    case cards
    case cash
    
    var pay_method : Int {
        switch self {
        case .apple, .cards:
            return 2
        case .cash:
            return 1
        }
    }
}
