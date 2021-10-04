//
//  ForgetPassVc.swift
//  Sayen
//
//  Created by Maher on 5/31/20.
//  Copyright © 2020 maher. All rights reserved.
//

import UIKit

class ForgetPassVc: UIViewController {

    @IBOutlet weak var phoneTF: UITextField!
    lazy var viewModel : ForgetPassMV = {
        return ForgetPassMV()
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTF.delegate = self
        initViewModel()
 
    }
    
 

    var user_type : String {
        return ad.user_type()
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
                self.gotoVerfyPage()
            case .verfy:
                ad.killLoading()
            }
        }
        
    }
    
    func gotoVerfyPage () {
        DispatchQueue.main.async {
            let vc = VerfyCode()
            vc.phone = self.phoneTF.text!
            vc.type = .forgetPass
            self.navigationController?.pushViewController(vc, animated: true)

        }
        
    }

    
    @IBAction func dismiss(_ sender: Any) {
        self.dismissViewC()
    }
    
    @IBAction func sendCode(_ sender: Any) {
        self.view.endEditing(true)
        viewModel.phonenum = self.phoneTF.text
        viewModel.initForget(for : self.user_type)
    }
    
}



extension ForgetPassVc : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
     {
         
         if textField == self.phoneTF {
         guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
             return false
         }
         return true
         }
        return false
    }
}
