//
//  ContactUsVc.swift
//  Sayen 
//
//  Created by Maher on 6/28/20.
//

import UIKit

class ContactUsVc: UIViewController {

    @IBOutlet weak var notesPlaceHolder: UILabel!
    @IBOutlet weak var messageTf: UITextView!
    @IBOutlet weak var nametf: UITextField!
    
    var whatsAppNumb = Constants.contactUsNumober
    override func viewDidLoad() {
        super.viewDidLoad()
        getContactNum()
        let tabBar = self.tabBarController as? TabBarController
        tabBar?.hideTab()
        self.messageTf.delegate = self
      
    }
    @IBAction func callCustomerServiceButton(_ sender: Any) {
        print("that's the phone Number : \(Constants.contactUsNumober)")
        
        guard  let phoneCallURL:URL = URL(string: "tel:\(Constants.contactUsNumober)") else {
            
            return
        }
        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(phoneCallURL)) {
            let alertController = UIAlertController(title: "", message:"continueAndCall".localized + " \n\(Constants.contactUsNumober)?", preferredStyle: .alert)
            let yesPressed = UIAlertAction(title: "yes".localized, style: .default, handler: { (action) in
                application.openURL(phoneCallURL)
            })
            let noPressed = UIAlertAction(title: "no".localized, style: .default, handler: { (action) in
                
            })
            alertController.addAction(yesPressed)
            alertController.addAction(noPressed)
            present(alertController, animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func  openWhatsApp () {
      let urlWhats = "https://wa.me/\(whatsAppNumb)/?text="
         if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
             if let whatsappURL = URL(string: urlString) {
                 if UIApplication.shared.canOpenURL(whatsappURL){
                     if #available(iOS 10.0, *) {
                         UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                     } else {
                         UIApplication.shared.openURL(whatsappURL)
                     }
                 }
                 else {
                     print("Install Whatsapp")
                 }
             }
         }
    }

    @IBAction func dismiss(_ sender: Any) {
      dismissHandeler ()
    }
    func dismissHandeler () {
        let tabBar = self.tabBarController as? TabBarController
        self.dismissViewC()
        tabBar?.showTab()
    }
    
    @IBAction func sendAction(_ sender: Any) {
        sendMessage ()
    }
    
    
    func sendMessage () {
        guard let name = self.nametf.text , name.count > 0 else {
            self.showDAlert(title: "Error".localized, subTitle: "enterName".localized , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            return}
        guard let message = self.messageTf.text , message.count > 0 else {
            self.showDAlert(title: "Error".localized, subTitle: "enterMassage".localized , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            return}
        ad.isLoading()
        APIClient.userSnedMessage(name: name, message: message, completionHandler: { (state, sms) in
            ad.killLoading()
            guard state else {
                 self.showDAlert(title: "Error".localized, subTitle: sms , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                return}
            self.showDAlert(title: "", subTitle: sms, type: .success, buttonTitle: "done".localized ) { (ـ) in
                            self.dismissHandeler()
                        }
        }) { (error) in
             ad.killLoading()
             self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            print("error")
        }
    }
    
    
    func getContactNum() {
        ad.isLoading()
        APIClient.static_page(id: 1, completionHandler: { (data) in
            ad.killLoading()
            if let data = data {
                DispatchQueue.main.async {
                    self.whatsAppNumb =  data.whatsapp ?? ""
                }
            }
            
            
        }) { (err) in
            ad.killLoading()
            print("error")
        }
    }
    
  
}



extension ContactUsVc : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.notesPlaceHolder.alpha = 0
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.messageTf.text == "" {
             self.notesPlaceHolder.alpha = 1
        }
       }
    
}
