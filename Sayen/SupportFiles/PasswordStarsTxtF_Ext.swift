////
////  PasswordStarsTxtF_Ext.swift
////  Takaful
////
////  Created by Eslam Abo El Fetouh on 4/28/20.
////  Copyright © 2020 Eslam Abo El Fetouh. All rights reserved.
////
//
//import Foundation
//import UIKit
//import Bond
//
//
//
//extension UITextField {
//    func convertTxtToStars(passwordText: inout Observable<String>,securePassword:Bool, textField:UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        self.isSecureTextEntry = false
//           var hashPassword = String()
//          let newChar = string.first
//          let offsetToUpdate = passwordText.value.index(passwordText.value.startIndex, offsetBy: range.location)
//
//          if string == "" {
//              passwordText.value.remove(at: offsetToUpdate)
//              return true
//          }
//          else { passwordText.value.insert(newChar!, at: offsetToUpdate) }
//          if  securePassword {
//          for _ in 0..<passwordText.value.count {  hashPassword += "٭" }
//           textField.text = hashPassword
//
//          return false
//          }else {
//
//              return true
//          }
//      }
//}
//
//
//class PasswordContainerV : CardView, UITextFieldDelegate {
//
//
//      var passwordText = Observable<String>("")
//    var securePassword = true
//
//
//
//    @IBInspectable var localized_phCode : String = "" {
//        didSet {
//            self.passTxtF.placeholder = localized_phCode.localized
//            self.passTxtF.setupPlaceHolderUI()
//            self.passTxtF.textAlignment = Constants.current_Language == "ar" ? .right : .left
//        }
//    }
//
//    @IBInspectable var textColor : UIColor = UIColor.black {
//        didSet {
//            self.passTxtF.textColor = textColor
//        }
//    }
//    @IBInspectable var background_color : UIColor = UIColor.white {
//        didSet {
//            self.backgroundColor = background_color
//        }
//    }
//
//    @IBInspectable var editingBg_color : UIColor = UIColor.d_lightGray
//
//
//    public let passTxtF = PassTextField()
//
//   private  var showPassImgV = UIImageView()
//    var actBtn = UIButton()
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        passTxtF.isSecureTextEntry = false
//        passTxtF.delegate = self
//        passTxtF.tintColor = UIColor.d_darkBlue
//        passTxtF.smartInsertDeleteType = UITextSmartInsertDeleteType.no
////        passTxtF.font = UIFont.systemFont(ofSize: 15)
//        passTxtF.keyboardType = .asciiCapable
//        setupUI()
//    }
//
//
//
//
//    func setupUI() {
//
//        actBtn.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(actBtn)
//         actBtn.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        actBtn.widthAnchor.constraint(equalToConstant: 48).isActive = true
//        actBtn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 8).isActive = true
//        actBtn.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
//        actBtn.backgroundColor = .clear
//        actBtn.addTarget(self, action: #selector(showPassword(_:)), for: .touchUpInside)
//
//        showPassImgV.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(showPassImgV)
//        showPassImgV.isUserInteractionEnabled = false
//        showPassImgV.image = UIImage(named: "view")
//        showPassImgV.contentMode = .scaleAspectFit
//        showPassImgV.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 3).isActive = true
//        showPassImgV.widthAnchor.constraint(equalToConstant: 25).isActive = true
//        showPassImgV.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
//        showPassImgV.heightAnchor.constraint(equalToConstant: 25).isActive = true
//
//
//        passTxtF.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(passTxtF)
//        passTxtF.delegate = self
//        passTxtF.autocorrectionType = .no
//        passTxtF.autocapitalizationType = .none
//
//        passTxtF.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15).isActive = true
//        passTxtF.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -48).isActive = true
//        passTxtF.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
//        passTxtF.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 3).isActive = true
//        passTxtF.textAlignment = Constants.current_Language == "ar" ? .right : .left
//        passTxtF.tintColor = UIColor.d_darkBlue
//
//     }
//
//
//
//    @objc func showPassword(_ sender : UIButton) {
//
//        guard showPassImgV.image == UIImage(named: "view-active") else {
//
//            showPassImgV.image = UIImage(named: "view-active")
//            //            self.passTxtF.isSecureTextEntry = false
//            passTxtF.text = passwordText.value
//            self.securePassword = false
//            return
//        }
//
//        showPassImgV.image = UIImage(named: "view")
//        //        self.passTxtF.isSecureTextEntry = true
//        let securedText = String(passwordText.value.map { _ in  "٭"    })
//        passTxtF.text = securedText
//        self.securePassword = true
//
//
//    }
//
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        self.backgroundColor = editingBg_color
//        return true
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        self.backgroundColor = background_color
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard let textFieldText = textField.text,
//            let rangeOfTextToReplace = Range(range, in: textFieldText) , string != " " else {
//                return false
//        }
//        let substringToReplace = textFieldText[rangeOfTextToReplace]
//        let count = textFieldText.count - substringToReplace.count + string.count
//
//        guard count <= 15 else  { return false }
//            var hashPassword = String()
//              let newChar = string.first
//              let offsetToUpdate = passwordText.value.index(passwordText.value.startIndex, offsetBy: range.location)
//
//              if string == "" {
//                  passwordText.value.remove(at: offsetToUpdate)
//                  return true
//              }
//              else { passwordText.value.insert(newChar!, at: offsetToUpdate) }
//              if  securePassword {
//              for _ in 0..<passwordText.value.count {  hashPassword += "٭" }
//               textField.text = hashPassword
//
//              return false
//              }else {
//
//                  return true
//              }
//    }
//
//
//
//
//}
//
//  class PassTextField : UITextField {
//
//
////       override  func caretRect(for position: UITextPosition) -> CGRect {
////           return CGRect.zero
////       }
////
////
//      override   func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
//           return []
//       }
//
//
//    override public func deleteBackward() {
//
//
//        // do something for every backspace
////        super.deleteBackward()
//        guard text?.count ?? 0 >= 1 else { return }
//        text?.removeLast()
//
//    }
//
//
//       override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//           if action == #selector(UIResponderStandardEditActions.paste(_:)) || action ==  #selector(UIResponderStandardEditActions.selectAll(_:)) || action ==  #selector(UIResponderStandardEditActions.copy(_:)) || action ==  #selector(UIResponderStandardEditActions.cut(_:)) ||  action ==  #selector(UIResponderStandardEditActions.delete(_:)){
//               return false
//           }
//            return super.canPerformAction(action, withSender: sender)
//       }
//}
