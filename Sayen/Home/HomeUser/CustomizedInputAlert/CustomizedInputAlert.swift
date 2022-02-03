//
//  CustomizedAlert.swift
//  Wodaah
//
//  Created by Awab's Mac on 11/25/21.
//


import UIKit

class CustomizedInputAlert: UIViewController {
    
    @IBOutlet weak var buttonOutlet: UIButton!
    @IBOutlet weak var noteTextView: UITextView!
    
    weak var delegate : EmergancyVCDelegate?
    
    var alertMsg = ""
    var alertIcon = UIImage()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewDelegate()
        noteTextView.text = "alertNote".localized
    }
    
    @IBAction func agreeButton(_ sender: UIButton){
        delegate?.onDismissAlert(send: noteTextView.text ?? "")
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

        
extension CustomizedInputAlert : UITextViewDelegate{
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
    func onDismissAlert(send message: String)
}

