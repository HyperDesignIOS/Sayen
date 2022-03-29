//
//  HomeWorkerVC.swift
//  Sayen  Worker
//
//  Created by Maher on 6/4/20.
//

import UIKit
import CoreLocation

class HomeWorkerVC: UIViewController {

    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var teamImage: UIImageView!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateCollection: UICollectionView!
    
    var DateOpM = dateOp()
    var dataprofile: UserProfile_Data?
    var dayNumArr : [String] = []
    var monthArr : [String] = []
    var allDayes : [String] = []
    var data : [TeamOrderList] = []
    var lat : Double = 0
    var lng : Double = 0
    let locationManager = CLLocationManager()
    var getDateParm : String  = ""{
        didSet{
            self.getOrderData()
        }
    }
    var didUpdateLocation = false
    lazy var refresher : UIRefreshControl = {
           let refresher = UIRefreshControl()
           refresher.addTarget(self, action: #selector(getOrderData), for: .valueChanged)
           return refresher
         }()
 

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let dayarr = DateOpM.mydayNum
        let dayMonth = DateOpM.myMounthName
        let allday = DateOpM.AllDaysFunc()
        self.teamImage.layer.cornerRadius = 25
        dayNumArr = Array(dayarr.prefix(30))
        monthArr = Array(dayMonth.prefix(30))
        allDayes = Array(allday.prefix(30))
        print(dayNumArr)
        print(monthArr)
         ad.checkIfTokenSent()
         dateCollection.transform = CGAffineTransform(scaleX: -1, y: 1)
        
        dateCollection.register(UINib(nibName: "DateCell", bundle: nil), forCellWithReuseIdentifier: "DateCell")
        dateCollection.dataSource = self
        dateCollection.delegate = self
        
        
        //  dateCollection.allowsMultipleSelection = false
        
        self.tableView.register(UINib(nibName: "OrderWorkerCell", bundle: nil), forCellReuseIdentifier: "OrderWorkerCell")
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.addSubview(refresher)
        
                let indexPath:IndexPath = IndexPath(row: 0, section: 0)
        dateCollection?.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
     
        locationManager.requestWhenInUseAuthorization()
              
              if CLLocationManager.locationServicesEnabled(){
                  locationManager.delegate = self
                  locationManager.desiredAccuracy = kCLLocationAccuracyBest
                  locationManager.startUpdatingLocation()
              }
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name:  Notification.Name("didReceiveData"), object: nil)
        viewWillAppearCode()
    }
    
    @objc func onDidReceiveData(_ notification:Notification) {
        // Do something now
        if UIApplication.topViewController()  is HomeWorkerVC {
        viewWillAppearCode()
        }
    }

     func getProfileData() {
        APIClient.getProfileData(user_type: ad.user_type(), completionHandler: { (state, sms, data) in
            guard state else{
              
                self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                return
            }

            DispatchQueue.main.async {
              
                if let data = data {
                    self.dataprofile = data
                    self.teamName.text = "مرحبا \(data.name)"
                    if data.active == "0" {
                        ad.bnannedAccount(databanned: "201")
                    }
                    
                    if let url = URL(string: data.imageLink) {
                        let placeholderImage = UIImage(named: "imageProfile")!
                        self.teamImage.af_setImage(withURL: url, placeholderImage: placeholderImage)
                    }


                }

            }
        })  { (err) in
        
           // self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            print("errr")
        }
    }

    
    func viewWillAppearCode() {
        getProfileData()
        if self.getDateParm == "" {
            self.getDateParm = DateOpM.returnCurrntdateDay()
        }
        self.tableView.reloadData()
        self.didUpdateLocation = false
        locationManager.startUpdatingLocation()

    }
    @objc func getOrderData(){
        ad.isLoading()
        self.refresher.endRefreshing()
        
        APIClient.getWorkerOrders(date: self.getDateParm, completionHandler: { (state, data, leastAppVersion ) in
            ad.killLoading()
            guard state else {
                 self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                return
            }
//            if let leastAppVersion = leastAppVersion {
//                if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
//                    if appVersion != leastAppVersion {
//                        self.showDAlert(title: "DearUser".localized, subTitle: "NewVersionAvailable".localized, type: .updateRequired, buttonTitle: "update".localized) { _ in
//                            if let url = URL(string: Constants.workerAppstoreUrl) {
//                                UIApplication.shared.open(url)
//                            }
//                        }
//                    }
//                }
//            }
            if let data = data {
                self.data = data
                if data.count == 0 {
                    self.noDataLbl.alpha = 1
                    self.tableView.reloadData()
                   // self.tableView.alpha = 0
                }else{
                    self.noDataLbl.alpha = 0
                  //  self.tableView.alpha = 1
                    self.tableView.reloadData()
                }
            }
        }) { (err) in
            ad.killLoading()
            self.data = []
            self.noDataLbl.alpha = 1
            self.tableView.reloadData()
               self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            print(err)
        }
    }

   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
                NotificationCenter.default.removeObserver(self)

    }
    
    @IBAction func goProfile(_ sender: Any) {
 
        let vc = EditProfileVC()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    

    @IBAction func logOut(_ sender: Any) {
        //            ad.CurrentRootVC()?.showDAlert(title: "تسجيل خروج", subTitle: "اذا كنت متأكد من تسجيل الخروج اضغط نعم",type: .withContent,buttonTitle: "yes".localized, completionHandler: {   (status) in
        //
        //
        //                     guard ad.isOnline() else {
        //                          return
        //                     }
        //                      guard status else { return }
        //                     APIClient.logoutHandler(user_type : ad.user_type() , completionHandler: { (status) in
        //
        //                         guard status else { return }
        //                         DispatchQueue.main.async {
        //                         ad.save(userId: nil, token: nil)
        //                         UserDefaults.standard.setValue(nil, forKey: Constants.firebaseTokenKey)
        //                         ad.restartApplication()
        //
        //                         }
        //                     }) { (err) in
        //                         self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
        //
        //
        //                     }
        //                 })
        let vc = LogOutAlert()
       vc.modalTransitionStyle = .crossDissolve
       vc.modalPresentationStyle = .overFullScreen
       self.present(vc, animated: false)
     //   self.navigationController?.pushViewController(vc, animated: false)
    }
    
   
}
//    @IBAction func logOut(_ sender: Any) {
//        //            ad.CurrentRootVC()?.showDAlert(title: "تسجيل خروج", subTitle: "اذا كنت متأكد من تسجيل الخروج اضغط نعم",type: .withContent,buttonTitle: "yes".localized, completionHandler: {   (status) in
//        //
//        //
//        //                     guard ad.isOnline() else {
//        //                          return
//        //                     }
//        //                      guard status else { return }
//        //                     APIClient.logoutHandler(user_type : ad.user_type() , completionHandler: { (status) in
//        //
//        //                         guard status else { return }
//        //                         DispatchQueue.main.async {
//        //                         ad.save(userId: nil, token: nil)
//        //                         UserDefaults.standard.setValue(nil, forKey: Constants.firebaseTokenKey)
//        //                         ad.restartApplication()
//        //
//        //                         }
//        //                     }) { (err) in
//        //                         self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
//        //
//        //
//        //                     }
//        //                 })
//        let vc = LogOutAlert()
//       vc.modalTransitionStyle = .crossDissolve
//       vc.modalPresentationStyle = .overFullScreen
//       self.present(vc, animated: false)
//     //   self.navigationController?.pushViewController(vc, animated: false)
//    }
