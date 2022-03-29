/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A shared class for handling payments across an app and its related extensions.
*/

import UIKit
import PassKit
import SwiftyJSON

typealias PaymentCompletionHandler = (Bool) -> Void

class PaymentHandler: NSObject {

    var paymentController: PKPaymentAuthorizationController?
    var paymentSummaryItems = [PKPaymentSummaryItem]()
    var paymentStatus = PKPaymentAuthorizationStatus.failure
    var completionHandler: PaymentCompletionHandler!
    var priceAmount: String = ""
    weak var delegate : successApplePay!
    static let supportedNetworks: [PKPaymentNetwork] = [
        .amex,
        .discover,
        .masterCard,
        .visa
    ]

    class func applePayStatus() -> (canMakePayments: Bool, canSetupCards: Bool) {
        return (PKPaymentAuthorizationController.canMakePayments(),
                PKPaymentAuthorizationController.canMakePayments(usingNetworks: supportedNetworks))
    }
    
    // Define the shipping methods.
//    func shippingMethodCalculator() -> [PKShippingMethod] {
//        // Calculate the pickup date.
//
//        let today = Date()
//        let calendar = Calendar.current
//
//        let shippingStart = calendar.date(byAdding: .day, value: 3, to: today)!
//        let shippingEnd = calendar.date(byAdding: .day, value: 5, to: today)!
//
//        let startComponents = calendar.dateComponents([.calendar, .year, .month, .day], from: shippingStart)
//        let endComponents = calendar.dateComponents([.calendar, .year, .month, .day], from: shippingEnd)
//
//        let shippingDelivery = PKShippingMethod(label: "Delivery", amount: NSDecimalNumber(string: "0.00"))
////        shippingDelivery.dateComponentsRange = PKDateComponentsRange(start: startComponents, end: endComponents)
//        shippingDelivery.detail = "Ticket sent to you address"
//        shippingDelivery.identifier = "DELIVERY"
//
//        let shippingCollection = PKShippingMethod(label: "Collection", amount: NSDecimalNumber(string: "0.00"))
//        shippingCollection.detail = "Collect ticket at festival"
//        shippingCollection.identifier = "COLLECTION"
//
//        return [shippingDelivery, shippingCollection]
//    }
//
    func startPayment(price: String, completion: @escaping PaymentCompletionHandler) {

        completionHandler = completion
         
        let service = PKPaymentSummaryItem(label:  Constants.merchantName, amount: NSDecimalNumber(string: price), type: .final)
        
        priceAmount = price
        paymentSummaryItems = [service]

        // Create a payment request.
        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = paymentSummaryItems
        paymentRequest.merchantIdentifier = Configuration.Merchant.identifier
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.countryCode = "SA"
        paymentRequest.currencyCode = "SAR"
        paymentRequest.supportedNetworks = PaymentHandler.supportedNetworks
//        paymentRequest.shippingType = .servicePickup

//        paymentRequest.shippingMethods = shippingMethodCalculator()
//        paymentRequest.requiredShippingContactFields = [.name, .postalAddress]

        // Display the payment request.
        paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        paymentController?.delegate = self
        paymentController?.present(completion: { (presented: Bool) in
            if presented {
                debugPrint("Presented payment controller")
            } else {
                debugPrint("Failed to present payment controller")
                self.completionHandler(false)
            }
        })
    }
}

// Set up PKPaymentAuthorizationControllerDelegate conformance.

