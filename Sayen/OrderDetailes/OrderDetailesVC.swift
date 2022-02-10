//
//  OrderDetailesVC.swift
//  Sayen 
//
//  Created by Maher on 6/12/20.
//

import UIKit

class OrderDetailesVC: UIViewController {
    
    @IBOutlet weak var truePay: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
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
    @IBOutlet weak var workerView: CardView!
    @IBOutlet weak var workerImage: UIImageView!
    @IBOutlet weak var workerName: UILabel!
    @IBOutlet weak var mainPrice: UILabel!
    @IBOutlet weak var coponView: UIView!
    @IBOutlet weak var copuonPrice: UILabel!
    @IBOutlet weak var cashState: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var imagesCollection: UICollectionView!
//    @IBOutlet weak var problemlblConst: NSLayoutConstraint!
    @IBOutlet weak var paymentMethodLbl: UILabel!
    @IBOutlet weak var cashConstant: NSLayoutConstraint!
    @IBOutlet weak var rateBtn: UIButtonX!
    @IBOutlet weak var totalPrcieView: UIView!
    @IBOutlet weak var priceStack: UIStackView!
    @IBOutlet weak var totalPriceConst: NSLayoutConstraint!
    @IBOutlet weak var rateStack: UIStackView!
    @IBOutlet weak var upGroundView: UIView!
    @IBOutlet weak var waitViewOrder: CardView!
    @IBOutlet weak var cancelOrder: UIButtonX!
    @IBOutlet weak var cancelLbl: UILabel!
    @IBOutlet weak var notesHieght: NSLayoutConstraint!
    @IBOutlet weak var clientContainerV: UIView!
    @IBOutlet weak var clientTypeLbl: UILabel!
    @IBOutlet weak var paymenSourceContainerV: UIView!
    @IBOutlet weak var paymentSourceLbl: UILabel!
    @IBOutlet weak var problemImageLblTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var requestWarrantyButtonOutlet: UIButtonX!
    @IBOutlet weak var showWarrantyButtonOutlet: UIButtonX!
    
    
    var tabBar : UITabBarController?
    var statePrice : String = ""
    var order_id : Int = 0
    var order_status : String = ""
    var data : OrderDetails?
    var probImages : [String] = []
    var imgSenf : UIImageView = UIImageView()
    var team_added_price_desc : [String] = []
    var team_added_price : [String] = []
    var btnsState = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paymenSourceContainerV.isHidden = true
        clientContainerV.isHidden = true
        rateBtn.semanticContentAttribute = .forceRightToLeft
        imagesCollection.semanticContentAttribute = .forceRightToLeft
        let tabBar = self.tabBarController as? TabBarController
        tabBar?.hideTab()
        self.workerImage.layer.cornerRadius = 20
        getOrderDetails(order_id: order_id)
        self.imagesCollection.register(UINib(nibName: "imagesCell", bundle: nil), forCellWithReuseIdentifier: "imagesCell")
        self.imagesCollection.delegate = self
        self.imagesCollection.dataSource = self
    }

    
    func getOrderDetails (order_id : Int) {
        ad.isLoading()
        APIClient.getUserOrder(order_id: order_id, completionHandler: { (state, sms , data) in
            ad.killLoading()
            print(state)
            
            guard state else{
                self.showDAlert(title:  "Error".localized, subTitle: "tryAgain".localized , type: .withContent, buttonTitle: "tryAgain".localized) { (_) in
                              self.goToHome()
                          }
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    self.clientContainerV.isHidden = false
                    self.paymenSourceContainerV.isHidden = !data.orderIsFinished

                    self.clientTypeLbl.text = data.isExcellenceClient ? "special".localized : "other".localized
                    self.paymentSourceLbl.text = data.pay_by == "1" ? "client".localized :
                    "owner".localized
                    self.paymentMethodLbl.text = data.pay_method == "1" ? "PayCash".localized : "payOnline".localized
                    self.truePay.alpha = 0
                    if data.pay_status == "1" {
                        self.cashState.text = "paid".localized
                        self.truePay.alpha = 1
                        self.cashState.textColor = .greenColor
                    }
                    self.upGroundView.alpha = 0
                    self.data = data
                    self.maintitle.text = data.title
                    self.probImages = data.images
                    self.imagesCollection.reloadData()
                    self.notes.text = data.notes
                    let numofline = self.notes.contentSize.height
                    if numofline < 50 {
                        self.notesHieght.constant = 40
                    }
                    self.date.text = data.date
                    self.mainPrice.text = "\(data.initial_price!) " + "Rial".localized
                    self.orderNum.text = "#\(data.order_number!)"
                    self.setStatus(orderStatus: data.order_status!)
                    if data.warranty == "1" && data.order_status == "3" && data.type == "order" {
                        self.requestWarrantyButtonOutlet.isHidden = false
                        self.showWarrantyButtonOutlet.isHidden = true
                    }else if data.warranty == "2" && data.order_status == "3" && data.type == "order" {
                        self.showWarrantyButtonOutlet.isHidden = false
                        self.requestWarrantyButtonOutlet.isHidden = true
                    }else {
                        self.requestWarrantyButtonOutlet.isHidden = true
                        self.showWarrantyButtonOutlet.isHidden = true
                    }
//                      self.setStatus(orderStatus: "3")
                  
                }
               
              //  print(self.probImages.count)
                
            }
        }) { (error) in
            ad.killLoading()
            self.showDAlert(title:  "Error".localized, subTitle: "tryAgain".localized , type: .withContent, buttonTitle: "tryAgain".localized) { (_) in
                self.goToHome()
            }
            print(error)
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
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 800)
            self.cancelOrder.alpha = 1
            self.workerView.alpha = 0
            self.waitViewOrder.alpha = 1
            self.totalPrcieView.alpha = 0
            self.priceStack.alpha = 0
            self.rateStack.alpha = 0
            if data?.coupon_discount == 0 {
                self.coponView.alpha = 0
                self.cashConstant.constant = 25
            }else{
                self.coponView.alpha = 1
                self.cashConstant.constant = 67
                self.copuonPrice.text = "\(data!.final_price!) " + "Rial".localized
            }
           
            self.newOrderImg.image = UIImage(named: "Group 1069")
            self.gotoEndV.backgroundColor = UIColor.secondaryColor
            self.newOrderTite.textColor = UIColor.brownMainColor
            self.endImg.image = UIImage(named: "Ellipse 70")
            self.gotoEndV.backgroundColor = UIColor.secondaryColor
            self.inProgTitle.textColor = UIColor.secondaryColor
            self.endImg.image = UIImage(named: "Ellipse 70")
            self.endTitle.textColor = UIColor.secondaryColor
            
        }else if orderStatus == "6"  {
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 800)
            self.cancelOrder.alpha = 1
            self.workerView.alpha = 0
            self.waitViewOrder.alpha = 1
            self.totalPrcieView.alpha = 0
            self.priceStack.alpha = 0
            self.rateStack.alpha = 0
            if data?.coupon_discount == 0 {
                self.coponView.alpha = 0
                self.cashConstant.constant = 25
            }else{
                self.coponView.alpha = 1
                self.cashConstant.constant = 67
                self.copuonPrice.text = "\(data!.final_price!) " + "Rial".localized
            }
           
            self.inWayImg.image = UIImage(named: "Group 1069")
            self.inProgImg.image = UIImage(named: "Ellipse 69")
            self.inWayTitle.textColor = UIColor.brownMainColor
            self.inProgV.backgroundColor = UIColor.brownMainColor
            
        } else if orderStatus == "2" {
            self.cancelOrder.alpha = 1
            self.workerView.alpha = 1
            self.workerName.text = "fanii".localized + " \(data!.team_name!)"
            self.mainPrice.text = "\(data!.initial_price!) " + "Rial".localized
            if let url = URL(string: data!.team_image!){
                let placeholderImage = UIImage(named: "imageProfile")!
                self.workerImage.af_setImage(withURL: url, placeholderImage: placeholderImage)
            }
            if data!.team_added_price.count == 0 {
                self.priceStack.alpha = 0
            }else{
               self.priceStack.alpha = 1
            }
            
            self.rateStack.alpha = 0
       
            self.workerView.alpha = 1
            self.waitViewOrder.alpha = 0
            self.totalPrcieView.alpha = 0
            if data?.coupon_discount == 0 {
                self.coponView.alpha = 0
                self.cashConstant.constant = 25
         
            }else{
                self.coponView.alpha = 1
                self.cashConstant.constant = 67
                self.copuonPrice.text = "\(data!.total_before_team_add_price!) " + "Rial".localized
            }
            self.inWayImg.image = UIImage(named: "Group 1069")
            self.inProgImg.image =  UIImage(named: "Group 1069")
            self.endImg.image = UIImage(named: "Ellipse 69")
            self.inWayV.backgroundColor = UIColor.brownMainColor
            self.inProgV.backgroundColor = UIColor.brownMainColor
            self.gotoEndV.backgroundColor = UIColor.brownMainColor
            self.newOrderTite.textColor = UIColor.brownMainColor
            self.inWayTitle.textColor = UIColor.brownMainColor
            self.inProgTitle.textColor = UIColor.brownMainColor
            
            
        } else if orderStatus == "3" {
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 750)
            self.cancelOrder.alpha = 0
            self.workerView.alpha = 0
            self.waitViewOrder.alpha = 0
            self.problemImageLblTopConstraint.constant = 20
            if data!.team_added_price.count == 0 {
                 self.priceStack.alpha = 0
            }else{
               self.priceStack.alpha = 1
            }
           
            
            self.rateStack.alpha = data?.service_rated == 0 ? 1 : 0
          
            self.mainPrice.text = "\(data!.initial_price!) " + "Rial".localized
            self.totalPrice.text = "\(data!.final_price!) " + "Rial".localized
            self.cashState.text = "paid".localized
            self.truePay.alpha = 1
            self.cashState.textColor = .greenColor
            self.workerName.text = "fanii".localized + " \(data!.team_name!)"
            if let url = URL(string: data!.team_image!){
                let placeholderImage = UIImage(named: "imageProfile")!
                self.workerImage.af_setImage(withURL: url, placeholderImage: placeholderImage)
            }
            //  self.problemlblConst.constant = 124
            self.totalPrcieView.alpha = 1
            if data?.coupon_discount == 0 {
                self.coponView.alpha = 0
                self.cashConstant.constant = 60
                self.totalPriceConst.constant = 10
            }else{
                self.coponView.alpha = 1
                self.cashConstant.constant = 97
                self.copuonPrice.text = "\(data!.total_before_discount! - data!.initial_price! - data!.coupon_discount!) " + "Rial".localized
            }
            
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
            if data?.service_rated == 0 {
                self.showDAlert(title: "", subTitle:"rateRequestMsg".localized, type: .success, buttonTitle: "تقييم") { (ـ) in
                    let vc = RatingVC()
                    vc.order_id = self.data!.id!
                    vc.controllerType = .order
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }
            
            //Group 1070
        }else if orderStatus == "4" {
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 600)
            self.workerView.alpha = 0
            self.waitViewOrder.alpha = 1
            self.totalPrcieView.alpha = 0
            self.cancelLbl.text = "canceled".localized
            self.cancelOrder.alpha = 0
            self.rateStack.alpha = 0
            
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
            if data?.coupon_discount == 0 {
                self.coponView.alpha = 0
                self.cashConstant.constant = 25
            }else{
                self.coponView.alpha = 1
                self.cashConstant.constant = 67
                self.copuonPrice.text = "\(data!.final_price!) " + "Rial".localized
            }
        }else if orderStatus == "5" {
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 800)
            
            self.cancelOrder.alpha = 1
            self.workerView.alpha = 1
            self.waitViewOrder.alpha = 0
            //             self.problemlblConst.constant = 20
            self.totalPrcieView.alpha = 0
            
            print(data?.team_added_price_desc)
            
            if data?.team_added_price_desc == [] {
                print("hello")
                self.priceStack.alpha = 0
            }else{
                
             //   if data!.user_accept_added_price! == "1" {
             //       self.priceStack.alpha = 0
             //       self.mainPrice.text = "\(data!.total_before_discount!) " + "Rial".localized
            //    }else{
                    self.priceStack.alpha = 1
                    self.mainPrice.text = "\(data!.initial_price!) " + "Rial".localized
              //  }
                
                self.team_added_price_desc = data!.team_added_price_desc
                self.team_added_price = data!.team_added_price
            }
            
            self.rateStack.alpha = 0
            if data?.coupon_discount == 0 {
                self.coponView.alpha = 0
                self.cashConstant.constant = 25
            }else{
                self.coponView.alpha = 1
                self.cashConstant.constant = 67
             //   if data!.user_accept_added_price! == "1" {
              //      self.copuonPrice.text = "\(data!.final_price!) " + "Rial".localized
              //  }else{
                    self.copuonPrice.text = "\(data!.total_before_discount! - data!.initial_price! - data!.coupon_discount!) " + "Rial".localized
              //  }
            }
            
            if let url = URL(string: data!.team_image!){
                let placeholderImage = UIImage(named: "imageProfile")!
                self.workerImage.af_setImage(withURL: url, placeholderImage: placeholderImage)
            }
            self.workerName.text = "fanii".localized + " \(data!.team_name!)"
            
            
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
    
    
    
    @IBAction func showNewPrice(_ sender: Any) {
       let vc = AddPriceVC()
        vc.delegate = self
        vc.team_added_price_desc = data!.team_added_price_desc
        vc.team_added_price = data!.team_added_price
        vc.totPriceT = data!.final_price!
        var totalValue = 0.0
        for x in data!.team_added_price  {
            if let value = Double(x) {
                totalValue += value
            }
        }
        vc.newPriceT = totalValue //  data!.total_before_discount!
        vc.CoponDiscount = data!.coupon_discount!
        vc.order_id = data!.id!
        vc.btnsState = self.data!.user_accept_added_price == "1" ? true : false
        if self.btnsState {
            vc.btnsState = true
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
      //  self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func rateWork(_ sender: Any) {
        let vc = RatingVC()
        vc.order_id = data!.id!
        vc.controllerType = .order
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
//    func setImages (imgs : [String]) {
//        for img in imgs {
//            if let url = URL(string: img) {
//                let placeholderImage = UIImage(named: "imageProfile")!
//                self.imgSenf.af_setImage(withURL: url, placeholderImage: placeholderImage)
//                self.probImages.append(imgSenf)
//
//            }
//        }
//        self.imagesCollection.reloadData()
//        print(self.probImages.count)
//
//    }
        
  
    @IBAction func callWorker(_ sender: Any) {
        guard data!.team_phone != "" else {
            
                   return
               }
               print("that's the phone Number : \(data!.team_phone)")
               guard let pNum = data?.team_phone else { return }
               guard  let phoneCallURL:URL = URL(string: "tel:\(pNum)") else {
                  
                   return
               }
               let application:UIApplication = UIApplication.shared
               if (application.canOpenURL(phoneCallURL)) {
                   let alertController = UIAlertController(title: "", message:"continueAndCall".localized + " \n\(pNum)?", preferredStyle: .alert)
                let yesPressed = UIAlertAction(title: "yes".localized, style: .default, handler: { (action) in
                       application.openURL(phoneCallURL)
                   })
                let noPressed = UIAlertAction(title: "no".localized, style: .default, handler: { (action) in
                       
                   })
                   alertController.addAction(yesPressed)
                   alertController.addAction(noPressed)
                   present(alertController, animated: true, completion: nil)
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
    
    @IBAction func changePrice(_ sender: Any) {
    }
    
    
    @IBAction func viewNewPrice(_ sender: Any) {
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
    
    @IBAction func showWarrantyButton(_ sender: UIButton) {
        if let orderId = data?.order_id {
            let vc = OrderDetailesVC()
            vc.order_id = orderId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func cancelOrder(_ sender: Any) {
        let vc = CancelOrderAlert()
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
      //  self.navigationController?.pushViewController(vc, animated: false)
        
 }
    @IBAction func requestWarrantyButton(_ sender: UIButton) {
        
        guard let order_id = data?.id else {
            return
        }
        ad.isLoading()
        APIClient.requestWarranty(order_id: order_id, completionHandler: { (state, sms, orderId)  in
            
            guard state else {
                ad.killLoading()
                 self.showDAlert(title: "Error".localized, subTitle: sms , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                return
            }
            DispatchQueue.main.async {
                ad.killLoading()
                self.showDAlert(title: "", subTitle: sms, type: .success, buttonTitle: "done".localized ) { (ـ) in
                    if let orderId = orderId {
                        let vc = OrderDetailesVC()
                        vc.order_id = orderId
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }

            }
            print(sms)
        }) { (err) in
            ad.killLoading()
             self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            print(err)
        }
    }
    
       func finshOrder () {
           
            guard let order_id = data?.id else {
                return
            }
            ad.isLoading()
            APIClient.cancelOrder(order_id: order_id, completionHandler: { (state, sms) in
                
                guard state else {
                    ad.killLoading()
                     self.showDAlert(title: "Error".localized, subTitle: sms , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                    return
                }
                DispatchQueue.main.async {
                    ad.killLoading()
                    self.showDAlert(title: "", subTitle: sms, type: .success, buttonTitle: "done".localized ) { (ـ) in
                        self.popView()
                    }
//                    self.popView()
                   
                }
                print(sms)
            }) { (err) in
                ad.killLoading()
                 self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                print(err)
            }
        }
     }


extension OrderDetailesVC : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return probImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = self.imagesCollection.dequeueReusableCell(withReuseIdentifier: "imagesCell", for: indexPath) as! imagesCell
       
            if let url = URL(string: probImages[indexPath.row]) {
                cell.problemImg.kf.indicatorType = .activity
                cell.problemImg.kf.setImage(with: url)
            }
       
        
     //   cell.problemImg.image = self.probImages[indexPath.row].image
    cell.problemImg.layer.cornerRadius = 5
    cell.deleteBtn.alpha = 0
    return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        let w = self.imagesCollection.frame.width / 5.1
        let h =  self.imagesCollection.frame.height
        let size = CGSize(width: w , height: h)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         return 2
     }
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 2
     }
    
}


extension OrderDetailesVC : AcceptPrice {
    func acceptPrice(Status: String) {
        self.btnsState = Status == "1" ? true : false
        self.statePrice = Status
        self.acceptOrRefusePrice(status: Status)
     //   self.mainPrice.text = "\(data!.total_before_discount!) " + "Rial".localized
     //   self.copuonPrice.text = "\(data!.final_price!) " + "Rial".localized
    }
    
    
}


extension OrderDetailesVC : EndYesOrNo {
    func EndOrderAndFinish(state: Bool) {
        if state {
            self.finshOrder()
        }
    }
    
    
}
//
//{
//    if orderStatus == "2"{
//        //To in progress
//        self.inWayImg.image = UIImage(named: "Group 1069")
//        self.inProgImg.image =  UIImage(named: "Group 1069")
//        self.endImg.image = UIImage(named: "Ellipse 69")
//        self.inWayV.backgroundColor = UIColor.brownMainColor
//        self.inProgV.backgroundColor = UIColor.brownMainColor
//        self.newOrderTite.textColor = UIColor.brownMainColor
//        self.inWayTitle.textColor = UIColor.brownMainColor
//        self.inProgTitle.textColor = UIColor.brownMainColor
//
//        self.cashImgeTrue.alpha = 1
//        if data!.coupon_discount == 0 {
//            self.copounView.alpha = 0
//            self.finalPriceTopCons.constant = 16
//            //                self.mainViewHieght.constant = 150
//        }
//    }else if orderStatus == "3"{
//        //To end prog
//        self.inWayImg.image = UIImage(named: "Group 1069")
//        self.inProgImg.image  =  UIImage(named: "Group 1069")
//        self.endImg.image  =  UIImage(named: "Group 1069")
//        self.inWayV.backgroundColor = UIColor.brownMainColor
//        self.inProgV.backgroundColor = UIColor.brownMainColor
//        self.gotoEndV.backgroundColor = UIColor.brownMainColor
//        self.newOrderTite.textColor = UIColor.brownMainColor
//        self.inWayTitle.textColor = UIColor.brownMainColor
//        self.inProgTitle.textColor = UIColor.brownMainColor
//        self.endTitle.textColor = UIColor.brownMainColor
//        self.cashImgeTrue.alpha = 1
//        if data!.coupon_discount == 0 {
//            self.copounView.alpha = 0
//            self.finalPriceTopCons.constant = 16
//            //                self.mainViewHieght.constant = 150
//        }
//    }else if (orderStatus == "4") {
//        self.newOrderImg.image = UIImage(named: "Group 1069")
//        self.inWayV.backgroundColor = UIColor.brownMainColor
//        self.newOrderTite.textColor = UIColor.brownMainColor
//        self.inWayImg.image = UIImage(named: "Group 1070")
//        self.inWayTitle.textColor = UIColor.red
//        self.inWayTitle.text = "canceled".localized
//        self.inProgV.alpha = 0
//        self.gotoEndV.alpha = 0
//        self.inProgImg.alpha = 0
//        self.endImg.alpha = 0
//        self.inProgTitle.alpha = 0
//        self.endTitle.alpha = 0
//        self.cashImgeTrue.alpha = 0
//        self.payState.text = "غير مدفوع"
//        if data!.coupon_discount == 0 {
//            self.copounView.alpha = 0
//            self.finalPriceTopCons.constant = 16
//            //                self.mainViewHieght.constant = 150
//        }
//    }  else if orderStatus == "6"{
//        //To in way
//        self.inWayImg.image = UIImage(named: "Group 1069")
//        self.inProgImg.image = UIImage(named: "Ellipse 69")
//        self.inWayTitle.textColor = UIColor.brownMainColor
//        self.cashImgeTrue.alpha = 1
//        if data!.coupon_discount == 0 {
//            self.copounView.alpha = 0
//            self.finalPriceTopCons.constant = 16
//            //                self.mainViewHieght.constant = 150
//        }
//    }
//}



/////////////////

//{
//
//
//    if orderStatus == "1" {
//        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 800)
//        self.cancelOrder.alpha = 1
//        self.workerView.alpha = 0
//        self.waitViewOrder.alpha = 1
//        self.totalPrcieView.alpha = 0
//        self.priceStack.alpha = 0
//        self.rateStack.alpha = 0
//        if data?.coupon_discount == 0 {
//            self.coponView.alpha = 0
//            self.cashConstant.constant = 25
//        }else{
//            self.coponView.alpha = 1
//            self.cashConstant.constant = 67
//            self.copuonPrice.text = "\(data!.final_price!) " + "Rial".localized
//        }
//
//        self.newOrderImg.image = UIImage(named: "Group 1069")
//        self.gotoEndV.backgroundColor = UIColor.secondaryColor
//        self.newOrderTite.textColor = UIColor.brownMainColor
//        self.endImg.image = UIImage(named: "Ellipse 70")
//        self.gotoEndV.backgroundColor = UIColor.secondaryColor
//        self.inProgTitle.textColor = UIColor.secondaryColor
//        self.endImg.image = UIImage(named: "Ellipse 70")
//        self.endTitle.textColor = UIColor.secondaryColor
//
//    }else if orderStatus == "2" {
//        self.cancelOrder.alpha = 1
//        self.workerView.alpha = 1
//        self.workerName.text = "fanii".localized + " \(data!.team_name!)"
//        self.mainPrice.text = "\(data!.initial_price!) " + "Rial".localized
//        if let url = URL(string: data!.team_image!){
//            let placeholderImage = UIImage(named: "imageProfile")!
//            self.workerImage.af_setImage(withURL: url, placeholderImage: placeholderImage)
//        }
//        if data!.team_added_price.count == 0 {
//            self.priceStack.alpha = 0
//        }else{
//           self.priceStack.alpha = 1
//        }
//
//        self.rateStack.alpha = 0
//
//        self.workerView.alpha = 1
//        self.waitViewOrder.alpha = 0
//        self.totalPrcieView.alpha = 0
//        if data?.coupon_discount == 0 {
//            self.coponView.alpha = 0
//            self.cashConstant.constant = 25
//
//        }else{
//            self.coponView.alpha = 1
//            self.cashConstant.constant = 67
//            self.copuonPrice.text = "\(data!.total_before_team_add_price!) " + "Rial".localized
//        }
//        self.inWayImg.image = UIImage(named: "Group 1069")
//        self.inProgImg.image =  UIImage(named: "Group 1069")
//        self.endImg.image = UIImage(named: "Ellipse 69")
//        self.inWayV.backgroundColor = UIColor.brownMainColor
//        self.inProgV.backgroundColor = UIColor.brownMainColor
//        self.newOrderTite.textColor = UIColor.brownMainColor
//        self.inWayTitle.textColor = UIColor.brownMainColor
//        self.inProgTitle.textColor = UIColor.brownMainColor
//        self.newOrderImg.image = UIImage(named: "Group 1069")
//        self.gotoEndV.backgroundColor = UIColor.brownMainColor
//        self.newOrderTite.textColor = UIColor.brownMainColor
//        self.endImg.image = UIImage(named: "Group 1069")
//        self.gotoEndV.backgroundColor = UIColor.brownMainColor
//        self.inProgTitle.textColor = UIColor.brownMainColor
//        self.endImg.image = UIImage(named: "Ellipse 69")
//        self.endTitle.textColor = UIColor.secondaryColor
//
//    } else if orderStatus == "3" {
//        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 750)
//        self.cancelOrder.alpha = 0
//        self.workerView.alpha = 1
//        self.waitViewOrder.alpha = 0
//        if data!.team_added_price.count == 0 {
//             self.priceStack.alpha = 0
//        }else{
//           self.priceStack.alpha = 1
//        }
//
//
//        self.rateStack.alpha = data?.service_rated == 0 ? 1 : 0
//
//        self.mainPrice.text = "\(data!.initial_price!) " + "Rial".localized
//        self.totalPrice.text = "\(data!.final_price!) " + "Rial".localized
//        self.cashState.text = "مدفوع"
//        self.truePay.alpha = 1
//        self.cashState.textColor = .greenColor
//        self.workerName.text = "fanii".localized + " \(data!.team_name!)"
//        if let url = URL(string: data!.team_image!){
//            let placeholderImage = UIImage(named: "imageProfile")!
//            self.workerImage.af_setImage(withURL: url, placeholderImage: placeholderImage)
//        }
//        //  self.problemlblConst.constant = 124
//        self.totalPrcieView.alpha = 1
//        if data?.coupon_discount == 0 {
//            self.coponView.alpha = 0
//            self.cashConstant.constant = 60
//            self.totalPriceConst.constant = 10
//        }else{
//            self.coponView.alpha = 1
//            self.cashConstant.constant = 97
//            self.copuonPrice.text = "\(data!.total_before_discount! - data!.initial_price! - data!.coupon_discount!) " + "Rial".localized
//        }
//
//        self.newOrderImg.image = UIImage(named: "Group 1069")
//        self.gotoEndV.backgroundColor = UIColor.brownMainColor
//        self.newOrderTite.textColor = UIColor.brownMainColor
//        self.endImg.image = UIImage(named: "Group 1069")
//        self.gotoEndV.backgroundColor = UIColor.brownMainColor
//        self.inProgTitle.textColor = UIColor.brownMainColor
//        self.endImg.image = UIImage(named: "Group 1069")
//        self.endTitle.textColor = UIColor.brownMainColor
//        if data?.service_rated == 0 {
//            self.showDAlert(title: "", subTitle:"rateRequestMsg".localized, type: .success, buttonTitle: "تقييم") { (ـ) in
//                let vc = RatingVC()
//                vc.order_id = self.data!.id!
//                self.navigationController?.pushViewController(vc, animated: false)
//            }
//        }
//
//        //Group 1070
//    }else if orderStatus == "4" {
//        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 600)
//        self.workerView.alpha = 0
//        self.waitViewOrder.alpha = 1
//        self.totalPrcieView.alpha = 0
//        self.cancelLbl.text = "canceled".localized
//        self.cancelOrder.alpha = 0
//        self.rateStack.alpha = 0
//
//        //   self.problemlblConst.constant = 20
//
//
//        self.newOrderImg.image = UIImage(named: "Group 1069")
//        self.gotoEndV.backgroundColor = UIColor.brownMainColor
//        self.newOrderTite.textColor = UIColor.brownMainColor
//        self.endImg.image = UIImage(named: "Group 1070")
//        self.inProgTitle.textColor = UIColor.red
//        self.inProgTitle.text = "canceled".localized
//        self.gotoEndV.alpha = 0
//        self.endImg.alpha = 0
//        self.endTitle.alpha = 0
//        if data?.coupon_discount == 0 {
//            self.coponView.alpha = 0
//            self.cashConstant.constant = 25
//        }else{
//            self.coponView.alpha = 1
//            self.cashConstant.constant = 67
//            self.copuonPrice.text = "\(data!.final_price!) " + "Rial".localized
//        }
//    }else if orderStatus == "5" {
//        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 800)
//
//        self.cancelOrder.alpha = 1
//        self.workerView.alpha = 1
//        self.waitViewOrder.alpha = 0
//        //             self.problemlblConst.constant = 20
//        self.totalPrcieView.alpha = 0
//
//        print(data?.team_added_price_desc)
//
//        if data?.team_added_price_desc == [] {
//            print("hello")
//            self.priceStack.alpha = 0
//        }else{
//
//         //   if data!.user_accept_added_price! == "1" {
//         //       self.priceStack.alpha = 0
//         //       self.mainPrice.text = "\(data!.total_before_discount!) " + "Rial".localized
//        //    }else{
//                self.priceStack.alpha = 1
//                self.mainPrice.text = "\(data!.initial_price!) " + "Rial".localized
//          //  }
//
//            self.team_added_price_desc = data!.team_added_price_desc
//            self.team_added_price = data!.team_added_price
//        }
//
//        self.rateStack.alpha = 0
//        if data?.coupon_discount == 0 {
//            self.coponView.alpha = 0
//            self.cashConstant.constant = 25
//        }else{
//            self.coponView.alpha = 1
//            self.cashConstant.constant = 67
//         //   if data!.user_accept_added_price! == "1" {
//          //      self.copuonPrice.text = "\(data!.final_price!) " + "Rial".localized
//          //  }else{
//                self.copuonPrice.text = "\(data!.total_before_discount! - data!.initial_price! - data!.coupon_discount!) " + "Rial".localized
//          //  }
//        }
//
//        if let url = URL(string: data!.team_image!){
//            let placeholderImage = UIImage(named: "imageProfile")!
//            self.workerImage.af_setImage(withURL: url, placeholderImage: placeholderImage)
//        }
//        self.workerName.text = "fanii".localized + " \(data!.team_name!)"
//
//
//        self.newOrderImg.image = UIImage(named: "Group 1069")
//        self.gotoEndV.backgroundColor = UIColor.brownMainColor
//        self.newOrderTite.textColor = UIColor.brownMainColor
//        self.endImg.image = UIImage(named: "Ellipse 69")
//        self.gotoEndV.backgroundColor = UIColor.secondaryColor
//        self.inProgTitle.textColor = UIColor.secondaryColor
//        self.endImg.image = UIImage(named: "Ellipse 70")
//        self.endTitle.textColor = UIColor.secondaryColor
//
//    }
//
//}
