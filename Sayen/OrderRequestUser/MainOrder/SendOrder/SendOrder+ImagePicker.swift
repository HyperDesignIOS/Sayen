//
//  SendOrder+ImagePicker.swift
//  Sayen 
//
//  Created by Awab's Mac on 11/11/21.
//


import UIKit
import MobileCoreServices
import Photos

extension SendOrder : UIImagePickerControllerDelegate, UINavigationControllerDelegate    {
    func photoFromLibrary() {
        PHPhotoLibrary.requestAuthorization({
            (newStatus) in
            switch newStatus {
            case .authorized:
                print("open")
                self.openGallery(state: true)
            case .denied ,.notDetermined , .restricted :
                print("denied")
                
            default :
                print("Default")
                return
            }
            
        })
    }
    
    func openGallery (state : Bool) {
        if state {
            DispatchQueue.main.async {
                self.picker.allowsEditing = false
                self.picker.sourceType = .photoLibrary
                self.picker.mediaTypes = [kUTTypeImage as String]
                self.picker.modalPresentationStyle = .popover
                self.present(self.picker, animated: true, completion: nil)
            }
      
        }
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
        if allImgs.count == 5 {return}
           var chosenImage = UIImage()
        chosenImage = info[.originalImage] as! UIImage //2
         allImgs.append(chosenImage)
         dismiss(animated:true, completion: nil)
         self.imageHieght.constant = 130
         UIView.animate(withDuration: 0.5) {
                   self.view.layoutIfNeeded()
               }
              
        self.imagesCollection.alpha = 1
        self.imagesCollection.reloadData()
       
     
        self.index = 0
        images.removeAll()
         for img in allImgs {
               
               let myThumb  = img.resizeImageWith(newSize: CGSize(width: 200, height: 200))
               let image = myThumb
               if let data = image.jpegData(compressionQuality: 1.0) {
                   print("Size: \(data.count ) bytes")
               }
              images.append(myThumb)

               imageDict["image\(index)"] = myThumb
               index += 1
                
              }
       
     //  parameters["images"] = images
        
        print(imageDict.count)
        print(images.count)
           //5
       }
       
       
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           dismiss(animated: true, completion: nil)
           }
    

}
