//
//  RegisterVC.swift
//  Sayen
//
//  Created by Maher on 5/31/20.
//  Copyright © 2020 maher. All rights reserved.
//

import UIKit
import DLRadioButton
import DropDown

class RegisterVC: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var passTf: UITextField!
    var passTfS : String = ""
    var confirmTFS : String = ""
    @IBOutlet weak var confirmTF: UITextField!
    
    @IBOutlet weak var niceClint: DLRadioButton!
    @IBOutlet weak var anotherClint: DLRadioButton!
    
    @IBOutlet weak var flatContainerV: UIStackView!
    @IBOutlet weak var flatNumberContainerV: UIStackView!
    @IBOutlet weak var flatNameContainerV: CardView!
    @IBOutlet weak var flatNameTF: UITextField!
    @IBOutlet weak var flatNumTF: UITextField!
    
    
    lazy var viewModel: RegisterVM = {
        return RegisterVM()
    }()
    let dropDown = DropDown()
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initRegisterVM()
        self.phoneTF.delegate = self
        self.passTf.delegate = self
        self.confirmTF.delegate = self
        
        flatContainerV.isHidden = true
        flatNumberContainerV.isHidden = true
        
        getBuildingNamesData()
    }
    
    func getBuildingNamesData() {
        
        
        viewModel.getBuildingsName { (status) in
            
            guard status else {
                 return
            }
            
            self.handleDropDown()
        }
    }
    
    private func handleDropDown() {
        dropDown.anchorView = flatNameContainerV // UIView or UIBarButtonItem
        dropDown.direction = .bottom
        dropDown.backgroundColor = UIColor.white
        dropDown.transform = CGAffineTransform(translationX: 0, y: 50).concatenating(CGAffineTransform(scaleX: 1, y: 0.9))

        var data = [String]()
        for x in viewModel.buildingData {
            data.append(x.name)
        }
        dropDown.dataSource = data
        
        
        flatNameContainerV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectFlatName)))
        
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.viewModel.selectedData = self.viewModel.buildingData[index]
            self.flatNameTF.text = item
                   }
    }
    
    
    @objc func selectFlatName() {
        
        dropDown.show()
    }
    
    func initRegisterVM () {
        viewModel.getDataClosure = {  [weak self] () in
            guard let self = self else {return}
            self.viewModel.userName = self.nameTF.text ?? ""
            self.viewModel.phonenum = self.phoneTF.text ?? ""
            self.viewModel.pass = self.passTfS
            self.viewModel.passConfirme = self.confirmTFS
            
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
                vc.type = .register
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                ad.killLoading()
            }
        }
        
        
        
        
    }
    
    
    @IBAction func vipClientHandler(_ sender: UIButton) {
   
        flatContainerV.isHidden = false
        flatNumberContainerV.isHidden = false
    }
    
    @IBAction func clientHandler(_ sender: UIButton) {
     
          flatContainerV.isHidden = true
          flatNumberContainerV.isHidden = true
      }
      
    
    @IBAction func createAccount(_ sender: Any) {
        //  self.viewModel.clint = self.niceClint.isSelected ? 1 : 2
        guard ad.isOnline()else{return}
        if self.niceClint.isSelected {
            self.viewModel.clint = 1
            viewModel.flatTitle = flatNameTF.text
            viewModel.flatNum = flatNumTF.text
            
         }else if self.anotherClint.isSelected {
            self.viewModel.clint = 2
        }else{
            self.viewModel.clint = 0
        }
        viewModel.confirmRegister()
        
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        self.dismissViewC()
    }
    
}


extension RegisterVC : UITextFieldDelegate {
    
    
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
