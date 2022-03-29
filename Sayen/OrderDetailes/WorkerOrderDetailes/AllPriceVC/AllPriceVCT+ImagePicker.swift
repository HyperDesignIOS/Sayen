//
//  AllPriceVCT+ImagePicker.swift
//  Sayen  Worker
//
//  Created by ME-MAC on 2/27/22.
//


import UIKit
import MobileCoreServices
import Photos

extension AllPriceVCT : UIImagePickerControllerDelegate, UINavigationControllerDelegate    {
    func uploadFinishWorkImage()
       {
           
           let actionSheet :UIAlertController = UIAlertController(title: " ",  message:  "uploadToFinish".localized , preferredStyle: .actionSheet
               
           )
           let cancle:UIAlertAction = UIAlertAction(title:  "close".localized, style: .cancel, handler: nil)
           
           let camera :UIAlertAction = UIAlertAction(title: "Camera".localized, style: .default) { UIAlertAction in
               
               
               self.shootPhoto()
               
           }
           
           
           actionSheet.addAction(camera)
           
           actionSheet.addAction(cancle)
           self.present(actionSheet, animated: true, completion: nil)
           
       }
    
    
    
    
    func shootPhoto() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { [weak self ](granted :Bool) -> Void in
           
            if granted == true
            {
                // User granted
                DispatchQueue.main.async {
                    self?.userCamera()
                }
            }
            else
            {
                DispatchQueue.main.async {
                    self?.view.showSimpleAlert("", "camActivactionMsg".localized, .warning)
                    let alert = UIAlertController(title: "" , message:  "cameraNotPermitted".localized, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title:  "settings".localized, style: .default, handler: { (_) in
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.openURL(settingsURL)
                        }
                        
                        
                    }))
                    alert.addAction(UIAlertAction(title:  "close".localized, style: .cancel, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                    
                }
                return
            }
        });
        
        
    }
    
    func userCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            //            picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
            picker.mediaTypes = [kUTTypeImage as String]
            present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }
    func noCamera(){
        let alertVC = UIAlertController(
            title:  "nocameraFound".localized,
            message:  "deviceNoCamera".localized,
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[.originalImage] as! UIImage //2
        selectedImages.append(chosenImage)
        self.imageHieght.constant = 130
        UIView.animate(withDuration: 0.5) {
                  self.view.layoutIfNeeded()
              }

        imagesCollection.reloadData()
        multiButtonOutlet.tag = 123
        dismiss(animated:true, completion: nil)
    }
       
       
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           dismiss(animated: true, completion: nil)
           }
    

}


