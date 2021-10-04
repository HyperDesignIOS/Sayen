//
//  EditPhoneVC.swift
//  Sayen 
//
//  Created by Maher on 6/4/20.
//

import UIKit

class EditPhoneVC: UIViewController {

    @IBOutlet weak var phoneTf: UITextField!
    var user_type : String {
          return ad.user_type()
      }
      lazy var viewModel : EditPhoneVM = {
          return EditPhoneVM()
      }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.phoneTf.text =  Constants.phoneNum
        phoneTf.delegate = self
        
        initViewModel ()
        
    }

    func initViewModel () {
        viewModel.showAlertClosure = { [weak self] () in
                guard let self = self else {return}
                DispatchQueue.main.async {
                    if let message = self.viewModel.alertMessage {
                        self.showDAlert(title: "Error".localized, subTitle: message, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                    }
                }
            }
        viewModel.updateLoadingStatus = {[weak self] () in
            guard let self = self else {return}
            switch self.viewModel.state {
            case .error , .empty:
                ad.killLoading()
                self.showDAlert(title: "Error".localized, subTitle: self.viewModel.alertMessage!, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)

            case .loading:
                ad.isLoading()
            case .populated :
                ad.killLoading()
                DispatchQueue.main.async {
                    
                    let vc = VerfyCode()
                    vc.delegate = self
                    vc.type = .changePhone
                    vc.phone = self.phoneTf.text!
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
               
            case .verfy:
                ad.killLoading()
            }
        }
        
    }
    
    


    
  
    @IBAction func dismiss(_ sender: Any) {
        self.dismissViewC()
    }
    
    @IBAction func saveAction(_ sender: Any) {
        viewModel.phone = self.phoneTf.text
        viewModel.changePhone()
    }
}
extension EditPhoneVC : ChangePhone {
    func dismissAndShowSms(state: Bool) {
        guard state else {
            return
        }
        DispatchQueue.main.async {
            self.showDAlert(title: "thanks".localized, subTitle:  "requestSentSuccessfully".localized, type: .success, buttonTitle: "") { (_) in
                DispatchQueue.main.async {
                    self.dismissViewC()
                }
            }
        }
        
    }
    
    
}



extension EditPhoneVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
     {
         
         if textField == self.phoneTf {
         guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
             return false
         }
         return true
         }
        return false
    }
}
