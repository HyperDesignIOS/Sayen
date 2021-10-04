//
//  LoginVC.swift
//  Sayen
//
//  Created by Maher on 5/31/20.
//  Copyright © 2020 maher. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    
    @IBOutlet weak var phoneTF: UITextField!
    
    @IBOutlet weak var passTF: UITextField!
     var password: String = ""
     lazy var viewModel: LoginVM = {
             return LoginVM()
         }()
    var tabBar : UITabBarController?
    var comeFromResetPass = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(Constants.current_Language,"-----------")
        passTF.delegate = self
        phoneTF.delegate = self
        initRegisterVM()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    
       
    }
    

    
    func initRegisterVM () {
        viewModel.getDataClosure = {  [weak self] () in
            guard let self = self else {return}
            self.viewModel.phonenum = self.phoneTF.text!
            self.viewModel.pass = self.password
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
                self.goToHome()
            case .verfy:
                ad.killLoading()
                self.showDAlert(title: "alert".localized, subTitle: "accountInactive".localized, type: .error , buttonTitle: "activate".localized) { (_) in
                    ad.isLoading()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        let vc = VerfyCode()
                        vc.phone = self.phoneTF.text!
                        self.navigationController?.pushViewController(vc, animated: true)
                        ad.killLoading()
                    }
                }
               
            }
        }
        
        
        
        
    }
    
    
    func goToHome(){
        let navController = UINavigationController()
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        guard let window = keyWindow else {return}
        let storyb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        tabBar = storyb.instantiateViewController(withIdentifier: "rootNav") as? UITabBarController
        navController.navigationBar.isHidden = true
        navController.viewControllers = [tabBar!]
        window.rootViewController = navController
        window.makeKeyAndVisible()
        
    }

    
    @IBAction func forgetPass(_ sender: Any) {
        let vc = ForgetPassVc()
        self.navigationController?.pushViewController(vc, animated: true)
      
    }
    @IBAction func loginAction(_ sender: Any) {
    
        guard ad.isOnline()else{return}
        viewModel.goAhead = "Gooooo"
        viewModel.initLogin()
    }
    @IBAction func registerAction(_ sender: Any) {
//        let vc = RegisterTeamVC()
        let vc = RegisterVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}



extension LoginVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        if textField == self.phoneTF {
        guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        return true
        }
        if textField == self.passTF {
   
        password = password+string
        if password.count < 16 {
        passTF.text = textField.text!+"*"
        print("\(password)")
        if let char = string.cString(using: String.Encoding.utf8) {
                      let isBackSpace = strcmp(char, "\\b")
                      if (isBackSpace == -92) {
                          print("Backspace was pressed")
                          self.passTF.text = ""
                          self.password = ""
                      }
                      
                      }
            return false
          }
            if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    print("Backspace was pressed")
                    self.passTF.text = ""
                    self.password = ""
                }
                
                }

        }
        
        return true
    }
    
}
