//
//  CardView.swift
//  Eyas
//
//  Created by emad ios on 12/12/18.
//  Copyright © 2018 emad ios. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CardViewWithOutRound: UIView {
    
    
    override func layoutSubviews() {
        // corner radius
        self.layer.cornerRadius = 0
        
        // shadow
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 3
        self.layer.shadowRadius = 3
     //   self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 0).cgPath
     //   self.layer.shouldRasterize = true
      //  self.layer.rasterizationScale = UIScreen.main.scale
        
    }
    
}
@IBDesignable
class CardView: UIView {
    
    
    override func layoutSubviews() {
        // corner radius
        self.layer.cornerRadius = 12
        
        // shadow
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3
        overrideUserInterfaceStyle = .light
     //   self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 15).cgPath
     //   self.layer.shouldRasterize = true
      //  self.layer.rasterizationScale = UIScreen.main.scale
        
    }
    
}
@IBDesignable
class CardView1: UIView {
    
    
    override func layoutSubviews() {
        // corner radius
        self.layer.cornerRadius = 12
        
        self.layer.borderColor = UIColor.brownMainColor.cgColor
        self.layer.borderWidth = 1
        
        
    }
    
}
@IBDesignable
class CardView2: UIView {
    override func layoutSubviews() {
        // corner radius
        self.layer.cornerRadius = 12
        
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        
        
    }
    
}

@IBDesignable
class NavView: UIView {
    
    
    override func layoutSubviews() {
        // corner radius
 
        // shadow
        self.layer.shadowColor = #colorLiteral(red: 0.8822566867, green: 0.8824083209, blue: 0.8822471499, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 0, height: 1.3)
        self.layer.shadowOpacity = 3
        self.layer.shadowRadius = 0.5
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 15).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
    
}
class RoundShadowView: UIView {
    
    private var shadowLayer: CAShapeLayer!
    @IBInspectable var corner_Radius: CGFloat = 25
    @IBInspectable var borderColor: UIColor = UIColor.mainColor

    private var fillColor: UIColor = .clear // the color applied to the shadowLayer, rather than the view's backgroundColor
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
//            self.clipsToBounds = true
//            self.layer.shadowColor = #colorLiteral(red: 0.9607843137, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
//            self.layer.shadowOpacity = 5
//            self.layer.shadowOffset = CGSize(width: 1, height: 4)
//            self.layer.shadowRadius = 5
//            self.layer.cornerRadius = corner_Radius
//            self.layer.masksToBounds = false
            self.layer.cornerRadius = corner_Radius
            self.clipsToBounds = true

            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds,
                  cornerRadius: self.layer.cornerRadius).cgPath
            self.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
            self.layer.shadowOpacity = 0.4
            self.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.layer.shadowRadius = 1
            self.layer.masksToBounds = false

            
            self.layer.borderColor = borderColor.cgColor
            self.layer.borderWidth = 2
      
        }else {
            
             self.layer.shadowPath =
                  UIBezierPath(roundedRect: self.bounds,
                  cornerRadius: self.layer.cornerRadius).cgPath

            
        }
    }
}
 

class RoundShadowV : UIView {
    
    private var shadowLayer: CAShapeLayer!
    @IBInspectable var corner_Radius: CGFloat = 25
    @IBInspectable var borderColor: UIColor = UIColor.mainColor

    private var fillColor: UIColor = .clear // the color applied to the shadowLayer, rather than the view's backgroundColor
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
              shadowLayer = CAShapeLayer()
            self.addShadow(shadowColor: .black, offSet: CGSize(width: 0, height: 3.6), opacity: 0.4, shadowRadius: 5.0, cornerRadius: corner_Radius, corners: [.allCorners], fillColor: .clear)
//            shadowLayer = CAShapeLayer()
//            self.clipsToBounds = true
//            self.layer.shadowColor = #colorLiteral(red: 0.9607843137, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
//            self.layer.shadowOpacity = 5
//            self.layer.shadowOffset = CGSize(width: 1, height: 4)
//            self.layer.shadowRadius = 5
//            self.layer.cornerRadius = corner_Radius
//            self.layer.masksToBounds = false
//
//            self.layer.borderColor = borderColor.cgColor
//            self.layer.borderWidth = 2
        }
    }
}



