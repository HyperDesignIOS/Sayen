//
//  ProfileVC.swift
//  Sayen 
//
//  Created by Maher on 6/4/20.
//

import UIKit
import StoreKit

class ProfileVC: UIViewController {

    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var myAccount: UIButtonX!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var viewModel = ProfileViewModel()
    var data: UserProfile_Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myAccount.semanticContentAttribute = .forceRightToLeft
        profileImg.layer.borderColor = UIColor.white.cgColor
        profileImg.layer.borderWidth = 3
        self.tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
      
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProfileData()
     
        if let navigationController = self.navigationController{
            navigationController.setStatusBar(backgroundColor: UIColor.mainColor)
        }
    }
    
    @IBAction func editProfile(_ sender: Any) {
        let vc = EditProfileVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
     
    
    func getProfileData() {
        ad.isLoading()
        APIClient.getProfileData(user_type: ad.user_type(), completionHandler: { (state, sms, data) in
            guard state else{
                ad.killLoading()
                self.showDAlert(title: "Error".localized, subTitle: sms, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                return
            }
            
            DispatchQueue.main.async {
                ad.killLoading()
                if let data = data {
                    self.data = data
                    if data.name == "" {
                        self.profileName.text = data.phone
                    }else{
                        
                        if data.name.count > 20 {
                        let xx = Constants.UserName.prefix(20)
                            self.profileName.text = "\(xx)..."
                        }else{
                            self.profileName.text = (data.name) + " " + (data.lastName)
                        }
                      
                    }
                    if let url = URL(string: data.imageLink) {
                        let placeholderImage = UIImage(named: "imageProfile")!
                        self.profileImg.af_setImage(withURL: url, placeholderImage: placeholderImage)
                    }
                    
                    
                }
                
            }
        })  { (err) in
            ad.killLoading()
            self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            print("errr")
        }
    }
    

}


extension ProfileVC : UITableViewDelegate , UITableViewDataSource {

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.data.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
            let data = viewModel.data[indexPath.row].getData()
            if indexPath.row == 6 {
                cell.sepratorV.alpha = 0
            }
            cell.cellImage.image = data.image
            cell.cellLbl.text =  data.title
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            return headerView
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 320
        }
        
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func rateApp() {
        guard ad.isOnline() else{return}
        if #available(iOS 10.3, *) {
            DispatchQueue.main.async {
                SKStoreReviewController.requestReview()
            }
            
          

        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "1519502230") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
             
            } else {
                UIApplication.shared.openURL(url)
               
            }
        }
    }
        
    func shareApp () {
        if let urlStr = NSURL(string: "https://itunes.apple.com/us/app/myapp/1519502230?ls=1&mt=8") {
            let objectsToShare = [urlStr]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                if let popup = activityVC.popoverPresentationController {
                    popup.sourceView = self.view
                    popup.sourceRect = CGRect(x: self.view.frame.size.width / 2, y: self.view.frame.size.height / 4, width: 0, height: 0)
                }
            }
            
            self.present(activityVC, animated: true, completion: nil)
        }
        
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.data[indexPath.row]
        
        switch data {
        case .popualarQu :
            print("popualr")
            if let navigationController = self.navigationController{
                navigationController.setStatusBar(backgroundColor: UIColor.secondaryWhiteColor)
            }
            let vc = PublicQuVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case .aboutSayen :
            print("about")
            if let navigationController = self.navigationController{
                navigationController.setStatusBar(backgroundColor: UIColor.secondaryWhiteColor)
            }
            let vc = AboutUs()
            self.navigationController?.pushViewController(vc, animated: true)
        case .contactUs :
            print("contact")
            if let navigationController = self.navigationController{
                navigationController.setStatusBar(backgroundColor: UIColor.secondaryWhiteColor)
            }
            let vc = ContactUsVc()
            self.navigationController?.pushViewController(vc, animated: true)
        case .changeLanguage:
            ad.changeLang()
        case .logout:
            print("logout")
          //  viewModel.logout()
            let vc = LogOutAlert()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false)
        case .deletAccount:
            let vc = LogOutAlert()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            vc.type = .deleteAccount
            self.present(vc, animated: false)
        //    self.navigationController?.pushViewController(vc, animated: false)
        case .share:
            print("share")
            shareApp()
        case .rateApp:
            print("rate")
            rateApp()
            
        }
    }
}

