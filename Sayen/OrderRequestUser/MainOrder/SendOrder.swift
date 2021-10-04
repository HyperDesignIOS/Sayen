//
//  SendOrder.swift
//  Sayen 
//
//  Created by Maher on 6/9/20.
//

import UIKit
import Kingfisher
import MobileCoreServices
import AVFoundation
import CoreLocation
import Photos
import PassKit
import SwiftyJSON
class SendOrder: UIViewController {

    @IBOutlet weak var imageHieght: NSLayoutConstraint!
    @IBOutlet weak var coponView: UIView!
    @IBOutlet weak var errorCopunLbl: UILabel!
    @IBOutlet weak var coponPriceDiscount: UILabel!
    @IBOutlet weak var pageTilte: UILabel!
    @IBOutlet weak var placeHolderLbl: UILabel!
    @IBOutlet weak var notesTextV: UITextView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var couponTxt: UITextField!
    fileprivate let picker = UIImagePickerController()
    fileprivate var imageDict : [String:UIImage] = [:]
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    var CouponBool = false
    var lat : Double = 0.0
    var long : Double = 0.0
    var images : [UIImage] = []
    var parameters : [String : Any] = [:]
    var paymentType: PaymentType = .cash
    var initial_price = ""
    var pricebeforeDis = ""
    var addressDetaiels : String = ""
    var latTran : Double = 0.0
    var longTran : Double = 0.0
    var floor = ""
    var initPrice = ""
    var orderId = Int()
    let paymentHandler = PaymentHandler()
    