extension UIView {
    
    func addShadow(shadowColor: UIColor, offSet: CGSize, opacity: Float, shadowRadius: CGFloat, cornerRadius: CGFloat, corners: UIRectCorner, fillColor: UIColor = .clear) {
        
        let shadowLayer = CAShapeLayer()
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let cgPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size).cgPath //1
        shadowLayer.path = cgPath //2
        shadowLayer.fillColor = fillColor.cgColor //3
        shadowLayer.shadowColor = shadowColor.cgColor //4
        shadowLayer.shadowPath = cgPath
        shadowLayer.shadowOffset = offSet //5
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = shadowRadius
        shadowLayer.zPosition = -1
        self.layer.addSublayer(shadowLayer)
        
    }
}


class ShadowView: UIView {
    
    private var shadowLayer: CAShapeLayer!
    //    @IBInspectable var cornerRadius: CGFloat = 0
    private var fillColor: UIColor = .clear // the color applied to the shadowLayer, rather than the view's backgroundColor
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            self.clipsToBounds = true
            self.layer.shadowColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            self.layer.shadowOpacity = 5
            self.layer.shadowOffset = CGSize(width: 1, height: 1)
            self.layer.shadowRadius = 5
            self.layer.cornerRadius = 0
            self.layer.masksToBounds = false
        }
    }
}



//@IBDesignable
//class EyasButton: UIButton {
//    @IBInspectable var cornerRadius: CGFloat = 1
//    override func layoutSubviews() {
//
//        super.layoutSubviews()
//        layer.masksToBounds = false
//        layer.cornerRadius = self.cornerRadius
//    }
//}




@IBDesignable
class KhadTextField: UITextField ,UITextFieldDelegate {

   
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }

    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        
        // your setup...
        self.delegate = self
     //   setMaxLength()
      
        
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
        
        let paddingView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = UITextField.ViewMode.always
        
        let rightPaddingView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 15, height: self.frame.height))
        self.rightView = rightPaddingView
        self.rightViewMode = UITextField.ViewMode.always


    }
    
    
    
    
    @IBInspectable var maximumCharacters: Int = 80
//    @IBInspectable var preventZero: Bool = false
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        
        return newLength <= self.maximumCharacters
    }
   
    
  

}




