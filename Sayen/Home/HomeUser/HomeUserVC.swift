//
//  HomeUserVC.swift
//  Sayen 
//
//  Created by Maher on 6/9/20.
//

import UIKit

class HomeUserVC: UIViewController {

    @IBOutlet weak var noDataLbl: UILabel!
    
    @IBOutlet weak var HeadView: UICollectionReusableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
     var data : [HomeData] = []
    var dataProfile: UserProfile_Data?
    var name : String = ""
    
    
    
     lazy var refresher : UIRefreshControl = {
              let refresher = UIRefreshControl()
              refresher.tintColor = .white
              refresher.addTarget(self, action: #selector(getAllServices), for: .valueChanged)
              return refresher
            }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        APIClient.getServices(completionHandler: {[weak self] (state, data) in
            guard let self = self else {return}
            guard state else{
                self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                ad.killLoading()
                return
            }
            if let data = data {
                if data.count == 0 {
                    self.noDataLbl.alpha = 1
                    self.collectionView.reloadData()
                    self.noDataLbl.text = "جاري اضافه خدمات للتطبيق"
                }else{
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



extension HomeUserVC : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard ad.isOnline() else {
            return
        }
        let vc = SendOrder()
        vc.pageTransformeTitle = data[indexPath.row].name
        vc.id = data[indexPath.row].id
        vc.initial_price = String(data[indexPath.row].initial_price)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeUserCell", for: indexPath) as! HomeUserCell
        cell.labelCell.text = data[indexPath.row].name
        if let url = URL(string: data[indexPath.row].image_path) {
            let placeholderImage = UIImage(named: "Group 1059")!
            cell.image.af_setImage(withURL: url, placeholderImage: placeholderImage)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 12
     }
     
      
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          let w = self.collectionView.frame.width / 2.08
          let h =  self.view.frame.height / 6
          let size = CGSize(width: w , height: h)
          return size
      }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
          
          switch kind {
          case UICollectionView.elementKindSectionHeader:
              let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeHeader", for: indexPath) as! HomeHeader
                  
            reusableview.name.text = "hi".localized + self.name
              return reusableview
          default:  fatalError("Unexpected element kind")
          }
      }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
      
            
            let size = CGSize(width: collectionView.frame.size.width, height: 240)
            return size
        
        
    }
    
    
    
}
