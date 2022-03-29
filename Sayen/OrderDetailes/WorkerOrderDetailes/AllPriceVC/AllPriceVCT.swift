//
//  AllPriceVCT.swift
//  Sayen  Worker
//
//  Created by Maher on 6/17/20.
//

import UIKit
import DLRadioButton

class AllPriceVCT: UIViewController {

    
    var startPrice : String = ""
    var coponPrice : String = ""
    var endPrice : String = ""
    var order_id : Int = 0
    var tabBar : UITabBarController?
    weak var delegate : endFinalWork!
     @IBOutlet weak var coponView: UIView!
    @IBOutlet weak var startLbl: UILabel!
    @IBOutlet weak var discoundLbl: UILabel!
    @IBOutlet weak var endlbl: UILabel!
    @IBOutlet weak var requiredCostLbl: UILabel!
    @IBOutlet weak var cashtrueImg: UIImageView!
    @IBOutlet weak var checkBoxbtn: UIButton!
    @IBOutlet weak var paymentMethodContainerV: CardView!
    @IBOutlet weak var ownerPayBtnOL: DLRadioButton!
    @IBOutlet weak var clientPayBtnOL: DLRadioButton!
    
    @IBOutlet weak var finalCOstContainerV: UIView!
    @IBOutlet weak var costBeforeDiscountV: UIView!
    
    
    @IBOutlet weak var multiButtonOutlet: UIButton!
    @IBOutlet weak var imagesCollection: UICollectionView!
    @IBOutlet weak var imageHieght: NSLayoutConstraint!
    
    var cashPrice : Bool = false
    var data: TeamOrderDetailes?
    let picker = UIImagePickerController()
    var selectedImages : [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleCollectionView()
        self.startLbl.text = "\(startPrice.getPriceValue()) " + "Rial".localized
        if let total = Double(coponPrice) , let startP = Double(startPrice) {
            let v = total - startP
            let isInt = floor(v) == v
            coponPrice = isInt ? "\(Int(v))" : "\(v)"
        }
        self.discoundLbl.text = "\(coponPrice.getPriceValue()) " + "Rial".localized
        self.endlbl.text = "\(endPrice.getPriceValue()) " + "Rial".localized
        if coponPrice == "0" || data?.coupon_discount == 0  || coponPrice == startPrice {
            self.coponView.isHidden = true
            
         }else{
            self.coponView.isHidden = false
         }
        clientPayBtnOL.isSelected = true
        paymentMethodContainerV.isHidden =  data?.excellence_client != "1"
        
        
        if let data = self.data , data.pay_method == "2" {
            
            if let initP = Double(startPrice) , let finalP = Double(endPrice) {
                self.finalCOstContainerV.isHidden = false
                self.requiredCostLbl.text = "\(finalP - initP)".getPriceValue()

            }
            
        }else {
             self.requiredCostLbl.text = endPrice.getPriceValue()
            self.finalCOstContainerV.isHidden = true
        }
        
        self.picker.delegate = self
        self.picker.allowsEditing = true
        
        
    }

    @IBAction func uplodeImgs(_ sender: Any) {
        guard ad.isOnline() else{return}
        if selectedImages.count != 5{
        self.picker.delegate = self
        self.picker.allowsEditing = true
        uploadFinishWorkImage()
        }else{
            showDAlert(title: "Sorry", subTitle: "maxFImages".localized, type: .updateRequired, buttonTitle: "ok", completionHandler: nil)
        }
    }

    @IBAction func checkhandler(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
            cashPrice = sender.isSelected
            if sender.isSelected {
                sender.setImage(#imageLiteral(resourceName: "Group 1062"), for: .normal)
                self.cashtrueImg.alpha = 1
            }else {
                sender.setImage(#imageLiteral(resourceName: "Rectangle 527"), for: .normal)
                self.cashtrueImg.alpha = 0
            }
    }
    func EndFinalWork (pay_by: String?, images: [UIImage]) {
        if let data = data {
            if let orderId = data.id {
                ad.isLoading()
                APIClient.finishWork(orderId: "\(orderId)" , images: images) { (state, sms) in
                    ad.killLoading()
                    guard state else{
                        return
                    }
                    self.showDAlert(title: "", subTitle: "requestDone".localized, type: .success, buttonTitle: "done".localized ) { (_) in
                        self.goToHome()
                    }
                    
                } completionFaliure: { (error) in
                    ad.killLoading()
                    print("Error")
                }
                
            }
        }
    }
    
    func goToHome(){
        let navController = UINavigationController()
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        guard let window = keyWindow else {return}
        let storyb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        tabBar = storyb.instantiateViewController(withIdentifier: "rootNav") as? UITabBarController
        navController.navigationBar.isHidden = true
        navController.viewControllers = [tabBar!]
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }
    
    @IBAction func endWorking(_ sender: UIButton) {
       
        if sender.tag == 123 {
            guard cashPrice else{
                self.showDAlert(title: "", subTitle: "confirmReceipt".localized, type: .error, buttonTitle: "", completionHandler: nil)
                   return
               }
            EndFinalWork (pay_by: clientPayBtnOL.isSelected ? "1" : "2" , images: selectedImages )

        }else  if sender.tag == 122 {
            self.uploadFinishWorkImage()
        }
    }

    @IBAction func dismiss(_ sender: Any) {
        self.dismissViewC()
   
    }
  

}


protocol endFinalWork : class {
    func endFinalWork (state : Bool,pay_by:String?, images: [UIImage])
}