@IBDesignable
class EyasTextField: UITextField ,UITextFieldDelegate{
    
    
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        
        // your setup...
        self.delegate = self
        setMaxLength()
        
        
    }
    
    @IBInspectable var maximumCharacters: Int = 80
    //    @IBInspectable var preventZero: Bool = false
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        
        return newLength <= self.maximumCharacters
    }
    
    
    private func setMaxLength() {
        addTarget(self, action: #selector(textfieldChanged(_:)), for: UIControl.Event.editingChanged)
    }
    
    @objc private func textfieldChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if self.keyboardType == .emailAddress
        {
            self.maximumCharacters = 50
            if text.isEmail {
                self.leftImage = #imageLiteral(resourceName: "cheack")
            }else{
                self.leftImage = #imageLiteral(resourceName: "uncheack")
            }
        }
        else if self.keyboardType == .asciiCapableNumberPad{
            if self.maximumCharacters == 6 { // price
                if let intPrice = Int(text) , intPrice > 0 {
                    self.leftImage = #imageLiteral(resourceName: "cheack")
                }else{
                    self.leftImage = #imageLiteral(resourceName: "uncheack")
                }
            }
            else if self.maximumCharacters == 15 {
                if text.count >= 6 {
                    self.leftImage = #imageLiteral(resourceName: "cheack")
                }else{
                    self.leftImage = #imageLiteral(resourceName: "uncheack")
                }
            }
            else if self.maximumCharacters == 10 { // nationaliyID
                if text.count == 10 {
                    self.leftImage = #imageLiteral(resourceName: "cheack")
                }else{
                    self.leftImage = #imageLiteral(resourceName: "uncheack")
                }
            }
            else if self.maximumCharacters == 16 { // bank card
                if text.count >= 14 {
                    self.leftImage = #imageLiteral(resourceName: "cheack")
                }else{
                    self.leftImage = #imageLiteral(resourceName: "uncheack")
                }
            }
            else if self.maximumCharacters == 3 { // bank card
                if text.count == 3 {
                    self.leftImage = #imageLiteral(resourceName: "cheack")
                }else{
                    self.leftImage = #imageLiteral(resourceName: "uncheack")
                }
            }
            else{
                //                self.maximumCharacters = 13
                if text.isValidPhoneNumber {
                    self.leftImage = #imageLiteral(resourceName: "cheack")
                }else{
                    self.leftImage = #imageLiteral(resourceName: "uncheack")
                }
            }
        }
        else if self.keyboardType == .default {
            if self.maximumCharacters > 20 {
                if text.count >= 3 {
                    self.leftImage = #imageLiteral(resourceName: "cheack")
                }else{
                    self.leftImage = #imageLiteral(resourceName: "uncheack")
                }
            }
            else if self.maximumCharacters == 15 { // pass
                if text.isValidPassword {
                    self.leftImage = #imageLiteral(resourceName: "cheack")
                }else{
                    self.leftImage = #imageLiteral(resourceName: "uncheack")
                }
            }
            else if self.maximumCharacters == 14 { // رقم الهوية
                if text.count >= 6 {
                    self.leftImage = #imageLiteral(resourceName: "cheack")
                }else{
                    self.leftImage = #imageLiteral(resourceName: "uncheack")
                }
            }
            else if self.maximumCharacters == 10 { 
                if text.count >= 10 {
                    self.leftImage = #imageLiteral(resourceName: "cheack")
                }else{
                    self.leftImage = #imageLiteral(resourceName: "uncheack")
                }
            }
        }
    }
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 5
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
    
    
    
}

extension UITextView {
    
    private class PlaceholderLabel: UILabel { }
    
    private var placeholderLabel: PlaceholderLabel {
        if let label = subviews.compactMap( { $0 as? PlaceholderLabel }).first {
            return label
        } else {
            let label = PlaceholderLabel(frame: .zero)
            label.font = font
            addSubview(label)
            return label
        }
    }
    
    @IBInspectable
    var placeholder: String {
        get {
            return subviews.compactMap( { $0 as? PlaceholderLabel }).first?.text ?? ""
        }
        set {
            let placeholderLabel = self.placeholderLabel
            placeholderLabel.text = newValue
            placeholderLabel.textAlignment = .right
            placeholderLabel.textColor = UIColor.lightGray
            placeholderLabel.numberOfLines = 0
            let width = frame.width - textContainer.lineFragmentPadding * 2
            let size = placeholderLabel.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
            placeholderLabel.frame.size.height = size.height
            placeholderLabel.frame.size.width = width
            placeholderLabel.frame.origin = CGPoint(x: textContainer.lineFragmentPadding, y: textContainerInset.top)
            
            textStorage.delegate = self
        }
    }
    
}

extension UITextView: NSTextStorageDelegate {
    
    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
        if editedMask.contains(.editedCharacters) {
            placeholderLabel.isHidden = !text.isEmpty
        }
    }
    
}

class PlaceholderTextView: UITextView {
    
    @IBInspectable var placeholderColor: UIColor = UIColor.lightGray
    @IBInspectable var placeholderText: String = ""
    