extension PaymentHandler: PKPaymentAuthorizationControllerDelegate {

    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {

        // Perform basic validation on the provided contact information.
        var errors = [Error]()
        var status = PKPaymentAuthorizationStatus.success
        var semaphore = DispatchSemaphore (value: 0)
        let paymentDataDictionary: [AnyHashable: Any]? = try? (JSONSerialization.jsonObject(with: payment.token.paymentData, options: .mutableContainers) as! [AnyHashable : Any])
        
        let price = (Double(priceAmount) ?? 0.0) * 100
        if let paymentDataDic = paymentDataDictionary {
            if let headerDictionaryGr = paymentDataDic["header"] as?  [AnyHashable: Any]  {
                let headerDictionary : [AnyHashable: Any] = ["publicKeyHash": "\(headerDictionaryGr["publicKeyHash"] ?? "")","ephemeralPublicKey": "\(headerDictionaryGr["ephemeralPublicKey"] ?? "")","transactionId": "\(headerDictionaryGr["transactionId"] ?? "")"]
                print(headerDictionary)
            

            let tokenDictionary: [AnyHashable: Any]  = ["data": "\(paymentDataDic["data"] ?? "")","signature": "\(paymentDataDic["signature"]  ?? "")", "header": headerDictionary, "version": "\(paymentDataDic["version"] ?? "")"]
          
            let sourceDictionary: [AnyHashable: Any]  = ["type": "applepay", "token": tokenDictionary]
            let parametersDictionary: [AnyHashable: Any] = ["amount": price, "description": "apple pay request", "source": sourceDictionary]
            print(parametersDictionary,"")
    //
            let parameters: Data? = try? JSONSerialization.data(withJSONObject: parametersDictionary, options: [])
            
            let username = "pk_test_2VTNkH5DfoAKATQsF1wh2eoG7vBk3T21GzYsuQNX"
            let password = ""
            let loginString = String(format: "%@:%@", username, password)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            var request = URLRequest(url: URL(string: "https://api.moyasar.com/v1/payments")!,timeoutInterval: Double.infinity)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")

            request.httpMethod = "POST"
            request.httpBody = parameters
            

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
             guard let data = data else {
               print(String(describing: error))
               semaphore.signal()
               return
             }
                 print(String(data: data, encoding: .utf8)!)
                let json = JSON(data)
                
                
                let id = json["id"].string ?? ""
                let status = json["status"].string ?? ""
                self.delegate.successApplePay(id: id, status: status)
                print(id , status)
                
             semaphore.signal()
            }
            task.resume()
            semaphore.wait()
            

            }
        }
     
            
  
        let token = payment.token
        print(token)
        self.paymentStatus = status
        completion(PKPaymentAuthorizationResult(status: status, errors: errors))
    }

    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            // The payment sheet doesn't automatically dismiss once it has finished. Dismiss the payment sheet.
            DispatchQueue.main.async {
                if self.paymentStatus == .success {
                    self.completionHandler!(true)
                } else {
                    self.completionHandler!(false)
                }
            }
        }
    }
}
protocol successApplePay : class{
    func successApplePay(id: String, status: String)
 }

