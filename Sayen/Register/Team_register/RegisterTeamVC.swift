//
//  RegisterTeamVC.swift
//  Sayen  Worker
//
//  Created by Eslam Abo El Fetouh on 10/25/20.
//

import UIKit

class RegisterTeamVC: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!

    @IBOutlet weak var passTf: UITextField!
    var passTfS : String = ""
    var confirmTFS : String = ""
    @IBOutlet weak var confirmTF: UITextField!
    
 
 
    lazy var viewModel: RegisterTeamVM = {
        return RegisterTeamVM()
    }()
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        initRegisterVM()
        self.phoneTF.delegate = self
        self.passTf.delegate = self
        self.confirmTF.delegate = self
        
     }
     
     
    
    
 
    func initRegisterVM () {
        viewModel.getDataClosure = {  [weak self] () in
            guard let self = self else {return}
            self.viewModel.phonenum = self.phoneTF.text!
            self.viewModel.pass = self.passTfS
            self.viewModel.passConfirme = self.confirmTFS
            self.viewModel.email = self.emailTF.text

        }
        
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
                let vc = VerfyCode()
                vc.phone = self.phoneTF.text!
                vc.type = .teamRegister
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                ad.killLoading()
            }
        }
        
        
        
        
    }
    
     
    @IBAction func createAccount(_ sender: Any) {
        //  self.viewModel.clint = self.niceClint.isSelected ? 1 : 2
        self.viewModel.phonenum = self.phoneTF.text!
        self.viewModel.pass = self.passTfS
        self.viewModel.passConfirme = self.confirmTFS
        self.viewModel.email = self.emailTF.text
        self.viewModel.name = self.nameTF.text
        
        guard ad.isOnline()else{return}
 
        viewModel.confirmRegister()
        
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        self.dismissViewC()
    }
    
}


extension RegisterTeamVC : UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        if textField == self.phoneTF {
            guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
                return false
            }
            return true
        }
        if textField == self.passTf {
            passTfS = passTfS+string
            if passTfS.count < 16 {
                passTf.text = textField.text!+"*"
                print("\(passTfS)")
                if let char = string.cString(using: String.Encoding.utf8) {
                    let isBackSpace = strcmp(char, "\\b")
                    if (isBackSpace == -92) {
                        print("Backspace was pressed")
                        self.passTf.text = ""
                        self.passTfS = ""
                    }
                    
                }
                return false
            }
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    print("Backspace was pressed")
                    self.passTf.text = ""
                    self.passTfS = ""
                }
                
            }
            
        }
        if textField == self.confirmTF {
            confirmTFS = confirmTFS+string
            if confirmTFS.count < 16 {
                confirmTF.text = textField.text!+"*"
                print("\(confirmTFS)")
                if let char = string.cString(using: String.Encoding.utf8) {
                    let isBackSpace = strcmp(char, "\\b")
                    if (isBackSpace == -92) {
                        print("Backspace was pressed")
                        self.confirmTF.text = ""
                        self.confirmTFS = ""
                    }
                    
                }
                return false
            }
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    print("Backspace was pressed")
                    self.confirmTF.text = ""
                    self.confirmTFS = ""
                }
                
            }
            
        }
        
        return true
    }
}

