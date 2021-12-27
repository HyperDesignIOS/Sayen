//
//  WorderDetailes.swift
//  Sayen  Worker
//
//  Created by Maher on 6/17/20.
//

import UIKit

class WorderDetailes: UIViewController {
    
    @IBOutlet weak var canceledOrderL: UIButtonX!
    @IBOutlet weak var upGroundView: UIView!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var orderNum: UILabel!
    @IBOutlet weak var date: UILabel!
    var tabBar : UITabBarController?
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
    @IBOutlet weak var clintView: CardView!
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var probAndEndStack: UIStackView!
    @IBOutlet weak var startWorkButtonOutlet: UIButtonX!
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var clintName: UILabel!
    @IBOutlet weak var clintImage: UIImageView!
    @IBOutlet weak var notesHieght: NSLayoutConstraint!
    @IBOutlet weak var timerView: CardView!
    @IBOutlet weak var endWork: UIButtonX!
    @IBOutlet weak var clientTypeLbl: UILabel!
    @IBOutlet weak var stopwatchLabel: UILabel!
    @IBOutlet weak var openLocationBtnOL: UIButton!
    
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    
    var data : TeamOrderDetailes?
    var orderId : Int = 0
    
    
    var tranId : Int = 0
    var timer:Timer = Timer()
    var time:Int = 0
    var isActive: Bool = false
    var isReset: Bool = true
    var startTime:TimeInterval?
    var elapsed:TimeInterval?
    var timeInterval:TimeInterval?
    var laps:[String] = [String]()
    var timerDefaults = UserDefaults.standard
    var probImages : [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.notes.semanticContentAttribute = .forceRightToLeft
        imageCollection.semanticContentAttribute = .forceRightToLeft
        // Do any additional setup after loading the view.
        let tabBar = self.tabBarController as? TabBarController
        tabBar?.hideTab()
        self.clintImage.layer.cornerRadius = 20
        self.imageCollection.register(UINib(nibName: "imagesCell", bundle: nil), forCellWithReuseIdentifier: "imagesCell")
        self.imageCollection.delegate = self
        self.imageCollection.dataSource = self
        startTime = Date.timeIntervalSinceReferenceDate
        getOrderData()
    }
    
    @IBAction func openLocationHandler(_ sender: UIButton) {
        guard let data = self.data   , let lat = data.lat , lat != "" , let lng = data.lng , lng != "" , let latt = Double(lat) , let lngg = Double(lng) else { return }
        
        openMapButtonAction(lat : latt , lng : lngg)
    }
    
