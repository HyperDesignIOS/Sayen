//
//  HomeUserVC.swift
//  Sayen 
//
//  Created by Maher on 6/9/20.
//

import UIKit
import Firebase

class HomeUserVC: UIViewController {

    @IBOutlet weak var noDataLbl: UILabel!
    
    @IBOutlet weak var HeadView: UICollectionReusableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
     var data : [HomeData] = []
    var dataProfile: UserProfile_Data?
    var name : String = ""
    var user : UserProfile_Data? = nil
    
    
     lazy var refresher : UIRefreshControl = {
              let refresher = UIRefreshControl()
              refresher.tintColor = .white
              refresher.addTarget(self, action: #selector(getAllServices), for: .valueChanged)
              return refresher
            }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentToken()
       print(Constants.current_Language,"-----------")
        self.collectionView.register(UINib(nibName: "HomeUserCell", bundle: nil), forCellWithReuseIdentifier: "HomeUserCell")
        collectionView.register(UINib(nibName: "HomeHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeHeader")
        collectionView.semanticContentAttribute = .forceRightToLeft
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.addSubview(refresher)
        ad.checkIfTokenSent()
//        if let navigationController = self.navigationController{
//            navigationController.setStatusBar(backgroundColor: UIColor(rgb: 0x1F3D69))
//                    }
//        if let navigationController = self.navigationController{
//                  navigationController.setStatusBar(backgroundColor: .secondaryWhiteColor)
//                      }
   
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
        APIClient.getServices(completionHandler: {[weak self] (state, data,user)  in
            guard let self = self else {return}
            guard state else{
                self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                ad.killLoading()
                return
            }
            if let user = user {
                self.user = user
            }
            if let data = data {
                if data.count == 0 {
                    self.noDataLbl.alpha = 1
                    self.collectionView.reloadData()
                    self.noDataLbl.text = "جاري اضافه خدمات للتطبيق"
                }else{
                    print(data[0].checkSub)
                    self.noDataLbl.alpha = 0
                    self.data = data
                    self.collectionView.reloadData()
                    ad.killLoading()
                }
               
            }
            
            
        }) { (err) in
            ad.killLoading()
            self.refresher.endRefreshing()
            self.noDataLbl.alpha = 1
            self.noDataLbl.text = "noInternetConnection".localized
            self.data = []
            self.collectionView.reloadData()
           // self.noDataLbl.alpha = 1
            self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)

            print(err)
        }
    }

}

