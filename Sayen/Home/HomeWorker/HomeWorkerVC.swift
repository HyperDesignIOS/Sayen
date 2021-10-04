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
        
        APIClient.getWorkerOrders(date: self.getDateParm, completionHandler: { (state, data) in
            ad.killLoading()
            guard state else {
                 self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                return
            }
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


extension HomeWorkerVC : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayNumArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.dateCollection.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        

        if cell.isSelected{
        
            print(dayNumArr[indexPath.row])
            cell.dayNum.text = dayNumArr[indexPath.row]
            cell.month.text = monthArr[indexPath.row]
            cell.dayNum.textColor = .white
            cell.month.textColor = .white
            cell.view.backgroundColor = .brownMainColor
            
            return cell
            
        }
        cell.dayNum.text = dayNumArr[indexPath.row]
        cell.month.text = monthArr[indexPath.row]
        cell.dayNum.textColor = .mainColor
        cell.month.textColor = .mainColor
        cell.view.backgroundColor = .white
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h = self.dateCollection.frame.height - 10
        let w = self.dateCollection.frame.width / 5.8
        return CGSize(width: w, height: h)
    }
 
    
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
           return 1
       }
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 1
       }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
 
      
          let cell = dateCollection.cellForItem(at: indexPath) as! DateCell
          cell.dayNum.textColor = .white
          cell.month.textColor = .white
          cell.view.backgroundColor = .brownMainColor
       
         self.getDateParm = DateOpM.getdateinBackFormate(date12: allDayes[indexPath.row])
         print(DateOpM.getdateinBackFormate(date12: allDayes[indexPath.row]))
//
         UIView.transition(with: tableView, duration: 0.5, options: [.transitionCrossDissolve], animations: {

                  self.tableView.reloadData()
              }, completion: nil)
          
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
         guard let cell = collectionView.cellForItem(at: indexPath) as? DateCell else {
                        return
                }
                cell.dayNum.textColor = .mainColor
                cell.month.textColor = .mainColor
                cell.view.backgroundColor = .white
       }
    
    
    
    
}


extension HomeWorkerVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderWorkerCell", for: indexPath) as! OrderWorkerCell
        cell.kindWork.text = data[indexPath.row].title
        cell.timeLbl.text = data[indexPath.row].time
        cell.callBtn.layer.setValue(indexPath.row, forKey: "index")
        cell.mapbtn.layer.setValue(indexPath.row, forKey: "index")
        cell.callBtn.addTarget(self, action: #selector(callClint(sender:)), for: .touchUpInside)
        cell.mapbtn.addTarget(self, action: #selector(getMapAddress(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func callClint (sender : UIButton) {
         let i : Int = (sender.layer.value(forKey: "index")) as! Int
         guard data[i].user_phone != "" else {
                   
                          return
                      }
                      print("that's the phone Number : \(data[i].user_phone)")
                      guard let pNum = data[i].user_phone else { return }
                      guard  let phoneCallURL:URL = URL(string: "tel:\(pNum)") else {
                         
                          return
                      }
                      let application:UIApplication = UIApplication.shared
                      if (application.canOpenURL(phoneCallURL)) {
                          let alertController = UIAlertController(title: "", message:"continueAndCall".localized + " \n\(pNum)?", preferredStyle: .alert)
                          let yesPressed = UIAlertAction(title: "نعم", style: .default, handler: { (action) in
                              application.openURL(phoneCallURL)
                          })
                          let noPressed = UIAlertAction(title: "no".localized, style: .default, handler: { (action) in
                              
                          })
                          alertController.addAction(yesPressed)
                          alertController.addAction(noPressed)
                          present(alertController, animated: true, completion: nil)
                      }
        
    }
    
    
    
    
    @objc func getMapAddress (sender : UIButton) {
        let i : Int = (sender.layer.value(forKey: "index")) as! Int
        guard data[i].lat != "" , data[i].lng != "" else {
            
            return
        }
        guard let latdist = data[i].lat , let lngdist = data[i].lng else { return }
        print(latdist)
        print(lngdist)
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app

                if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(latdist),\(lngdist)&directionsmode=driving") {
                          UIApplication.shared.open(url, options: [:])
                 }}
            else {
                   //Open in browser
                  if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(latdist),\(lngdist)&directionsmode=driving") {
                                     UIApplication.shared.open(urlDestination)
                                 }
                      }
        
        
        
        
        
        
    }
        


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.height / 4.5
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard ad.isOnline() else{return}
        let vc = WorderDetailes()
        let id = data[indexPath.row].id!
        vc.tranId = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}



    extension HomeWorkerVC : CLLocationManagerDelegate{
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            
            
            locationManager.stopUpdatingLocation()
            //        if ((error) != nil)
            //        {
            print("\(error)")
            //        }
        }
       
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            
            let locationArray = locations as NSArray
            let locationObj = locationArray.lastObject as! CLLocation
            let coord = locationObj.coordinate
            self.lat = (coord.latitude)
            self.lng = (coord.longitude)
            print(coord.latitude)
            print(coord.longitude)
            locationManager.stopUpdatingLocation()

            if !didUpdateLocation {
                didUpdateLocation = true
                 updateTeamLocation()
            }
         }

        
        private func updateTeamLocation() {
            
            guard lat != 0 , lng != 0 else { return }

            APIClient.updateLocation(lat: lat, lng: lng, completionHandler: { (status, sms) in
                
                
                
            }) { (err) in
                
                
                
            }
            
        }
}
