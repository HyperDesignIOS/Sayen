//
//  NewPasswordVC.swift
//  Sayen
//
//  Created by Maher on 5/31/20.
//  Copyright © 2020 maher. All rights reserved.
//

import UIKit

class NewPasswordVC: UIViewController {

    @IBOutlet weak var confirmPass: UITextField!
    @IBOutlet weak var newPass: UITextField!
    var newPassS : String = ""
    var confirmPassS : String = ""

    var user_type : String {
        return ad.user_type()
    }
    lazy var viewModel : NewPassVM = {
        return NewPassVM()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
      
        initViewModel()
        self.newPass.delegate = self
        self.confirmPass.delegate = self
       
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

                    self.showDAlert(title: "thanks".localized, subTitle: "passwordChanged".localized, type: .success, buttonTitle: "") { (_) in
                        DispatchQueue.main.async {
                         ad.save(userId: nil, token: nil)
                         ad.restartApplicationToLogin()
                         UserDefaults.standard.setValue(nil, forKey: Constants.firebaseTokenKey)
                         Constants.token2 = ""
                        }
                    }
                        
                    
                }
               
            case .verfy:
                ad.killLoading()
            }
        }
        
    }


    
    
    func resetAction () {
        viewModel.pass = self.newPassS
        viewModel.confirmPass = self.confirmPassS
        viewModel.initForget(for: self.user_type)
    }
   
    @IBAction func savePass(_ sender: Any) {
        resetAction ()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismissViewC()
    }
}



extension NewPasswordVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        if textField == self.newPass {
            newPassS = newPassS+string
            if newPassS.count < 16 {
                newPass.text = textField.text!+"*"
                print("\(newPassS)")
                if let char = string.cString(using: String.Encoding.utf8) {
                    let isBackSpace = strcmp(char, "\\b")
                    if (isBackSpace == -92) {
                        print("Backspace was pressed")
                        self.newPass.text = ""
                        self.newPassS = ""
                    }
                    
                }
                return false
            }
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    print("Backspace was pressed")
                    self.newPass.text = ""
                    self.newPassS = ""
                }
                
            }
            
        }
        if textField == self.confirmPass {
            confirmPassS = confirmPassS+string
            if confirmPassS.count < 16 {
                confirmPass.text = textField.text!+"*"
                print("\(confirmPassS)")
                if let char = string.cString(using: String.Encoding.utf8) {
                    let isBackSpace = strcmp(char, "\\b")
                    if (isBackSpace == -92) {
                        print("Backspace was pressed")
                        self.confirmPass.text = ""
                        self.confirmPassS = ""
                    }
                    
                }
                return false
            }
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    print("Backspace was pressed")
                    self.confirmPass.text = ""
                    self.confirmPassS = ""
                }
                
            }
            
        }
        
        
        return true
    }
}
