//
//  EmergencyOrderDetailesTeamVC.swift
//  Sayen 
//
//  Created by ME-MAC on 2/24/22.
//

import UIKit

class EmergencyOrderDetailesTeamVC: UIViewController {
    
    //    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var maintitle: UILabel!
    @IBOutlet weak var orderNum: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var inWayTitle: UILabel!
    @IBOutlet weak var endTitle: UILabel!
    @IBOutlet weak var inProgTitle: UILabel!
    @IBOutlet weak var newOrderTite: UILabel!
    @IBOutlet weak var newOrderImg: UIImageView!
    @IBOutlet weak var inWayImg: UIImageView!
    @IBOutlet weak var inProgImg: UIImageView!
    @IBOutlet weak var endImg: UIImageView!
    @IBOutlet weak var inProgV: UIView!
    @IBOutlet weak var inWayV: UIView!
    @IBOutlet weak var gotoEndV: UIView!
    @IBOutlet weak var noteLbl: UILabel!
    @IBOutlet weak var multiButtonOutlet: UIButton!
    @IBOutlet weak var removeImageButtonOutlet: UIButton!
    @IBOutlet weak var finishImageView: UIImageView!
    @IBOutlet weak var addButtonsStackView: UIStackView!
    @IBOutlet weak var imagesCollection: UICollectionView!
    @IBOutlet weak var imageHieght: NSLayoutConstraint!
    @IBOutlet weak var imagesView: UIView!
    @IBOutlet weak var uploadImageButtonOutlet: UIView!
    
    var tabBar : UITabBarController?
    var statePrice : String = ""
    var order_id : Int = 0
    var order_status : String = ""
    var data : TeamOrderDetailes?
    var probImages : [String] = []
    var imgSenf : UIImageView = UIImageView()
    var team_added_price_desc : [String] = []
    var team_added_price : [String] = []
    var btnsState = false
//    let picker = UIImagePickerController()
//    var chosenImage = UIImage()
    let picker = UIImagePickerController()
    var imageDict : [String:UIImage] = [:]
    var selectedImages : [UIImage] = []
    var index : Int = 0
    var finishedImagesStr : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.delegate = self
        self.picker.allowsEditing = true
        removeImageButtonOutlet.isHidden = true
        getEmergencyOrderData()
        
        handleCollectionView()
    }
    
