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
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var passTf: UITextField!
    @IBOutlet weak var confirmTF: UITextField!
    @IBOutlet weak var niceClint: DLRadioButton!
    @IBOutlet weak var anotherClint: DLRadioButton!
    @IBOutlet weak var flatContainerV: UIStackView!
    @IBOutlet weak var flatNumberContainerV: UIStackView!
    @IBOutlet weak var buildingNoContainerV: CardView!
    @IBOutlet weak var flatNoContainerV: CardView!
    @IBOutlet weak var buildingNoTF: UITextField!
    @IBOutlet weak var flatNumTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    
    var passTfS : String = ""
    var confirmTFS : String = ""
    
    lazy var viewModel: RegisterVM = {
        return RegisterVM()
    }()
    let buildingNoDropDown = DropDown()
    let flatNoDropDown = DropDown()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initRegisterVM()
        self.nameTF.delegate = self
        self.phoneTF.delegate = self
        self.passTf.delegate = self
        self.confirmTF.delegate = self
        self.emailTF.delegate = self
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
        buildingNoDropDown.anchorView = buildingNoContainerV // UIView or UIBarButtonItem
        buildingNoDropDown.direction = .bottom
        buildingNoDropDown.backgroundColor = UIColor.white
        buildingNoDropDown.transform = CGAffineTransform(translationX: 0, y: 50).concatenating(CGAffineTransform(scaleX: 1, y: 0.9))

        var data = [String]()
        var unitsArr = [String]()
        for x in viewModel.buildingData {
            data.append(x.name)
        }
        buildingNoDropDown.dataSource = data
        
        if "lang".localized == "ar" {
            buildingNoDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                cell.optionLabel.textAlignment = .right
            }
        }
        buildingNoContainerV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectFlatName)))
        
        
        buildingNoDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.viewModel.selectedData = self.viewModel.buildingData[index]
            unitsArr = self.viewModel.buildingData[index].units
            flatNoDropDown.dataSource = unitsArr
            flatNoDropDown.reloadAllComponents()
            self.buildingNoTF.text = item
            self.flatNumTF.text = ""
                   }
        
        
        flatNoDropDown.anchorView = flatNoContainerV // UIView or UIBarButtonItem
        flatNoDropDown.direction = .bottom
        flatNoDropDown.backgroundColor = UIColor.white
        flatNoDropDown.transform = CGAffineTransform(translationX: 0, y: 70).concatenating(CGAffineTransform(scaleX: 1, y: 0.9))

        if "lang".localized == "ar" {
            flatNoDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                cell.optionLabel.textAlignment = .right
            }
        }
        flatNoContainerV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectFlatNum)))
        //
        
        flatNoDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
         //   self.viewModel.selectedData = unitsArr[index]
            self.flatNumTF.text = item
        }
        }

        @objc func selectFlatNum() {
        flatNoDropDown.show()
        }

    
    
    @objc func selectFlatName() {
        
        buildingNoDropDown.show()
    }
    
    func initRegisterVM () {
        viewModel.getDataClosure = {  [weak self] () in
            guard let self = self else {return}
            self.viewModel.userName = self.nameTF.text ?? ""
            self.viewModel.userLastName = self.lastNameTF.text ?? ""
            self.viewModel.phonenum = self.phoneTF.text ?? ""
            self.viewModel.pass = self.passTfS
            self.viewModel.passConfirme = self.confirmTFS
            self.viewModel.email = self.emailTF.text ?? ""
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
            viewModel.flatTitle = buildingNoTF.text
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
        if textField == self.nameTF {
            let nubmers = "0123456789٠١٢٣٤٥٦٧٨٩"
            if nubmers.contains(string) {
                showDAlert(title: "Sorry".localized, subTitle: "userNameErrorMsg".localized, type: .error, buttonTitle: "Ok".localized) {_ in 
                    self.nameTF.text = ""
                }
                
            }
            return true
        }
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