    @IBOutlet weak var imagesCollection: UICollectionView!
    @IBOutlet weak var imagesLbl: UILabel!
    var pageTransformeTitle = ""
    var id = 0
    var index : Int = 0
    var oldProfileImage : UIImage?
    var allImgs : [UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBar = self.tabBarController as! TabBarController
        tabBar.hideTab()
      
        self.couponTxt.addTarget(self, action: #selector(couponTxtdidChange(_:)), for: .editingDidEnd)
        setData ()
        notesTextV.semanticContentAttribute = .forceRightToLeft
        self.imagesCollection.semanticContentAttribute = .forceRightToLeft
        self.notesTextV.delegate = self
        self.imagesCollection.register(UINib(nibName: "imagesCell", bundle: nil), forCellWithReuseIdentifier: "imagesCell")
        self.imagesCollection.delegate = self
        self.imagesCollection.dataSource = self
        
        if
           CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
           CLLocationManager.authorizationStatus() ==  .authorizedAlways
        {
            if let currentLocation = locManager.location {
                self.latTran = currentLocation.coordinate.latitude
                self.longTran = currentLocation.coordinate.longitude
            }
           
        }

    }
    
    func setData () {
        self.initPrice = initial_price
        self.pageTilte.text = "request".localized  + pageTransformeTitle
        self.priceLbl.text = "\(initial_price) " + "Rial".localized
        parameters["price_after_coupon"] = "\(initial_price)"
        parameters["service_id"] = id
    }
   
    
    @IBAction func openCalnder(_ sender: Any) {
        guard ad.isOnline() else{return}
        let vc = OrderDate()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        DispatchQueue.main.async {
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    @IBAction func uplodeImgs(_ sender: Any) {
        guard ad.isOnline() else{return}
        if allImgs.count != 5{
        imageTapped()
        self.picker.delegate = self
        self.picker.allowsEditing = true
            
        }else{
            self.imagesLbl.textColor = .red
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
              self.imagesLbl.textColor = .secondaryColor
            }
        }
    }
    
    @objc func couponTxtdidChange(_ textF : UITextField) {
        guard CouponBool else { return }
        CouponBool = false
        self.initial_price = self.pricebeforeDis
        self.coponView.alpha = 0
        self.priceLbl.text = "\(initial_price) " + "Rial".localized
        self.parameters["coupon_code"] = nil

    }


    @IBAction func reviewCoupon(_ sender: Any) {
        self.view.endEditing(true)
        guard let coupon = self.couponTxt.text , coupon != "" else{
            self.showDAlert(title: "Error".localized, subTitle: "enterCodeFirst".localized , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            
            return
        }
        
        APIClient.validateCoupon(code: coupon, total_price: initPrice , serviceId: id, completionHandler: { (state, sms ,coupon_discount ,total_price_after_coupon ,total_price_before_coupon ) in
            
            guard state  else{
                self.CouponBool = false
                self.errorCopunLbl.alpha = 1
                self.coponView.alpha = 0
                
                self.initial_price = self.pricebeforeDis
                self.priceLbl.text = "\(self.initial_price) " + "Rial".localized
                self.parameters["coupon_code"] = nil

                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    self.errorCopunLbl.alpha = 0
                }
                //    self.couponTxt.text = ""
                //                 self.showDAlert(title: "Error".localized, subTitle: "من  فضلك قم بإدخال الكود اولا", type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                return
            }

            if self.pricebeforeDis == "" {
            self.pricebeforeDis = self.initial_price
            }
            self.errorCopunLbl.alpha = 0
            self.coponView.alpha = 1
            self.CouponBool = true
            self.initial_price = "\(total_price_after_coupon)"
            self.coponPriceDiscount.text = "\(coupon_discount) " + "Rial".localized
            self.priceLbl.text = "\(total_price_after_coupon) " + "Rial".localized
            self.parameters["coupon_code"] = coupon
            
        }) { (err) in
            print("error")
        }
        
        
    }
    
    
  
    
    @IBAction func openMap(_ sender: Any) {
        guard ad.isOnline() else{
            
            return
        }
        
        let vc = MapAddressVC()
        if self.lat == 0.0 {
            vc.latTran = self.latTran
            vc.longTran = self.longTran
        }else{
            vc.latTran = self.lat
            vc.longTran = self.long
            vc.floor =  self.floor
        }
      
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func okHandler(_ sender: Any) {
        guard ad.isOnline() else{return}
        var isValid = true
        if allImgs.count == 0 {
            self.showDAlert(title: "Error".localized, subTitle: "uploadProblemImage".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            isValid = false
        }
        if notesTextV.text == "" {
            self.showDAlert(title: "Error".localized, subTitle: "enterProblemDetails".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            isValid = false
        }
        if addressLbl.text == "selectOnMap".localized {
            self.showDAlert(title: "Error".localized, subTitle: "selectAddress".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            isValid = false
            
        }
        if dateLbl.text == "select".localized {
            self.showDAlert(title: "Error".localized, subTitle:"selectVisitDateTime".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            isValid = false
        }
        
        if isValid {
            let vc = ContianuAlert()
            vc.delegate = self
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false)
        }
        
        
    }
    
    func continueFuncaction() {
        let vc = PaymentVC()
        vc.initPricePay = initial_price + " " + "Rial".localized
        vc.price = initial_price
        vc.service = pageTransformeTitle
        vc.CouponBool = self.CouponBool
        vc.pricebeforeDis =  "\(pricebeforeDis) " + "Rial".localized
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func sendCashOrder() {
        parameters["notes"] = self.notesTextV.text
        
        print(parameters)
        ad.isLoading()
        APIClient.SendOrder(parameters: parameters, imageDict: images) { [weak self] (state, sms,urlStr, orderId)   in
            guard let self = self else {return}
            guard state else{
                ad.killLoading()
                DispatchQueue.main.async {
                    self.showDAlert(title: "Error".localized, subTitle: sms, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                }
                
                return
            }
            DispatchQueue.main.async {
                ad.killLoading()
                switch self.paymentType {
                case .apple:
                    if let orderId = orderId {
                        self.orderId = orderId
                        let result = PaymentHandler.applePayStatus()
                        if result.canMakePayments {
                            self.paymentHandler.delegate = self
                            self.paymentHandler.startPayment(servcie: self.pageTransformeTitle, price: self.initial_price) { (success) in
                                if success {
                                    //TODO: need to handle when applepay scussess
    //                                self.performSegue(withIdentifier: "Confirmation", sender: self)
                                    print("SSSS success")
                                }
                            }
                            
                        } else if result.canSetupCards {
                            let passLibrary = PKPassLibrary()
                            passLibrary.openPaymentSetup()
                        }
                    }
                case .cards:
                    if let urlS = urlStr , let _ = URL(string: urlS) {
                    let vc = OnlinePaymentVC()
                    vc.urlSt = urlS
                    self.presentInFullScreen(vc, animated: true)
                    }
                case .cash:
                    self.showDAlert(title: "thanks".localized, subTitle:  "requestSentSuccessfully".localized, type: .success, buttonTitle: "") { (_) in
                        self.gotoOrders()
                    }
                }
            }
        }
    }
    func gotoOrders() {
        DispatchQueue.main.async {
            var tabBar : UITabBarController?
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            guard let window = keyWindow else {return}
            let storyb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            tabBar = storyb.instantiateViewController(withIdentifier: "rootNav") as? UITabBarController
            tabBar?.selectedIndex = 1
            window.rootViewController = tabBar
            window.makeKeyAndVisible()
        }
    }
    @IBAction func cancelHandler(_ sender: Any) {
        
//        self.showDAlert(title: "", subTitle:  "requestCanceled".localized, type: .sucNil, buttonTitle: "", completionHandler: nil)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//
//            self.dismissViewC()
//        }
        DispatchQueue.main.async {
              self.showDAlert(title: "", subTitle:  "requestCanceled".localized, type: .success, buttonTitle: "") { (ـ) in
                      self.dismissViewC()
                  }
        }
      
//        let vc = cancelSendOrder()
//        vc.delegate = self
//        vc.modalTransitionStyle = .crossDissolve
//        vc.modalPresentationStyle = .overFullScreen
//        self.present(vc, animated: false)
       
    }
    
    func imageTapped()
       {
           
           let actionSheet :UIAlertController = UIAlertController(title: " ",  message:  "selectImagesFrom".localized , preferredStyle: .actionSheet
               
           )
           let cancle:UIAlertAction = UIAlertAction(title:  "close".localized, style: .cancel, handler: nil)
           let photos :UIAlertAction = UIAlertAction(title:  "photos".localized, style: .default) { UIAlertAction in
               
               self.photoFromLibrary()
           }
           let camera :UIAlertAction = UIAlertAction(title: "camira".localized, style: .default) { UIAlertAction in
               
               
               self.shootPhoto()
               
           }
           actionSheet.addAction(photos)
           
           actionSheet.addAction(camera)
           
           actionSheet.addAction(cancle)
           self.present(actionSheet, animated: true, completion: nil)
           
       }
    

    @IBAction func dismiss(_ sender: Any) {
        
        let tabBar = self.tabBarController as! TabBarController
        self.dismissViewC()
        tabBar.showTab()
    }
    
}



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
                    let alert = UIAlertController(title: "" , message:  "camiraNotPermitted".localized, preferredStyle: .alert)
                    
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
            title:  "noCamiraFound".localized,
            message:  "deviceNoCamira".localized,
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


extension SendOrder : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.placeHolderLbl.alpha = 0
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.notesTextV.text == "" {
             self.placeHolderLbl.alpha = 1
        }
       }
    
}


extension SendOrder : UICollectionViewDelegate , UICollectionViewDataSource  , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allImgs.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.imagesCollection.dequeueReusableCell(withReuseIdentifier: "imagesCell", for: indexPath) as! imagesCell
        cell.problemImg.image = self.allImgs[indexPath.row]
        cell.problemImg.layer.cornerRadius = 5
        cell.deleteBtn.layer.setValue(indexPath.row, forKey: "index")
        cell.deleteBtn.addTarget(self, action: #selector(deleteUser(sender:)), for: .touchUpInside)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = self.imagesCollection.frame.width / 5.1
             let h =  self.imagesCollection.frame.height - 10
             let size = CGSize(width: w , height: h)
             return size
         }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
 
      
    @objc func deleteUser(sender:UIButton) {

               let i : Int = (sender.layer.value(forKey: "index")) as! Int
               let vc = removeImage()
               vc.i = i
               vc.delegate = self
               vc.modalTransitionStyle = .crossDissolve
               vc.modalPresentationStyle = .overFullScreen
               self.present(vc, animated: false)
        
    }
    
    func deleteAlertImage (i : Int) {
        
        allImgs.remove(at: i)
        images.remove(at: i)
        imagesCollection.reloadData()
        if self.allImgs.count == 0 {
            self.imageHieght.constant = 52
            self.imagesCollection.alpha = 0
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }

        
    }
    
    
}


extension SendOrder : RemoveImagePro {
    func removeImageFunc(i: Int) {
        self.deleteAlertImage(i: i)
    }
    
    
}



var NewDate: String = ""

extension SendOrder : sendAddress , SendDate {
  
    
    func sendDate(date: String ,backendDate: String) {
        print(date)
        print(backendDate)
       
       
        for char:Character in date {
           
           
               let numberFormatter: NumberFormatter = NumberFormatter()
               numberFormatter.locale = NSLocale(localeIdentifier: "EN") as Locale?
                if let englishString = numberFormatter.number(from: String(char)) {
                   print(englishString)
                    
                    NewDate.append(englishString.stringValue)
                
            }else{
                NewDate.append(char)
            }
            
            print(NewDate)
          
        }
        
        
        self.dateLbl.text = NewDate
        NewDate = ""
           
        
        self.parameters["visit_date"] = backendDate
    }
    @objc func didChangeText(field: UITextField) {
                   
               }
    
    func sendAddress(address: String, lat: Double, long: Double, floor: String) {
       self.showDAlert(title: "", subTitle:  "addressAdded".localized, type: .success, buttonTitle: "") { (_) in
            self.addressDetaiels = address
        self.addressLbl.text = "\(address) " + "floor".localized + " \(floor)"
            self.lat = lat
            self.long = long
            self.floor = floor
            self.parameters["address"] = address
            self.parameters["lat"] = lat
            self.parameters["lng"] = long
            self.parameters["floor"] = floor
            }
        
    }
    
    
    
}

extension SendOrder : finallySendOrder , containuProtocol , cancelAlertSend , successApplePay {
    func successApplePay(id: String, status: String) {
        print(orderId , id , status)
        
        APIClient.sendGetRequestWithParamter("https://sayen.co/api/v2/user/success-pay", parameters: ["order_id": "\(orderId)", "id": id, "status": status])  { responseObject, error in
            guard let responseObject = responseObject, error == nil else {
                print(error ?? "Unknown error")
                return
            }
            let json = JSON(responseObject)
            let msgStr = json["message"].string ?? ""
            let statusStr = json["status"].string ?? ""
            if statusStr ==  "1" ,msgStr ==  "Success pay" {
                self.showDAlert(title: "thanks".localized, subTitle:  "paymentSuccess".localized, type: .success, buttonTitle: "") { (_) in
                    self.gotoOrders()
                }
            }else {
                self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            }
            print(responseObject)
        }
    }
    
    
    
    func cancelAlertSendFunc() {
     //  let tabBar = self.tabBarController as! TabBarController
       self.dismissViewC()
     //  tabBar.showTab()
    }
    
    func continueFunc() {
        self.continueFuncaction()
    }
    
    func finallySendOrder(payType: PaymentType) {
        self.paymentType = payType
        parameters["pay_method"] = payType.pay_method
        parameters["pay_type"] = payType.rawValue
        
//        if pay_method == 1 {
            self.sendCashOrder()
//        }
    }
    
    
}


enum PaymentType: String {
    case apple
    case cards
    case cash
    
    var pay_method : Int {
        switch self {
        case .apple, .cards:
            return 2
        case .cash:
            return 1
        }
    }
}