//    @IBAction func removeImage(_ sender: UIButton){
//        finishImageView.image = nil
//        removeImageButtonOutlet.isHidden = true
//        multiButtonOutlet.tag = 122
//    }
    
    @IBAction func addServiceButton(_ sender: UIButton){
        let vc = AddValuesAlert()
        vc.controlletType = .AddEmergencyService
        vc.orderId = data?.id ?? 0
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func copyButton(_ sender: UIButton){
        if let orderNum = orderNum.text {
                UIPasteboard.general.string = "\(orderNum)"
            Alert.showToastAlert(VC: self, title: "Request ID copied".localized, message: "\(orderNum)")
            }
    }
    
    
    @IBAction func addMatrialButton(_ sender: UIButton){
        let vc = AddValuesAlert()
        vc.controlletType = .AddEmergencyMaterial
        vc.orderId = data?.id ?? 0
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
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
    @IBAction func startWorkAction(_ sender: UIButton){
        if sender.tag == 123 {
            EndFinalWorkEmergency()
        }else  if sender.tag == 122 {
            uploadFinishWorkImage()
//            getEmergencyOrderData(endBill: true)
        }else  if sender.tag == 121 {
            emergencyStartWorkAPIRequest(sender)
        }else{
            goWorkEmergencyAPIRequest(sender)
        }
    }
    

    func getEmergencyOrderData () {
        ad.isLoading()
        APIClient.getToEmergancyOrder(order_id: self.order_id, completionHandler: { (state, sms, data) in
            ad.killLoading()
            guard state else {
                self.showDAlert(title:  "Error".localized, subTitle: "tryAgain".localized , type: .withContent, buttonTitle: "tryAgain".localized) { (_) in
                    self.goToHome()
                }
                return
            }
            
            if let data = data {
                self.data = data
                self.maintitle.text = data.title
                self.probImages = data.images
                self.date.text = data.date
                self.orderNum.text = "#\(data.order_number!)"
                self.setStatus(orderStatus: data.order_status!)
                self.noteLbl.text = data.notes
                let finishImages = data.finish_image ?? ""
              
                let images = finishImages.components(separatedBy: ",")
                
                for (index,img) in images.enumerated() {
                    if index == 0 {
                        self.finishedImagesStr.append(img)
                    }else {
                        let url = "https://sayen.co/public/uploads/orders/" + img
                        self.finishedImagesStr.append(url)
                    }
                }
                if !self.finishedImagesStr[0].isEmpty {
                    self.imageHieght.constant = 130
                    self.imagesView.isUserInteractionEnabled = false
                    UIView.animate(withDuration: 0.5) {
                        self.view.layoutIfNeeded()
                    }
                    
                    self.imagesCollection.reloadData()
                }
            }
            //     self.setOrderDetaiels(order_status: data.order_status!)
        }) { (err) in
            ad.killLoading()
            self.showDAlert(title:  "Error".localized, subTitle: "tryAgain".localized , type: .withContent, buttonTitle: "tryAgain".localized) { (_) in
                self.goToHome()
            }
        }
    }
    
    private func goWorkEmergencyAPIRequest(_ sender: UIButton){
        ad.isLoading()
        APIClient.emergencyGoWork(order_id: self.order_id, completionHandler: { (state, sms) in
            ad.killLoading()
            guard state else {
                self.showDAlert(title: "Error".localized, subTitle:sms, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                return
            }
            DispatchQueue.main.async {
                sender.setTitle("startWork".localized, for: .normal)
                sender.tag = 121
                self.setStatus (orderStatus : "6")
            }
        }) { (err) in
            ad.killLoading()
            self.showDAlert(title: "Error".localized, subTitle:"", type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
        }
    }
    private func emergencyStartWorkAPIRequest(_ sender: UIButton){
     ad.isLoading()
     APIClient.emergencyStartWork(order_id: self.order_id, completionHandler: { (state, sms) in
         ad.killLoading()
         guard state else {
             self.showDAlert(title: "Error".localized, subTitle:sms, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
             return
         }
         DispatchQueue.main.async {
             sender.setTitle("finishWork".localized, for: .normal)
             sender.tag = 122
             sender.backgroundColor = UIColor.redColor
             self.setStatus(orderStatus : "2")
          
         }
     }) { (err) in
         ad.killLoading()
         self.showDAlert(title: "Error".localized, subTitle:"", type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
     }
 }
    
    func EndFinalWorkEmergency() {
        ad.isLoading()
        if let data = data {
            if let orderId = data.id {
                APIClient.emergencyOrderFinishWork(orderId: "\(orderId)" , images: selectedImages) { (state, sms) in
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
    
    func setStatus (orderStatus : String){
        
        if orderStatus == "1" {
            
            self.newOrderImg.image = UIImage(named: "Group 1069")
            self.gotoEndV.backgroundColor = UIColor.secondaryColor
            self.newOrderTite.textColor = UIColor.brownMainColor
            self.endImg.image = UIImage(named: "Ellipse 70")
            self.gotoEndV.backgroundColor = UIColor.secondaryColor
            self.inProgTitle.textColor = UIColor.secondaryColor
            self.endImg.image = UIImage(named: "Ellipse 70")
            self.endTitle.textColor = UIColor.secondaryColor
            
        }else if orderStatus == "6"  {
            self.inWayImg.image = UIImage(named: "Group 1069")
            self.inProgImg.image = UIImage(named: "Ellipse 69")
            self.inWayTitle.textColor = UIColor.brownMainColor
            self.inProgV.backgroundColor = UIColor.brownMainColor
            multiButtonOutlet.setTitle("startWork".localized, for: .normal)
            multiButtonOutlet.tag = 121
        } else if orderStatus == "2" {
            //In progress
            self.inWayImg.image = UIImage(named: "Group 1069")
            self.inProgImg.image =  UIImage(named: "Group 1069")
            self.endImg.image = UIImage(named: "Ellipse 69")
            self.inWayV.backgroundColor = UIColor.brownMainColor
            self.inProgV.backgroundColor = UIColor.brownMainColor
            self.gotoEndV.backgroundColor = UIColor.brownMainColor
            self.newOrderTite.textColor = UIColor.brownMainColor
            self.inWayTitle.textColor = UIColor.brownMainColor
            self.inProgTitle.textColor = UIColor.brownMainColor
            multiButtonOutlet.setTitle("finishWork".localized, for: .normal)
            multiButtonOutlet.tag = 122
            multiButtonOutlet.backgroundColor = UIColor.redColor
            imagesView.isHidden = false
        } else if orderStatus == "3" {
//            finished order
            //  self.problemlblConst.constant = 124
            self.addButtonsStackView.isHidden = true
            self.inWayImg.image = UIImage(named: "Group 1069")
            self.inProgImg.image  =  UIImage(named: "Group 1069")
            self.endImg.image  =  UIImage(named: "Group 1069")
            self.inWayV.backgroundColor = UIColor.brownMainColor
            self.inProgV.backgroundColor = UIColor.brownMainColor
            self.gotoEndV.backgroundColor = UIColor.brownMainColor
            self.newOrderTite.textColor = UIColor.brownMainColor
            self.inWayTitle.textColor = UIColor.brownMainColor
            self.inProgTitle.textColor = UIColor.brownMainColor
            self.endTitle.textColor = UIColor.brownMainColor
            if let data = data {
                if let url = URL(string: data.finish_image ?? "") {
                    let placeholderImage = UIImage(named: "Group 1059")!
                    finishImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
                }
            }
           
            
            multiButtonOutlet.isHidden = true
        }else if orderStatus == "4" {
            //   self.problemlblConst.constant = 20
            self.newOrderImg.image = UIImage(named: "Group 1069")
            self.inWayV.backgroundColor = UIColor.brownMainColor
            self.newOrderTite.textColor = UIColor.brownMainColor
            self.inWayImg.image = UIImage(named: "Group 1070")
            self.inWayTitle.textColor = UIColor.red
            self.inWayTitle.text = "canceled".localized
            self.gotoEndV.alpha = 0
            self.endImg.alpha = 0
            self.endTitle.alpha = 0
            self.inProgV.alpha = 0
            self.inProgTitle.alpha = 0
            self.inProgImg.alpha = 0
            
        }else if orderStatus == "5" {
            // new
            print(data?.team_added_price_desc)
            
            if data?.team_added_price_desc == [] {
                print("hello")
                
            }else{
                
                self.team_added_price_desc = data!.team_added_price_desc
                self.team_added_price = data!.team_added_price
            }
            
            self.newOrderImg.image = UIImage(named: "Group 1069")
            self.gotoEndV.backgroundColor = UIColor.brownMainColor
            self.newOrderTite.textColor = UIColor.brownMainColor
            self.endImg.image = UIImage(named: "Ellipse 69")
            self.gotoEndV.backgroundColor = UIColor.secondaryColor
            self.inProgTitle.textColor = UIColor.secondaryColor
            self.endImg.image = UIImage(named: "Ellipse 70")
            self.endTitle.textColor = UIColor.secondaryColor
            
        }
        
    }
    
    
    
    
    func popView () {
        let tabBar = self.tabBarController as? TabBarController
        self.dismissViewC()
        tabBar?.showTab()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.popView()
    }
    
    func acceptOrRefusePrice (status : String){
        //  if status == "1" {self.priceStack.alpha = 0}
        ad.isLoading()
        APIClient.sendAcceptPrice(order_id: data!.id!, status: status, completionHandler: { (state, sms) in
            ad.killLoading()
            guard state else {
                return
            }
            if status == "2" {
                self.showDAlert(title: "", subTitle: "TheRequestDone".localized, type: .success, buttonTitle: "done".localized ) { (ـ) in
                    self.popView()
                }
            }
            
            //  self.showDAlert(title: "", subTitle: " تم قبول الطلب", type: .success, buttonTitle: "done".localized , completionHandler: nil)
            
        }) { (err) in
            ad.killLoading()
            print("error")
        }
        
    }
    
}

//extension EmergencyOrderDetailesTeamVC : endFinalWork {
//    func endFinalWork(state: Bool, pay_by: String?) {
//        if state {
//            EndFinalWorkEmergency()
//
//        }
//    }
//
//
//}




//
    
//    func getOrderDetails (order_id : Int) {
//        ad.isLoading()
//        APIClient.getUserEmergencyOrder(order_id: order_id, completionHandler: { (state, sms , data) in
//            ad.killLoading()
//            print(state)
//
//            guard state else{
//                self.showDAlert(title:  "Error".localized, subTitle: "tryAgain".localized , type: .withContent, buttonTitle: "tryAgain".localized) { (_) in
//                    self.goToHome()
//                }
//                return
//            }
//            if let data = data {
//                DispatchQueue.main.async {
//                    self.data = data
//                    self.maintitle.text = data.title
//                    self.probImages = data.images
//                    self.date.text = data.date
//                    self.orderNum.text = "#\(data.order_number!)"
//                    self.setStatus(orderStatus: data.order_status!)
//                    self.noteLbl.text = data.notes
//                }
//            }
//        }) { (error) in
//            ad.killLoading()
//            self.showDAlert(title:  "Error".localized, subTitle: "tryAgain".localized , type: .withContent, buttonTitle: "tryAgain".localized) { (_) in
//                self.goToHome()
//            }
//            print(error)
//        }
//    }
    



//        APIClient.emergencyFinishWork(order_id: data!.id!, completionHandler: { (state, sms) in
//            ad.killLoading()
//            guard state else{
//                return
//            }
//            self.showDAlert(title: "", subTitle: "requestDone".localized, type: .success, buttonTitle: "done".localized ) { (_) in
//                self.goToHome()
//            }
//
//        }) { (error) in
//            ad.killLoading()
//            print("Error")
//        }
