//
//  ChangePassVC.swift
//  Sayen 
//
//  Created by Maher on 6/4/20.
//

import UIKit

class ChangePassVC: UIViewController {
    
    @IBOutlet weak var oldPassTF: UITextField!
    @IBOutlet weak var newPassTf: UITextField!
    @IBOutlet weak var confirmPassTF: UITextField!
    var oldPassTFS : String = ""
    var newPassTfS : String = ""
    var confirmPassTFS : String = ""
    var user_type : String {
        return ad.user_type()
    }
    lazy var viewModel : ChangePassVM = {
        return ChangePassVM()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.oldPassTF.delegate = self
        self.newPassTf.delegate = self
        self.confirmPassTF.delegate = self
        initViewModel()
        
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

                        DispatchQueue.main.async {
                                  
                            self.showDAlert(title: "thanks".localized, subTitle: "passwordChanged".localized, type: .success, buttonTitle: "") { (_) in
                                self.goToMenu()
                            }
                           }
                    
                }
               
            case .verfy:
                ad.killLoading()
            }
        }
        
    }
    var tabBar : UITabBarController?
    func goToMenu(){
             let navController = UINavigationController()
             let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
             guard let window = keyWindow else {return}
             let storyb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
             tabBar = storyb.instantiateViewController(withIdentifier: "rootNav") as? UITabBarController
             navController.navigationBar.isHidden = true
             tabBar?.selectedIndex = 3
             navController.viewControllers = [tabBar!]
             window.rootViewController = navController
             window.makeKeyAndVisible()
             
         }
    
    
    func resetAction () {
        viewModel.oldPass = self.oldPassTFS
        viewModel.pass = self.newPassTfS
        viewModel.confirmPass = self.confirmPassTFS
        viewModel.initForget(for: self.user_type)
    
    }
    
    
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismissViewC()
    }
    
    @IBAction func saveChange(_ sender: Any) {
        resetAction()
    }
}



extension ChangePassVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
     {
         
         
          
           if textField == self.oldPassTF {
               oldPassTFS = oldPassTFS+string
               if oldPassTFS.count < 16 {
                   oldPassTF.text = textField.text!+"*"
                   print("\(oldPassTFS)")
                   if let char = string.cString(using: String.Encoding.utf8) {
                       let isBackSpace = strcmp(char, "\\b")
                       if (isBackSpace == -92) {
                           print("Backspace was pressed")
                           self.oldPassTF.text = ""
                           self.oldPassTFS = ""
                       }
                       
                   }
                   return false
               }
               if let char = string.cString(using: String.Encoding.utf8) {
                   let isBackSpace = strcmp(char, "\\b")
                   if (isBackSpace == -92) {
                       print("Backspace was pressed")
                       self.oldPassTF.text = ""
                       self.oldPassTFS = ""
                   }
                   
               }
               
           }
           
        if textField == self.newPassTf {
                   newPassTfS = newPassTfS+string
                   if newPassTfS.count < 16 {
                       newPassTf.text = textField.text!+"*"
                       print("\(newPassTfS)")
                       if let char = string.cString(using: String.Encoding.utf8) {
                           let isBackSpace = strcmp(char, "\\b")
                           if (isBackSpace == -92) {
                               print("Backspace was pressed")
                               self.newPassTf.text = ""
                               self.newPassTfS = ""
                           }
                           
                       }
                       return false
                   }
                   if let char = string.cString(using: String.Encoding.utf8) {
                       let isBackSpace = strcmp(char, "\\b")
                       if (isBackSpace == -92) {
                           print("Backspace was pressed")
                           self.newPassTf.text = ""
                           self.newPassTfS = ""
                       }
                       
                   }
                   
               }

       if textField == self.confirmPassTF {
                  confirmPassTFS = confirmPassTFS+string
                  if confirmPassTFS.count < 16 {
                      confirmPassTF.text = textField.text!+"*"
                      print("\(confirmPassTFS)")
                      if let char = string.cString(using: String.Encoding.utf8) {
                          let isBackSpace = strcmp(char, "\\b")
                          if (isBackSpace == -92) {
                              print("Backspace was pressed")
                              self.confirmPassTF.text = ""
                              self.confirmPassTFS = ""
                          }
                          
                      }
                      return false
                  }
                  if let char = string.cString(using: String.Encoding.utf8) {
                      let isBackSpace = strcmp(char, "\\b")
                      if (isBackSpace == -92) {
                          print("Backspace was pressed")
                          self.confirmPassTF.text = ""
                          self.confirmPassTFS = ""
                      }
                      
                  }
                  
              }

        

        return true
    }
}
