//
//  AddValuesAlert.swift
//  Sayen 
//
//  Created by ME-MAC on 3/24/22.
//


import UIKit
import DropDown
class AddValuesAlert: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var noteTextView: UITextView!
    
    var controlletType : AddValuesTypes!
    var alertMsg = ""
    var alertIcon = UIImage()
    var selectedServiceId = Int()
    var orderId = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewDelegate()
        displayStyle()
    }
    
    @IBAction func sendButton(_ sender: UIButton){
        switch controlletType {
        case .AddService:
            addServiceAPIRequest()
        case .AddMaterial:
            addMatrialAPIRequest()
        case .AddEmergencyService:
            addEmergencyServiceAPIRequest()
        case .AddEmergencyMaterial:
            addEmergencyMatrialAPIRequest()
        case .none:
            break
        }
    }
    @IBAction func closeButtons(_ sender: UIButton){
        self.dismissViewC()
    }
    func displayStyle(){
        switch controlletType {
        case .AddService, .AddEmergencyService:
            titleLabel.text = "addService".localized
            mainImageView.image = UIImage(named: "3247117")
            noteTextView.text = "addServiceNote".localized
        case .AddMaterial , .AddEmergencyMaterial:
            titleLabel.text = "addMatrial".localized
            mainImageView.image = UIImage(named: "supply-chain")
            noteTextView.text = "addMatrialNote".localized
        case .none:
            break
        }
    }
    
    private func textViewDelegate(){
        noteTextView.delegate = self
        noteTextView.textColor = UIColor.lightGray
        noteTextView.returnKeyType = .done
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    

    @objc func keyboardWillShow(notification: NSNotification){
        guard  let userInfo = notification.userInfo else {return}
        guard  let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFram = keyboardSize.cgRectValue
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardFram.height - 100
        }
    }
    
    @objc func keyboardWillHide(){
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    //MARK: API Request
    func addEmergencyServiceAPIRequest(){
        if let service = noteTextView.text , !service.isEmpty{
        ad.isLoading()
        APIClient.teamEmergencyOrderAddService(order_id: orderId, service: service, completionHandler: { (state, sms) in
            guard state else {
                ad.killLoading()
                 self.showDAlert(title: "Error".localized, subTitle: sms , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                return
            }
            DispatchQueue.main.async {
                ad.killLoading()
                self.showDAlert(title: "", subTitle: sms, type: .success, buttonTitle: "done".localized ) { (ـ) in
                    self.dismissViewC()
                }
//                    self.popView()
               
            }
            print(sms)
        }) { (err) in
            ad.killLoading()
             self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            print(err)
        }
    }
    
    }
    func addEmergencyMatrialAPIRequest(){
        if let material = noteTextView.text , !material.isEmpty{
        ad.isLoading()
        APIClient.teamEmergencyOrderAddMaterial(order_id: orderId, material: material, completionHandler: { (state, sms) in
            guard state else {
                ad.killLoading()
                 self.showDAlert(title: "Error".localized, subTitle: sms , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                return
            }
            DispatchQueue.main.async {
                ad.killLoading()
                self.showDAlert(title: "", subTitle: sms, type: .success, buttonTitle: "done".localized ) { (ـ) in
                    self.dismissViewC()
                }
//                    self.popView()
               
            }
            print(sms)
        }) { (err) in
            ad.killLoading()
             self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            print(err)
        }
    }
    
    }
    func addServiceAPIRequest(){
        if let service = noteTextView.text , !service.isEmpty{
        ad.isLoading()
        APIClient.teamAddService(order_id: orderId, service: service, completionHandler: { (state, sms) in
            guard state else {
                ad.killLoading()
                 self.showDAlert(title: "Error".localized, subTitle: sms , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                return
            }
            DispatchQueue.main.async {
                ad.killLoading()
                self.showDAlert(title: "", subTitle: sms, type: .success, buttonTitle: "done".localized ) { (ـ) in
                    self.dismissViewC()
                }
//                    self.popView()
               
            }
            print(sms)
        }) { (err) in
            ad.killLoading()
             self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            print(err)
        }
    }
    
    }
    func addMatrialAPIRequest(){
        if let material = noteTextView.text , !material.isEmpty{
        ad.isLoading()
        APIClient.teamAddMaterial(order_id: orderId, material: material, completionHandler: { (state, sms) in
            guard state else {
                ad.killLoading()
                 self.showDAlert(title: "Error".localized, subTitle: sms , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                return
            }
            DispatchQueue.main.async {
                ad.killLoading()
                self.showDAlert(title: "", subTitle: sms, type: .success, buttonTitle: "done".localized ) { (ـ) in
                    self.dismissViewC()
                }
//                    self.popView()
               
            }
            print(sms)
        }) { (err) in
            ad.killLoading()
             self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            print(err)
        }
    }
    
    }
}

        
extension AddValuesAlert : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if noteTextView.textColor == UIColor.lightGray {
            noteTextView.text = ""
            noteTextView.textColor = UIColor.black
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
           if(text == "\n") {
               textView.resignFirstResponder()
               return false
           }
           return true
       }

}


//
//protocol EmergancyVCDelegate: NSObjectProtocol {
//    func onDismissAlert(send message: String, serviceId: Int)
//}
//
enum AddValuesTypes {
    case AddService
    case AddMaterial
    case AddEmergencyService
    case AddEmergencyMaterial
}
