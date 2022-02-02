//
//  SendOrder.swift
//  Sayen 
//
//  Created by Maher on 6/9/20.
//

import UIKit
import CoreLocation
import PassKit


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
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var infoImg: UIImageView!
    @IBOutlet weak var couponTxt: UITextField!
    @IBOutlet weak var imageLabelTopAnchor: NSLayoutConstraint!
    let picker = UIImagePickerController()
    var imageDict : [String:UIImage] = [:]
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
    var address = ""
    var initPrice = ""
    var infoText = ""
    var calenderNewDate: String = ""
    var user : UserProfile_Data? = nil



    var orderId = Int()
    let paymentHandler = PaymentHandler()
    
    let contianuAlert = ContianuAlert()
    let paymentController = PaymentVC()
    @IBOutlet weak var imagesCollection: UICollectionView!
    @IBOutlet weak var imagesLbl: UILabel!
    var pageTransformeTitle = ""
    var id = 0
    var index : Int = 0
    var oldProfileImage : UIImage?
    var allImgs : [UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()
      
        configContainerAlert()
        configPaymentController()
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
        infoLbl.text = infoText
        if infoText.isEmpty {
            imageLabelTopAnchor.constant = 16
            infoLbl.isHidden = true
            infoImg.isHidden = true
        }
        if let user = user {
            let lat = user.lat
            if !lat.isEmpty {
                self.lat = Double(lat) ?? 0.0
            }
            let lng = user.lng
            if !lng.isEmpty {
                self.long =  Double(lng) ?? 0.0
            }
            let address = user.address
            if !address.isEmpty {
                self.address = address
                addressLbl.text = address
            }
            let floor = user.floor
            if !floor.isEmpty {
                self.floor = floor
            }
            
        }
    }
   
    func configContainerAlert() {
        contianuAlert.delegate = self
        contianuAlert.modalTransitionStyle = .crossDissolve
        contianuAlert.modalPresentationStyle = .overFullScreen
    }
    func configPaymentController() {
        paymentController.initPricePay = initial_price + " " + "Rial".localized
        paymentController.price = initial_price
        paymentController.service = pageTransformeTitle
        paymentController.CouponBool = self.CouponBool
        paymentController.pricebeforeDis =  "\(pricebeforeDis) " + "Rial".localized
        paymentController.delegate = self
    }
    @IBAction func openCalnder(_ sender: Any) {
        print(user?.email)
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
            vc.address = self.address
            print(self.lat , self.long)
        }
      
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    private func enteredDataValidator(data: [SendOrderValidatorData]) -> Bool {
        var result : Bool = true
        for objc in data {
            if objc.currentValue == objc.unExpectedValue{
                result = false
                showDAlert(title: "Error".localized, subTitle: objc.alertMessage, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                break
            }
        }
       
        
        
        return result
    }
    
    @IBAction func okHandler(_ sender: Any) {
//        guard ad.isOnline() else{return}
        if enteredDataValidator(data: [
            SendOrderValidatorData(currentValue: "\(allImgs.count)", unExpectedValue: "0", alertMessage: "uploadProblemImage".localized),
            SendOrderValidatorData(currentValue: notesTextV.text ?? "", unExpectedValue: "", alertMessage: "enterProblemDetails".localized),
            SendOrderValidatorData(currentValue: addressLbl.text ?? "", unExpectedValue: "selectOnMap".localized, alertMessage: "selectAddress".localized),
            SendOrderValidatorData(currentValue: dateLbl.text ?? "", unExpectedValue: "select".localized, alertMessage: "selectVisitDateTime".localized)
            
        ]){
            self.present(contianuAlert, animated: false)
        }
    }

    func sendCashOrder() {
        parameters["notes"] = self.notesTextV.text
        print(parameters)
        ad.isLoading()
        APIClient.SendOrder(parameters: parameters, imageDict: images) { [weak self] (state, sms,urlStr, orderId)   in
            guard let self = self else {return}
            guard state  else{
                ad.killLoading()
                DispatchQueue.main.async {
                    self.showDAlert(title: "Error".localized, subTitle: sms.localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
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
           let camera :UIAlertAction = UIAlertAction(title: "Camera".localized, style: .default) { UIAlertAction in
               
               
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





extension SendOrder : RemoveImagePro {
    func removeImageFunc(i: Int) {
        self.deleteAlertImage(i: i)
    }
    
    
}


struct SendOrderValidatorData  {
    var  currentValue : String
    var unExpectedValue: String
    var alertMessage : String

}


    
    
    
