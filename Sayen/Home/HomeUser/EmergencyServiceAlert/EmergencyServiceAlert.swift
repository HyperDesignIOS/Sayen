//
//  CustomizedAlert.swift
//  Wodaah
//
//  Created by Awab's Mac on 11/25/21.
//


import UIKit
import DropDown
class EmergencyServiceAlert: UIViewController {
    
    @IBOutlet weak var buttonOutlet: UIButton!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var serviceDropDownAnchorView: UIView!
    @IBOutlet weak var reasonDropDownAnchorView: UIView!
    @IBOutlet weak var emergancyInfoLabel: UILabel!
    @IBOutlet weak var selectedReasonLabel: UILabel!
    
    weak var delegate : EmergancyVCDelegate?
    var services : [EmService] = []
    var selectedReasons: [EmReasons] = []
    let serviceDropDown = DropDown()
    let resonDropDown = DropDown()
    var alertMsg = ""
    var alertIcon = UIImage()
    var selectedServiceId = Int()
    var emergancyInfoText = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        handleDropDown()
//        textViewDelegate()
        noteTextView.text = "alertNote".localized
        emergancyInfoLabel.text = emergancyInfoText
    }
    
    @IBAction func agreeButton(_ sender: UIButton){
        if let reason = selectedReasonLabel.text, !reason.isEmpty  , selectedServiceId != 0{
            delegate?.onDismissAlert(send: reason, serviceId: selectedServiceId)
            self.dismissViewC()
        }
     
    }
    @IBAction func closeButtons(_ sender: UIButton){
        self.dismissViewC()
    }
    @IBAction func selectResonButtons(_ sender: UIButton){
        resonDropDown.show()
    }
//    private func textViewDelegate(){
//        noteTextView.delegate = self
//        noteTextView.returnKeyType = .done
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
    private func handleDropDown() {
        serviceDropDown.shadowColor  =  UIColor.black.withAlphaComponent(0.16)
        serviceDropDown.shadowRadius  = 2
        serviceDropDown.shadowOpacity  = 6
        serviceDropDown.shadowOffset  =  CGSize(width:3 ,height: 3 )
        serviceDropDown.backgroundColor = .white
        serviceDropDown.anchorView = serviceDropDownAnchorView
        let buttonHeight = serviceDropDown.anchorView?.plainView.bounds.height ?? 0
        serviceDropDown.bottomOffset = CGPoint(x: 0, y:buttonHeight)
        serviceDropDown.direction = .bottom
        serviceDropDown.textFont = UIFont.init(name: "Tajawal", size: 12) ?? UIFont.systemFont(ofSize: 18)
        var data = [String]()
        for x in services {
            data.append(x.title)
        }
        serviceDropDown.dataSource = data
        
        
        if "lang".localized == "ar" {
            serviceDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                cell.optionLabel.textAlignment = .right
            }
        }
     
        var datax = [String]()
        serviceDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.selectedServiceId = self.services[index].id
            self.serviceLabel.text = item
            self.selectedReasons = self.services[index].reasons
            self.selectedReasonLabel.text = ""
            datax.removeAll()
            for x in selectedReasons {
                datax.append(x.reason ?? "")
            }
            resonDropDown.dataSource = datax
        }
        
        
//
        resonDropDown.shadowColor  =  UIColor.black.withAlphaComponent(0.16)
        resonDropDown.shadowRadius  = 2
        resonDropDown.shadowOpacity  = 6
        resonDropDown.shadowOffset  =  CGSize(width:3 ,height: 3 )
        resonDropDown.backgroundColor = .white
        resonDropDown.anchorView = reasonDropDownAnchorView
        let buttonHeightx = resonDropDown.anchorView?.plainView.bounds.height ?? 0
        resonDropDown.bottomOffset = CGPoint(x: 0, y:buttonHeightx)
        resonDropDown.direction = .bottom
        resonDropDown.textFont = UIFont.init(name: "Tajawal", size: 12) ?? UIFont.systemFont(ofSize: 18)
        
      


        if "lang".localized == "ar" {
            resonDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                cell.optionLabel.textAlignment = .right
            }
        }


        resonDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
//            self.selectedServiceId = self.services[index].id
            self.selectedReasonLabel.text = item
        }
        
        
    }
    
    @IBAction func selectServiceButton(_ sender: UIButton){
        serviceDropDown.show()
    }
    
//    @objc func keyboardWillShow(notification: NSNotification){
//        guard  let userInfo = notification.userInfo else {return}
//        guard  let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
//        let keyboardFram = keyboardSize.cgRectValue
//        if self.view.frame.origin.y == 0 {
//            self.view.frame.origin.y -= keyboardFram.height - 100
//        }
//    }
//
//    @objc func keyboardWillHide(){
//        if self.view.frame.origin.y != 0 {
//            self.view.frame.origin.y = 0
//        }
//    }
}

        
//extension EmergencyServiceAlert : UITextViewDelegate{
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if noteTextView.textColor == UIColor.lightGray {
//            noteTextView.text = ""
//            noteTextView.textColor = UIColor.black
//        }
//    }
//
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        return false
//    }
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//           if(text == "\n") {
//               textView.resignFirstResponder()
//               return false
//           }
//           return true
//       }
//
//}



protocol EmergancyVCDelegate: NSObjectProtocol {
    func onDismissAlert(send message: String, serviceId: Int)
}