    override var font: UIFont? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override var contentInset: UIEdgeInsets {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override var textAlignment: NSTextAlignment {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override var text: String? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override var attributedText: NSAttributedString? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    private func setUp() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.textChanged(notification:)),
                                               name: Notification.Name("UITextViewTextDidChangeNotification"),
                                               object: nil)
    }
    
    @objc func textChanged(notification: NSNotification) {
        setNeedsDisplay()
    }
    
    func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        var x = contentInset.left + 4.0
        var y = contentInset.top  + 9.0
        let w = frame.size.width - contentInset.left - contentInset.right - 16.0
        let h = frame.size.height - contentInset.top - contentInset.bottom - 16.0
        
        if let style = self.typingAttributes[NSAttributedString.Key.paragraphStyle] as? NSParagraphStyle {
            x += style.headIndent
            y += style.firstLineHeadIndent
        }
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    override func draw(_ rect: CGRect) {
        if text!.isEmpty && !placeholderText.isEmpty {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = textAlignment
            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue) : font!,
                NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue) : placeholderColor,
                NSAttributedString.Key(rawValue: NSAttributedString.Key.paragraphStyle.rawValue)  : paragraphStyle]
            
            placeholderText.draw(in: placeholderRectForBounds(bounds: bounds), withAttributes: attributes)
        }
        super.draw(rect)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

import AVFoundation

extension UIImage {
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
    
//    func showImage(){
//        let imageInfo   = GSImageInfo(image: self, imageMode: .aspectFit)
//        let imageViewer = GSImageViewerController(imageInfo: imageInfo)
//        ad.Push(vc: imageViewer)
//
//    }
    
    

 
        func resized(withPercentage percentage: CGFloat) -> UIImage? {
            let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
            UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
            defer { UIGraphicsEndImageContext() }
            draw(in: CGRect(origin: .zero, size: canvasSize))
            return UIGraphicsGetImageFromCurrentImageContext()
        }
        func resized(toWidth width: CGFloat) -> UIImage? {
            let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
            UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
            defer { UIGraphicsEndImageContext() }
            draw(in: CGRect(origin: .zero, size: canvasSize))
            return UIGraphicsGetImageFromCurrentImageContext()
        }
        
        
        
        func resizeImageWith(newSize: CGSize) -> UIImage {
            
            let horizontalRatio = newSize.width / size.width
            let verticalRatio = newSize.height / size.height
            
            let ratio = max(horizontalRatio, verticalRatio)
            let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
            UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
            draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage!
        }
        
    }


import Foundation

//@IBDesignable
class PaddedLabel: UILabel {
    
    var inset:CGSize = CGSize(width: 0, height: 0)
    
    var padding: UIEdgeInsets {
        var hasText:Bool = false
        if let t = self.text?.count, t > 0 {
            hasText = true
        }
        else if let t = attributedText?.length, t > 0 {
            hasText = true
        }
        
        return hasText ? UIEdgeInsets(top: inset.height, left: 5, bottom: inset.height, right: 5) : UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        let superContentSize = super.intrinsicContentSize
        let p = padding
        let width = superContentSize.width + p.left + p.right
        let heigth = superContentSize.height + p.top + p.bottom
        return CGSize(width: width, height: heigth)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let p = padding
        let width = superSizeThatFits.width + p.left + p.right
        let heigth = superSizeThatFits.height + p.top + p.bottom
        return CGSize(width: width, height: heigth)
    }
}




extension UISegmentedControl
{
    func defaultConfiguration(font: UIFont = UIFont.systemFont(ofSize: 12), color: UIColor = UIColor.white)
    {
        let defaultAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
        setTitleTextAttributes(defaultAttributes, for: .normal)
    }

    func selectedConfiguration(font: UIFont = UIFont.boldSystemFont(ofSize: 12), color: UIColor = UIColor.red)
    {
        let selectedAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
        setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}
