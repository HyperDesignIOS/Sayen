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
    @IBOutlet weak var dropDownAnchorView: UIView!
    
    weak var delegate : EmergancyVCDelegate?
    var services : [HomeData] = []
    let dropDown = DropDown()
    var alertMsg = ""
    var alertIcon = UIImage()
    var selectedServiceId = Int()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        handleDropDown()
        textViewDelegate()
        noteTextView.text = "alertNote".localized
    }
    
    @IBAction func agreeButton(_ sender: UIButton){
        delegate?.onDismissAlert(send: noteTextView.text ?? "", serviceId: selectedServiceId)
        self.dismissViewC()
    }
    @IBAction func closeButtons(_ sender: UIButton){
        self.dismissViewC()
    }
    
    private func textViewDelegate(){
        noteTextView.delegate = self
        noteTextView.returnKeyType = .done
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func handleDropDown() {
        
        
        dropDown.shadowColor  =  UIColor.black.withAlphaComponent(0.16)
        dropDown.shadowRadius  = 2
        dropDown.shadowOpacity  = 6
        dropDown.shadowOffset  =  CGSize(width:3 ,height: 3 )
        dropDown.backgroundColor = .white
        dropDown.anchorView = dropDownAnchorView
        let buttonHeight = dropDown.anchorView?.plainView.bounds.height ?? 0
        dropDown.bottomOffset = CGPoint(x: 0, y:buttonHeight)
        dropDown.direction = .bottom
        dropDown.textFont = UIFont.init(name: "Tajawal", size: 12) ?? UIFont.systemFont(ofSize: 18)
        var data = [String]()
        for x in services {
            data.append(x.name)
        }
        dropDown.dataSource = data
        
        
        if "lang".localized == "ar" {
            dropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                cell.optionLabel.textAlignment = .right
            }
        }
     
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.selectedServiceId = self.services[index].id
            self.serviceLabel.text = item
        }
    }
    
    @IBAction func selectServiceButton(_ sender: UIButton){
        dropDown.show()
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        guard  let userInfo = notification.userInfo else {return}
        guard  let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFram = keyboardSize.cgRectValue
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardFram.height - 100
        }
    }
    
    @objc func keyboardWillHide(){
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

        
extension EmergencyServiceAlert : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if noteTextView.textColor == UIColor.lightGray {
            noteTextView.text = ""
            noteTextView.textColor = UIColor.black
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
           if(text == "\n") {
               textView.resignFirstResponder()
               return false
           }
           return true
       }

}



protocol EmergancyVCDelegate: NSObjectProtocol {
    func onDismissAlert(send message: String, serviceId: Int)
}