//extension PaymentHandler: PKPaymentAuthorizationControllerDelegate {
//
//    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
//
//        // Perform basic validation on the provided contact information.
//        var errors = [Error]()
//        var status = PKPaymentAuthorizationStatus.success
//        var semaphore = DispatchSemaphore (value: 0)
//        let paymentDataDictionary: [AnyHashable: Any]? = try? (JSONSerialization.jsonObject(with: payment.token.paymentData, options: .mutableContainers) as! [AnyHashable : Any])
//
////        var paymentType: String = "debit"
////
////        var paymentMethodDictionary: [AnyHashable: Any] = ["network": "", "type": paymentType, "displayName": ""]
////
////        if #available(iOS 9.0, *) {
////            paymentMethodDictionary = ["network": payment.token.paymentMethod.network ?? "", "type": paymentType, "displayName": payment.token.paymentMethod.displayName ?? ""]
////
////            switch payment.token.paymentMethod.type {
////                case .debit:
////                    paymentType = "debit"
////                case .credit:
////                    paymentType = "credit"
////                case .store:
////                    paymentType = "store"
////                case .prepaid:
////                    paymentType = "prepaid"
////                default:
////                    paymentType = "unknown"
////                }
////        }
//
////        let cryptogramDictionary: [AnyHashable: Any] = ["paymentData": paymentDataDictionary ?? "", "transactionIdentifier": payment.token.transactionIdentifier, "paymentMethod": paymentMethodDictionary]
//        let price = (Double(priceAmount) ?? 0.0) * 100
//        guard let paymentDataDic = paymentDataDictionary else {return}
//        guard let  headerDictionaryGr = paymentDataDic["header"] as?  [AnyHashable: Any]  else {return}
//
//            let headerDictionary : [AnyHashable: Any] = ["publicKeyHash": "\(headerDictionaryGr["publicKeyHash"] ?? "")","ephemeralPublicKey": "\(headerDictionaryGr["ephemeralPublicKey"] ?? "")","transactionId": "\(headerDictionaryGr["transactionId"] ?? "")"]
//            print(headerDictionary)
//
////        if let  header = paymentDataDic["header"] as? [AnyHashable: Any]{
////            if let something = header["publicKeyHash"]{
////                print(something,"somthing")
////            }
////        }
//
//
//
//
//
//
//        let tokenDictionary: [AnyHashable: Any]  = ["data": "\(paymentDataDic["data"] ?? "")","signature": "\(paymentDataDic["signature"]  ?? "")", "header": headerDictionary, "version": "\(paymentDataDic["version"] ?? "")"]
//
//        let sourceDictionary: [AnyHashable: Any]  = ["type": "applepay", "token": tokenDictionary]
//        let parametersDictionary: [AnyHashable: Any] = ["amount": price, "description": "apple pay request", "source": sourceDictionary]
//        print(parametersDictionary,"")
////        let cardCryptogramPacketDictionary: [AnyHashable: Any] = cryptogramDictionary
//        let parameters: Data? = try? JSONSerialization.data(withJSONObject: parametersDictionary, options: [])
////        let string = cardCryptogramPacketData?.base64EncodedString()
////        let postData = string?.data(using: .utf8)
////        let username = "pk_live_nwC516XHiZn5TLSskHX2sWQtW8Hveuau6fCCQEXH"
////        let password = ""
//        let username = "pk_test_2VTNkH5DfoAKATQsF1wh2eoG7vBk3T21GzYsuQNX"
//        let password = ""
//        let loginString = String(format: "%@:%@", username, password)
//        let loginData = loginString.data(using: String.Encoding.utf8)!
//        let base64LoginString = loginData.base64EncodedString()
//        var request = URLRequest(url: URL(string: "https://api.moyasar.com/v1/payments")!,timeoutInterval: Double.infinity)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
//
//        request.httpMethod = "POST"
//        request.httpBody = parameters
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//         guard let data = data else {
//           print(String(describing: error))
//           semaphore.signal()
//           return
//         }
//             print(String(data: data, encoding: .utf8)!)
//            let json = JSON(data)
//
//
//            let id = json["id"].string ?? ""
//            let status = json["status"].string ?? ""
//            self.delegate.successApplePay(id: id, status: status)
//            print(id , status)
//
//         semaphore.signal()
//        }
//        task.resume()
//        semaphore.wait()
//
////        // in cardCryptogramPacketString we now have all necessary data which demand most of bank gateways to process the payment
////
////        let cardCryptogramPacketString = String(describing: cardCryptogramPacketData)
//
//        let token = payment.token
//        print(token)
//        self.paymentStatus = status
//        completion(PKPaymentAuthorizationResult(status: status, errors: errors))
//    }
//
//    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
//        controller.dismiss {
//            // The payment sheet doesn't automatically dismiss once it has finished. Dismiss the payment sheet.
//            DispatchQueue.main.async {
//                if self.paymentStatus == .success {
//                    self.completionHandler!(true)
//                } else {
//                    self.completionHandler!(false)
//                }
//            }
//        }
//    }
//}
