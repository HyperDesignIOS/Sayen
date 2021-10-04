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
    override func viewDidLoad() {
        super.viewDidLoad()

        let tabBar = self.tabBarController as? TabBarController
        tabBar?.hideTab()
        self.messageTf.delegate = self
      
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
