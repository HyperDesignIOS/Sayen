//
//  EmergencyOrderDetailesVC.swift
//  Sayen 
//
//  Created by ME-MAC on 2/3/22.
//


import UIKit

class EmergencyOrderDetailesVC: UIViewController {
    
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
    @IBOutlet weak var rateButtonOutlet: UIButton!

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
        self.rateButtonOutlet.isHidden = true
        getOrderDetails(order_id: order_id)
    }

    
    
    func getOrderDetails (order_id : Int) {
        ad.isLoading()
        APIClient.getUserEmergencyOrder(order_id: order_id, completionHandler: { (state, sms , data) in
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
                    self.data = data
                    self.maintitle.text = data.title
                    self.probImages = data.images
                    self.date.text = data.date
                    self.orderNum.text = "#\(data.order_number!)"
                    self.setStatus(orderStatus: data.order_status!)
                    self.noteLbl.text = data.notes
                }
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
            
        } else if orderStatus == "2" {
        
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
          
            
            //  self.problemlblConst.constant = 124
                        
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
            self.rateButtonOutlet.isHidden = false
            if data?.service_rated == 0 {
                self.showDAlert(title: "", subTitle:"rateRequestMsg".localized, type: .success, buttonTitle: "تقييم") { (ـ) in
                    let vc = RatingVC()
                    vc.order_id = self.data!.id!
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }
            
            //Group 1070
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

    @IBAction func rateButton(_ sender: UIButton){
        let vc = RatingVC()
        vc.order_id = self.data!.id!
        vc.controllerType = .EmergencyOrder
        self.navigationController?.pushViewController(vc, animated: false)
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
    
    
    @IBAction func cancelOrder(_ sender: Any) {
        let vc = CancelOrderAlert()
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
      //  self.navigationController?.pushViewController(vc, animated: false)
        
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





extension EmergencyOrderDetailesVC : AcceptPrice {
    func acceptPrice(Status: String) {
        self.btnsState = Status == "1" ? true : false
        self.statePrice = Status
        self.acceptOrRefusePrice(status: Status)
     //   self.mainPrice.text = "\(data!.total_before_discount!) " + "Rial".localized
     //   self.copuonPrice.text = "\(data!.final_price!) " + "Rial".localized
    }
    
    
}


extension EmergencyOrderDetailesVC : EndYesOrNo {
    func EndOrderAndFinish(state: Bool) {
        if state {
            self.finshOrder()
        }
    }
    
    
}
