//
//  HomeUser+CollectionView.swift
//  Sayen 
//
//  Created by ME-MAC on 2/2/22.
//

import UIKit


extension HomeUserVC : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return services.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard ad.isOnline() else {
            return
        }
        let checkSub = services[indexPath.row].checkSub
        if indexPath.row == 0 {
            let vc = EmergencyServiceAlert()
            vc.delegate = self
            vc.services = emergenacyServices
            vc.emergancyInfoText = emergencyInfoText
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }else if indexPath.row == 1 , !offers.isEmpty{
            let vc = ServicesOffers()
            vc.user = user
            vc.offers = offers
            self.navigationController?.pushViewController(vc, animated: true)
        } else  {
            if checkSub > 0 {
                let vc = SubServiceVC()
                vc.subServiceId = services[indexPath.row].id
                vc.subServiceTitle =  services[indexPath.row].name
                vc.user = user
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                let vc = SendOrder()
                vc.user = user
                vc.service = services[indexPath.row]
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeUserCell", for: indexPath) as! HomeUserCell
        if indexPath.row == 0 {
            cell.labelCell.text = "emergancyOrder".localized
            cell.infoTextLabel.text = ""
            cell.image.image = UIImage(named: "siren")!
            cell.offerImageView.isHidden = true 
        }else if indexPath.row == 1 && !offers.isEmpty{
            
                cell.labelCell.text = "spicailOffers".localized
                cell.image.image = UIImage(named: "fsdjh87")!
                cell.offerImageView.isHidden = true
            
        }else {
            cell.labelCell.text = services[indexPath.row].name
            cell.infoTextLabel.text = services[indexPath.row].text
            cell.offerImageView.isHidden = services[indexPath.row].offer == 0 ? true : false
                if let url = URL(string: services[indexPath.row].image_path) {
                let placeholderImage = UIImage(named: "Group 1059")!
                cell.image.af_setImage(withURL: url, placeholderImage: placeholderImage)
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 12
     }
     
      
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          let w = self.collectionView.frame.width / 2.08
          let h : CGFloat =  155
          let size = CGSize(width: w , height: h)
          return size
      }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
          
          switch kind {
          case UICollectionView.elementKindSectionHeader:
              let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeHeader", for: indexPath) as! HomeHeader
                  
              reusableview.name.text = "hi".localized + self.name + "haveAGoodDay".localized
              return reusableview
          default:  fatalError("Unexpected element kind")
          }
      }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
      
            
            let size = CGSize(width: collectionView.frame.size.width, height: 240)
            return size
        
        
    }
    
    
    func handleCollectionView(){
        self.collectionView.register(UINib(nibName: "HomeUserCell", bundle: nil), forCellWithReuseIdentifier: "HomeUserCell")
        collectionView.register(UINib(nibName: "HomeHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HomeHeader")
        collectionView.semanticContentAttribute = .forceRightToLeft
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.addSubview(refresher)
    }
}
extension String {
    func versionCompare(_ otherVersion: String) -> ComparisonResult {
        return self.compare(otherVersion, options: .numeric)
    }
}
