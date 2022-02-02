//
//  SubServiceVC.swift
//  Sayen 
//
//  Created by ME-MAC on 2/2/22.
//


import UIKit
import Firebase

class SubServiceVC: UIViewController {

    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var navTitleLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
     var data : [HomeData] = []
    var user : UserProfile_Data? = nil
    var subServiceId = Int()
    var subServiceTitle = String()
    
     lazy var refresher : UIRefreshControl = {
              let refresher = UIRefreshControl()
              refresher.tintColor = .white
              refresher.addTarget(self, action: #selector(getSubServices), for: .valueChanged)
              return refresher
            }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentToken()
        handleCollectionView()
        ad.checkIfTokenSent()

   
    }
    
    func getCurrentToken(){
        if let token = Messaging.messaging().fcmToken {
            print(token)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navTitleLbl.text = subServiceTitle
        getSubServices()
    }
    
    @objc func getSubServices (){
        ad.isLoading()
        self.refresher.endRefreshing()
        APIClient.getSubServices (serviceId : subServiceId ,completionHandler: {[weak self] (state, data,user)  in
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
    @IBAction func backButton(_ sender: UIButton) {
        self.dismissViewC()
    }
    
}

