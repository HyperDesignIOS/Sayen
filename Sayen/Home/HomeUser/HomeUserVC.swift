//
//  HomeUserVC.swift
//  Sayen 
//
//  Created by Maher on 6/9/20.
//

import UIKit
import Firebase

class HomeUserVC: UIViewController , EmergancyVCDelegate {

    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var HeadView: UICollectionReusableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var services : [HomeData] = []
    var dataProfile: UserProfile_Data?
    var name : String = ""
    var user : UserProfile_Data? = nil
    var emergenacyServices : [EmService] = []
    var offers : [OfferService] = []
    var emergencyInfoText : String = ""
     lazy var refresher : UIRefreshControl = {
              let refresher = UIRefreshControl()
              refresher.tintColor = .white
              refresher.addTarget(self, action: #selector(getAllServices), for: .valueChanged)
              return refresher
            }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentToken()
//        getOffers()
       print(Constants.current_Language,"-----------")
       handleCollectionView()
        ad.checkIfTokenSent()
//    checkVersion()
//        if let navigationController = self.navigationController{
//            navigationController.setStatusBar(backgroundColor: UIColor(rgb: 0x1F3D69))
//                    }
//        if let navigationController = self.navigationController{
//                  navigationController.setStatusBar(backgroundColor: .secondaryWhiteColor)
//                      }
   
    }
    
    
    func checkVersion(){
        VersionCheck.shared.isUpdateAvailable() { hasUpdates in
            if hasUpdates {
                self.showDAlert(title: "DearUser".localized, subTitle: "NewVersionAvailable".localized, type: .updateRequired, buttonTitle: "update".localized) { _ in
                    if let url = URL(string: Constants.userAppstoreUrl) {
                        UIApplication.shared.open(url)
                    }
                }
            }
        }
    }
    
    func emergancyRequestButton(_ sender: UIButton){
        let vc = EmergencyServiceAlert()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func onDismissAlert(send message: String, serviceId: Int) {
        if !message.isEmpty , message != "alertNote".localized{
            ad.isLoading()
            APIClient.emergencyOrder(noteStr: message, serviceId: serviceId) { status, msg, orderId in
                if status {
                    ad.killLoading()
                    self.showDAlert(title: "thanks".localized, subTitle:  "emergancyRequestSent".localized, type: .success, buttonTitle: "") { (_) in
                        self.gotoOrders()
                    }
                }
            } completionFaliure: { error in
                ad.killLoading()
                print(error?.localizedDescription)
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
    func getCurrentToken(){
        if let token = Messaging.messaging().fcmToken {
            print(token)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //  UserDefaults.standard.set(1, forKey: "banned")
        let tabBar = self.tabBarController as! TabBarController
        tabBar.showTab()
        getProfileData()
        
        if Constants.UserName == "" {
            self.name = Constants.phoneNum
        }else{
            if Constants.UserName.count > 20 {
                let xx = Constants.UserName.prefix(20)
                self.name = "\(xx)..."
            }else{
                 self.name = Constants.UserName
            }
        }
        getAllServices()
    }
    
    
//    func getOffers(){
//        APIClient.offers(service_id: 0) { state, offers in
//            if let offers = offers {
//                if !offers.isEmpty {
//                    self.offers = offers
//
//                }
//            }
//        } completionFaliure: { error in
//            print(error?.localizedDescription)
//        }
//
//    }
    func getProfileData() {
        APIClient.getProfileData(user_type: ad.user_type(), completionHandler: {[weak self] (state, sms, data) in
            guard let self = self else {return}
            guard state else{
                ad.killLoading()
                return
            }
            
            DispatchQueue.main.async {
                if let data = data {
                    self.dataProfile = data
                    Constants.UserId = data.id  
                    if data.active == "0" {
                        ad.bnannedAccount(databanned: "201")
                    }
                }
            }
        })  { (err) in
            print("errr")
        }
    }
   
    @objc func getAllServices (){
        ad.isLoading()
        self.refresher.endRefreshing()
        APIClient.getServices(completionHandler: {[weak self] (state, data, offers , user, settingsData, emergenacyServices)    in
            guard let self = self else {return}
            guard state else{
                self.showDAlert(title: "", subTitle: "yourSessionHasBeenEnded".localized, type: .updateRequired, buttonTitle: "login".localized) { _ in
                    ad.restartApplicationToLogin()
                    UserDefaults.standard.setValue(nil, forKey: Constants.firebaseTokenKey)
                    Constants.user_token = "" 
                }
                ad.killLoading()
                return
            }
            if let user = user {
                self.user = user
            }
            if let settingsData = settingsData {
                self.emergencyInfoText = settingsData.textEmergency
                 let bEndVersion = settingsData.userAppIosVersion
                    if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                        let compare =  appVersion.versionCompare(bEndVersion)
                        if compare == .orderedAscending {
                            self.showDAlert(title: "DearUser".localized, subTitle: "NewVersionAvailable".localized, type: .updateRequired, buttonTitle: "update".localized) { _ in
                                if let url = URL(string: Constants.userAppstoreUrl) {
                                    UIApplication.shared.open(url)
                                }
                            }
                        }
                    }
                
            }
            if !emergenacyServices.isEmpty {
                self.emergenacyServices = emergenacyServices
            }
            if let data = data {
                if data.count == 0 {
                    self.noDataLbl.alpha = 1
                    self.collectionView.reloadData()
                    self.noDataLbl.text = "جاري اضافه خدمات للتطبيق"
                }else{
                    print(data[0].checkSub)
                    self.noDataLbl.alpha = 0
                    self.services = data
          
                    if let offers = offers {
                        self.offers = offers
                        if !offers.isEmpty {
                            self.services.insert(data[0], at: 0)
                        }
                    }
                    self.services.insert(data[0], at: 0)
                    self.collectionView.reloadData()
                    ad.killLoading()
                }
            }
        }) { (err) in
            ad.killLoading()
            self.refresher.endRefreshing()
            self.noDataLbl.alpha = 1
            self.noDataLbl.text = "noInternetConnection".localized
            self.services = []
            self.collectionView.reloadData()
           // self.noDataLbl.alpha = 1
            self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)

            print(err)
        }
    }

}

