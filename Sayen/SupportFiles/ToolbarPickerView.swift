//
//  ToolbarPickerView.swift
//  Faz3a
//
//  Created by Eslam Abo El Fetouh on 3/15/20.
//  Copyright © 2020 admin. All rights reserved.
//
import Foundation
import UIKit

protocol ToolbarPickerViewDelegate: class {
    func didTapDone()
    func didTapCancel()
}

class ToolbarPickerView: UIPickerView {

    public private(set) var toolbar: UIToolbar?
    public weak var toolbarDelegate: ToolbarPickerViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    private func commonInit() {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: L0S.ok.message(), style: .plain, target: self, action: #selector(self.doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: L0S.cancel.message(), style: .plain, target: self, action: #selector(self.cancelTapped))

        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        self.toolbar = toolBar
    }

    @objc func doneTapped() {
        self.toolbarDelegate?.didTapDone()
    }

    @objc func cancelTapped() {
        self.toolbarDelegate?.didTapCancel()
    }
}
/*
 

 extension ProductVC : UIPickerViewDelegate, UIPickerViewDataSource  {
     
     func setupPicker(textF : UITextField) {
         textF.inputView = self.pickerView
         textF.inputAccessoryView = self.pickerView.toolbar
         self.pickerView.dataSource = self
         self.pickerView.delegate = self
         self.pickerView.toolbarDelegate = self
         self.pickerView.reloadAllComponents()
         
     }
     
     func reloadPickerData() {
         
         self.pickerView.reloadAllComponents()
     }
     func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
     }
     
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         return quanityList.count
     }
     
     func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         return quanityList[row]
     }
     
     func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         guard self.types.count > 0 else { return }
         self.typeTF.text = types[row].nameAr
         self.selectedType = types[row]
     }
      
     
 }

 extension ProductVC: ToolbarPickerViewDelegate {
     
     func didTapDone() {
         guard self.quanityList.count > 0 else { return }
         let row = self.pickerView.selectedRow(inComponent: 0)
         self.pickerView.selectRow(row, inComponent: 0, animated: false)
         self.typeTF.text = quanityList[row]
         self.typeTF.resignFirstResponder()
         self.selectedType = types[row]
     }
     
     func didTapCancel() {
         self.typeTF.resignFirstResponder()
     }
 }

 
 
 */