    func openMapButtonAction(lat : Double , lng : Double) {
        let latitude = lat
        let longitude = lng
        
        let appleURL = "http://maps.apple.com/?daddr=\(latitude),\(longitude)"
        let googleURL = "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=driving"
        let wazeURL = "waze://?ll=\(latitude),\(longitude)&navigate=false"
        
        let googleItem = ("Google Map", URL(string:googleURL)!)
        let wazeItem = ("Waze", URL(string:wazeURL)!)
        var installedNavigationApps = [("Apple Maps", URL(string:appleURL)!)]
        
        if UIApplication.shared.canOpenURL(googleItem.1) {
            installedNavigationApps.append(googleItem)
        }
        
        if UIApplication.shared.canOpenURL(wazeItem.1) {
            installedNavigationApps.append(wazeItem)
        }
        
        let alert = UIAlertController(title: "", message: "إختر الوجهة", preferredStyle: .actionSheet)
        for app in installedNavigationApps {
            let button = UIAlertAction(title: app.0, style: .default, handler: { _ in
                UIApplication.shared.open(app.1, options: [:], completionHandler: nil)
            })
            alert.addAction(button)
        }
        let cancel = UIAlertAction(title: "إلغاء", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
    @IBAction func callClint(_ sender: Any) {
        
        guard data!.user_phone != "" else {
            
            return
        }
        print("that's the phone Number : \(data!.user_phone)")
        guard let pNum = data?.user_phone else { return }
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
    
    @IBAction func dismiss(_ sender: Any) {
        let tabBar = self.tabBarController as? TabBarController
        
        self.dismissViewC()
        tabBar?.showTab()
    }
    @IBAction func startWorkAction(_ sender: UIButton){
        if sender.tag == 121 {
            startWorkAPIRequest()
        }else{
            goWorkAPIRequest(sender)
        }
    }
    
   private func startWorkAPIRequest(){
    ad.isLoading()
    APIClient.startWork(order_id: self.tranId, completionHandler: { (state, sms) in
        ad.killLoading()
        guard state else {
            self.showDAlert(title: "Error".localized, subTitle:sms, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            return
        }
        DispatchQueue.main.async {
            self.gotoEndV.backgroundColor = UIColor.brownMainColor
            self.inProgTitle.textColor = UIColor.brownMainColor
            self.endImg.image = UIImage(named: "Group 1069")
            self.startWorkButtonOutlet.alpha = 0
            self.timerView.alpha = 1
            self.probAndEndStack.alpha = 0
            self.endWork.alpha = 1
            self.gotoEndV.backgroundColor = .brownMainColor
            self.startTimer()
        }
    }) { (err) in
        ad.killLoading()
        self.showDAlert(title: "Error".localized, subTitle:"", type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
    }
}
    
    private func goWorkAPIRequest(_ sender: UIButton){
        ad.isLoading()
        APIClient.startWork(order_id: self.tranId, completionHandler: { (state, sms) in
            ad.killLoading()
            guard state else {
                self.showDAlert(title: "Error".localized, subTitle:sms, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                return
            }
            DispatchQueue.main.async {
                sender.setTitle("startWork".localized, for: .normal)
                sender.tag = 121
            }
        }) { (err) in
            ad.killLoading()
            self.showDAlert(title: "Error".localized, subTitle:"", type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
        }
    }
    func getOrderData (endBill:Bool = false ) {
        ad.isLoading()
        APIClient.getTOrder(order_id: self.tranId, completionHandler: { (state, sms, data) in
            ad.killLoading()
            guard state else {
                self.showDAlert(title:  "Error".localized, subTitle: "tryAgain".localized , type: .withContent, buttonTitle: "tryAgain".localized) { (_) in
                    self.goToHome()
                }
                return
            }
            
            if let data = data {
           
                if   let lat = data.lat , lat != "" , let lng = data.lng , lng != ""  {
                    self.openLocationBtnOL.isHidden = false
                }else {
                    self.openLocationBtnOL.isHidden = true
                }
                let clientType = data.isExcellenceClient ? "special".localized : "other".localized
                self.clientTypeLbl.text = "clinetType".localized + " : " + clientType
                self.upGroundView.alpha = 0
                self.data = data
                print(data.user_name)
                DispatchQueue.main.async {
                    self.orderId = data.id!
                    self.mainTitle.text = data.title
                    self.orderNum.text = "#\(data.order_number ?? "" )"
                    self.date.text = data.date
                    self.addressLabel.text = "address".localized + " : " + ( data.address ?? "")
                    self.floorLabel.text = "floorDetails".localized + " : " + "\(data.floor ?? 0)"
                    self.clintName.text = "العميل : \(data.user_name!)"
                    var startWorkButtonOutletTitle = ""
                    if data.order_status == "5" || data.order_status == "1" {
                        startWorkButtonOutletTitle = "التوجه للعمل"
                    } else if data.order_status == "6" {
                        startWorkButtonOutletTitle = "startWork".localized
                        self.startWorkButtonOutlet.tag = 121
                    }
                    self.startWorkButtonOutlet.setTitle(startWorkButtonOutletTitle, for: .normal)
                    if data.team_added_price.count != 0{
                        self.probAndEndStack.alpha = 0
                        //                        if data.user_accept_added_price == "1" {
                        //                            self.showDAlert(title: "", subTitle: " تم قبول الطلب", type: .success, buttonTitle: "done".localized , completionHandler: nil)
                        //                        }else if data.user_accept_added_price == "2" {
                        //                             self.showDAlert(title: "", subTitle: " تم gdf الطلب", type: .success, buttonTitle: "done".localized , completionHandler: nil)
                        //                        }
                    }
                    self.notes.text = data.notes
                    let numofline = self.notes.contentSize.height
                    if numofline < 50 {
                        self.notesHieght.constant = 40
                    }
                    if let url = URL(string: data.user_image!){
                        let placeholderImage = UIImage(named: "imageProfile")!
                        self.clintImage.af_setImage(withURL: url, placeholderImage: placeholderImage)
                    }
                    
                    self.probImages = data.images
                    self.imageCollection.reloadData()
                    if endBill {
                        
                        let vc = AllPriceVCT()
                        vc.endPrice = "\(data.final_price!)"
                        vc.coponPrice = "\(data.total_before_discount!)"
                        vc.startPrice = "\(data.initial_price!)"
                        vc.order_id = data.id!
                        vc.data = data
                        vc.delegate = self
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                }
                
                self.setOrderDetaiels(order_status: data.order_status!)
            }
        }) { (err) in
            
            ad.killLoading()
            self.showDAlert(title:  "Error".localized, subTitle: "tryAgain".localized , type: .withContent, buttonTitle: "tryAgain".localized) { (_) in
                self.goToHome()
            }
            
            print(err)
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
    
    func setOrderDetaiels (order_status : String) {
        if order_status == "2" {
            self.canceledOrderL.alpha = 0
            self.startWorkButtonOutlet.alpha = 0
            self.timerView.alpha = 1
            if let x = UserDefaults.standard.value(forKey: "timerStart") as? TimeInterval {
                self.isReset = false
                //        //To in progress
                self.inWayImg.image = UIImage(named: "Group 1069")
                self.inProgImg.image =  UIImage(named: "Group 1069")
                self.endImg.image = UIImage(named: "Ellipse 69")
                self.inWayV.backgroundColor = UIColor.brownMainColor
                self.inProgV.backgroundColor = UIColor.brownMainColor
                self.gotoEndV.backgroundColor = UIColor.brownMainColor
                self.newOrderTite.textColor = UIColor.brownMainColor
                self.inWayTitle.textColor = UIColor.brownMainColor
                self.inProgTitle.textColor = UIColor.brownMainColor
                
                self.startWorkButtonOutlet.alpha = 0
                self.timerView.alpha = 1
                self.probAndEndStack.alpha = 0
                self.endWork.alpha = 1
                self.gotoEndV.backgroundColor = .brownMainColor
                self.startTimer()
            }
            
        }else if order_status == "1"{
            self.canceledOrderL.alpha = 0
            
        }else if order_status == "3" {
            //To end prog
            self.canceledOrderL.alpha = 1
            self.canceledOrderL.setTitle("طلب منتهي", for: .normal)
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
            self.startWorkButtonOutlet.alpha = 0
            self.probAndEndStack.alpha = 0
            
        }else if order_status == "4" {
            self.probAndEndStack.alpha = 0
            self.startWorkButtonOutlet.alpha = 0
            self.canceledOrderL.alpha = 1
            self.newOrderImg.image = UIImage(named: "Group 1069")
            self.inWayV.backgroundColor = UIColor.brownMainColor
            self.newOrderTite.textColor = UIColor.brownMainColor
            self.inWayImg.image = UIImage(named: "Group 1070")
            self.inWayTitle.textColor = UIColor.red
            self.inWayTitle.text = "canceled".localized
            self.gotoEndV.alpha = 0
            self.endImg.alpha = 0
            self.endTitle.alpha = 0
            
        }else if order_status == "6"{
            //To in way
            self.inWayImg.image = UIImage(named: "Group 1069")
            self.inProgImg.image = UIImage(named: "Ellipse 69")
            self.inWayTitle.textColor = UIColor.brownMainColor
            self.inProgV.backgroundColor = UIColor.brownMainColor
        }
    }
    
    @IBAction func EndWorkAction(_ sender: Any) {
        
        
        getOrderData(endBill: true)
        
        
    }
    
    func EndFinalWork1 (pay_by: String?) {
        UserDefaults.standard.set(nil, forKey: "timerStart")
        timer.invalidate()
        ad.isLoading()
        APIClient.finishWork(order_id: data!.id!, pay_by: data!.excellence_client == "1" ? pay_by ?? "" : nil, completionHandler: { (state, sms) in
            ad.killLoading()
            guard state else{
                return
            }
            self.showDAlert(title: "", subTitle: "requestDone".localized, type: .success, buttonTitle: "done".localized ) { (_) in
                self.goToHome()
            }
            
        }) { (error) in
            ad.killLoading()
            print("Error")
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.incrementTimer), userInfo: nil, repeats: true)
        
        isActive = true
        
        
    }
    
    func funcTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.incrementTimer), userInfo: nil, repeats: true)
    }
    
    
    func stopTimer() {
        
        isActive = false
        isReset = false
        timer.invalidate()
    }
    
    func resetTimer() {
        
        isActive = false
        isReset = true
        stopwatchLabel.text = "00:00:00"
    }
    
    
    @objc func incrementTimer() {
        time += 1
        
        if isReset {
            stopwatchLabel.text = newTime()
        } else {
            stopwatchLabel.text = continueTime()
        }
        
    }
    
    
    func displayMinSeconds(time:Int) -> String {
        let hours = (time / 3600)
        let minutes:Int = time / 60 % 60
        let seconds:Int = time % 60
        //        let milliseconds:Int = time * 1000
        
        return String(format: "%0.2d:%02i:%02i", hours, minutes, seconds)
    }
    
    
    func newTime() -> String  {
        let currentTime = Date.timeIntervalSinceReferenceDate
        let elapsedTime: TimeInterval = currentTime - startTime!
        
        UserDefaults.standard.set(startTime , forKey: "timerStart")
        return updateTimer(time: elapsedTime)
    }
    
    func continueTime () -> String {
        let currentTime = Date.timeIntervalSinceReferenceDate
        guard let x = UserDefaults.standard.value(forKey: "timerStart") as? TimeInterval else{ return ""}
        
        let elapsedTime: TimeInterval = currentTime - x
        
        return updateTimer(time: elapsedTime)
    }
    
    func updateTime() -> String {
        return updateTimer(time: elapsed!)
    }
    
    func updateTimer(time:TimeInterval) -> String {
        var elapsedTime = time
        
        //calculate the minutes in elapsed time.
        let ti = NSInteger(elapsedTime)
        
        let hours = (ti / 3600)
        
        
        let minutes_ = UInt8(elapsedTime  / 60.0)
        elapsedTime  -= (TimeInterval(minutes_) * 60)
        
        let minutes = UInt8(Double(ti)  / 60.0) % 60
        
        //calculate the seconds in elapsed time.
        
        let seconds = UInt8(elapsedTime )
        
        elapsedTime  -= TimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        
        let fraction = UInt8(elapsedTime  * 60)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        
        elapsed = elapsedTime
        return String(format: "%0.2d:%02d:%02d", hours, minutes, seconds)
        
    }
    
    
    
    @IBAction func addPrice(_ sender: Any) {
        let vc = TeamAddPriceVC()
        //        vc.delegtea = self
        vc.id = self.orderId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func ProblemVc(_ sender: Any) {
        
        guard let id = data?.id else{return}
        
        //        ad.isLoading()
        //        APIClient.EndWork(order_id: id, completionHandler: { (state, sms) in
        //            ad.killLoading()
        //            guard state else {
        //                return}
        DispatchQueue.main.async {
            let vc = ProblemVC()
            vc.order_id = id
            self.navigationController?.pushViewController(vc, animated: true)
        }
        //        }) { (err) in
        //            ad.killLoading()
        //            print("error")
        //        }
        //
    }
}


extension WorderDetailes : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return probImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = self.imageCollection.dequeueReusableCell(withReuseIdentifier: "imagesCell", for: indexPath) as! imagesCell
//
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
      
        let w = self.imageCollection.frame.width / 5.1
        let h =  self.imageCollection.frame.height
        let size = CGSize(width: w , height: h)
        return size
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         return 2
     }
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 2
     }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ShowimagesVC()
        vc.indexPathRow = indexPath.row
        vc.transProbImages = self.probImages
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension WorderDetailes : endFinalWork {
    func endFinalWork(state: Bool, pay_by: String?) {
        if state {
            self.EndFinalWork1(pay_by: pay_by)
        }
    }
    
    
}


//extension WorderDetailes : DidUpdatePrice {
//
//
//    func didUpdatePrice(_ price: Double) {
//
//        self.data!.final_price = price
//    }
//}

//func setOrderState (orderStatus : String) {
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
//        self.inProgTitle.textColor = UIColor.red
//        self.inProgTitle.text = "canceled".localized
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
