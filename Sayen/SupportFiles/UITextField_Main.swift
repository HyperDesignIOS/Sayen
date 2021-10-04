////
////  UITextField_Main.swift
////  Takaful
////
////  Created by Eslam Abo El Fetouh on 5/7/20.
////  Copyright © 2020 Eslam Abo El Fetouh. All rights reserved.
////
//
//import UIKit
//
//class UITextField_Main: CardView  , UITextFieldDelegate {
//
//    @IBOutlet weak var containerView: UIView!
//    @IBOutlet weak var phoneKeyLbl: UILabel!
//    @IBOutlet weak var textField: UITextField!
//    @IBOutlet weak var phoneKeyContainerV: UIView!
//
//
//    @IBInspectable var isPhoneNum : Bool = true {
//        didSet {
//            updateView()
//        }
//    }
//
//    @IBInspectable var phoneKey : String = "+966" {
//        didSet {
//            updateView()
//        }
//    }
//    
//    @IBInspectable var localized_phCode : String = "" {
//        didSet {
//            self.textField.placeholder = localized_phCode.localized
//            self.textField.setupPlaceHolderUI()
//            self.textField.textAlignment = Constants.current_Language == "ar" ? .right : .left
//        }
//    }
//    @IBInspectable var textColor : UIColor = UIColor.black {
//        didSet {
//            self.textField.textColor = textColor
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
//
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        setupXib()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//
//        setupXib()
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        self.containerView.frame = bounds
//    }
//
//    func setupXib() {
//        let bundle = Bundle(for: type(of: self))
//        let nibName = type(of: self).description().components(separatedBy: ".").last!
//        let nib = UINib(nibName: nibName, bundle: bundle)
//
//        // 1. Load the nib
//        self.containerView = nib.instantiate(withOwner: self, options: nil).first as? UIView
//
//        // 2. Set the bounds for the container view
//        self.containerView.frame = bounds
//        self.containerView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
//
//        // 3. Add this container view as the subview
//        addSubview(containerView)
//
//        self.textField.delegate = self
//        updateView()
//    }
//
//    func updateView() {
//        self.textField.text = localized_phCode.localized
//        self.phoneKeyContainerV.isHidden = !self.isPhoneNum
//        self.phoneKeyLbl.text = self.phoneKey
//
//
//    }
//
//
//
//
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        containerView.backgroundColor = editingBg_color
//        return true
//    }
//
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        containerView.backgroundColor = background_color
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//        if  isPhoneNum   {
//            return string.rangeOfCharacter(from: CharacterSet.letters) == nil
//        }
//
//
//        return true
//    }
//
//
//}
import UIKit

class NMTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) || action == #selector(UIResponderStandardEditActions.copy(_:)) || action ==  #selector(UIResponderStandardEditActions.cut(_:))  {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }

}

class NMTextFieldPast: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }

}


import UIKit
private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        if let t = textField.text {
            textField.text = String(t.prefix(maxLength))
        }
    }
}



extension UILabel {
    func setLineHeight(lineHeight: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = self.textAlignment

        let attrString = NSMutableAttributedString()
        if (self.attributedText != nil) {
            attrString.append( self.attributedText!)
        } else {
            attrString.append( NSMutableAttributedString(string: self.text!))
            attrString.addAttribute(NSAttributedString.Key.font, value: self.font!, range: NSMakeRange(0, attrString.length))
        }
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
}
