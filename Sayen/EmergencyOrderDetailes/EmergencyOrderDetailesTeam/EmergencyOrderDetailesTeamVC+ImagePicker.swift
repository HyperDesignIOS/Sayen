//
//  EmergencyOrderDetailesTeamVC+ImagePicker.swift
//  Sayen  Worker
//
//  Created by ME-MAC on 2/27/22.
//

//import OpalImagePicker


import UIKit
import MobileCoreServices
import Photos

extension EmergencyOrderDetailesTeamVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate    {
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



//extension EmergencyOrderDetailesTeamVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate  , OpalImagePickerControllerDelegate  {
//
//    func imageTapped()
//       {
//
//           let actionSheet :UIAlertController = UIAlertController(title: " ",  message:  "selectImagesFrom".localized , preferredStyle: .actionSheet
//
//           )
//           let cancle:UIAlertAction = UIAlertAction(title:  "close".localized, style: .cancel, handler: nil)
//           let photos :UIAlertAction = UIAlertAction(title:  "photos".localized, style: .default) { UIAlertAction in
//
//               self.openGallery(state: true)
//           }
//           let camera :UIAlertAction = UIAlertAction(title: "Camera".localized, style: .default) { UIAlertAction in
//
//
//               self.shootPhoto()
//
//           }
//           actionSheet.addAction(photos)
//
//           actionSheet.addAction(camera)
//
//           actionSheet.addAction(cancle)
//           self.present(actionSheet, animated: true, completion: nil)
//
//       }
////    func photoFromLibrary() {
//
////        PHPhotoLibrary.requestAuthorization({
////            (newStatus) in
////            switch newStatus {
////            case .authorized:
////                print("open")
////                self.openGallery(state: true)
////            case .denied ,.notDetermined , .restricted :
////                print("denied")
////
////            default :
////                print("Default")
////                return
////            }
////
////        })
////    }
//
//    func openGallery (state : Bool) {
//        let imagePicker = OpalImagePickerController()
//
//        //Change color of selection overlay to white
//        imagePicker.selectionTintColor = UIColor.white.withAlphaComponent(0.7)
//
//        //Change color of image tint to black
//        imagePicker.selectionImageTintColor = .white
//
//        //Change status bar style
//        imagePicker.statusBarPreference = UIStatusBarStyle.lightContent
//
//        //Limit maximum allowed selections to 5
//        imagePicker.maximumSelectionsAllowed = 5
//
//        //Only allow image media type assets
//        imagePicker.allowedMediaTypes = Set([PHAssetMediaType.image])
//
//        //Change default localized strings displayed to the user
//        let configuration = OpalImagePickerConfiguration()
//        configuration.maximumSelectionsAllowedMessage = "maxFImages".localized
//        imagePicker.configuration = configuration
//
//        imagePicker.imagePickerDelegate = self
//        present(imagePicker, animated: true, completion: nil)
////        if state {
////            DispatchQueue.main.async {
////                self.picker.allowsEditing = false
////                self.picker.sourceType = .photoLibrary
////                self.picker.mediaTypes = [kUTTypeImage as String]
////                self.picker.modalPresentationStyle = .popover
////                self.present(self.picker, animated: true, completion: nil)
////            }
////
////        }
//    }
//
//    func shootPhoto() {
//        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { [weak self ](granted :Bool) -> Void in
//
//            if granted == true
//            {
//                // User granted
//                DispatchQueue.main.async {
//                    self?.userCamera()
//                }
//            }
//            else
//            {
//                DispatchQueue.main.async {
//                    self?.view.showSimpleAlert("", "camActivactionMsg".localized, .warning)
//                    let alert = UIAlertController(title: "" , message:  "cameraNotPermitted".localized, preferredStyle: .alert)
//
//                    alert.addAction(UIAlertAction(title:  "settings".localized, style: .default, handler: { (_) in
//                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
//                            UIApplication.shared.openURL(settingsURL)
//                        }
//
//
//                    }))
//                    alert.addAction(UIAlertAction(title:  "close".localized, style: .cancel, handler: nil))
//                    self?.present(alert, animated: true, completion: nil)
//
//                }
//                return
//            }
//        });
//
//
//    }
//
//    func userCamera() {
//
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            picker.allowsEditing = false
//            picker.sourceType = UIImagePickerController.SourceType.camera
//            picker.cameraCaptureMode = .photo
//            picker.modalPresentationStyle = .fullScreen
//            //            picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
//            picker.mediaTypes = [kUTTypeImage as String]
//            present(picker,animated: true,completion: nil)
//        } else {
//            noCamera()
//        }
//    }
//    func noCamera(){
//        let alertVC = UIAlertController(
//            title:  "nocameraFound".localized,
//            message:  "deviceNoCamera".localized,
//            preferredStyle: .alert)
//        let okAction = UIAlertAction(
//            title: "OK",
//            style:.default,
//            handler: nil)
//        alertVC.addAction(okAction)
//        present(
//            alertVC,
//            animated: true,
//            completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if allImgs.count == 5 {return}
//           var chosenImage = UIImage()
//        chosenImage = info[.originalImage] as! UIImage //2
//         allImgs.append(chosenImage)
//         dismiss(animated:true, completion: nil)
//         self.imageHieght.constant = 130
//         UIView.animate(withDuration: 0.5) {
//                   self.view.layoutIfNeeded()
//               }
//
//        self.imagesCollection.alpha = 1
//        self.imagesCollection.reloadData()
//
//
//        self.index = 0
//        images.removeAll()
//         for img in allImgs {
//
//               let myThumb  = img.resizeImageWith(newSize: CGSize(width: 200, height: 200))
//               let image = myThumb
//               if let data = image.jpegData(compressionQuality: 1.0) {
//                   print("Size: \(data.count ) bytes")
//               }
//              images.append(myThumb)
//
//               imageDict["image\(index)"] = myThumb
//               index += 1
//
//              }
//
//     //  parameters["images"] = images
//
//        print(imageDict.count)
//        print(images.count)
//           //5
//       }
//
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//
//    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]){
////           var chosenImage = UIImage()
////        chosenImage = info[.originalImage] as! UIImage //2
////         allImgs.append(chosenImage)
////         dismiss(animated:true, completion: nil)
//        for img in assets {
//            let image = PHImageRequestOptions()
//            image.version = .original
//            PHImageManager.default().requestImage(for: img, targetSize:  CGSize(width: 200, height: 200), contentMode: .default, options: nil) { image, _ in
//                if let image = image {
//                    self.allImgs.append(image)
//                    self.images.append(image)
//                }
//
//            }
//        }
////        allImgs = picker.selectionImage?.images ?? []
////        images =  picker.selectionImage?.images ?? []
//         self.imageHieght.constant = 130
//         UIView.animate(withDuration: 0.5) {
//                   self.view.layoutIfNeeded()
//               }
//
//        self.imagesCollection.alpha = 1
//        self.imagesCollection.reloadData()
//
//
//        self.index = 0
//        images.removeAll()
////         for img in allImgs {
////
////               let myThumb  = img.resizeImageWith(newSize: CGSize(width: 200, height: 200))
////               let image = myThumb
////               if let data = image.jpegData(compressionQuality: 1.0) {
////                   print("Size: \(data.count ) bytes")
////               }
////              images.append(myThumb)
////
////               imageDict["image\(index)"] = myThumb
////               index += 1
////
////              }
//
//     //  parameters["images"] = images
//
//        print(imageDict.count)
//        print(images.count)
//        presentedViewController?.dismiss(animated: true, completion: nil)
//       }
//    func imagePickerDidCancel(_ picker: OpalImagePickerController){
//
//    }
////     func imagePickerNumberOfExternalItems(_ picker: OpalImagePickerController) -> Int{
////         return 3
////    }
////     func imagePicker(_ picker: OpalImagePickerController, imageURLforExternalItemAtIndex index: Int) -> URL?{
////         return URL()
////    }
////     func imagePickerTitleForExternalItems(_ picker: OpalImagePickerController) -> String{
////         return "fjdsd"
////    }
////     func imagePicker(_ picker: OpalImagePickerController, didFinishPickingExternalURLs urls: [URL]){
////         return [URL()]
////    }
//}
