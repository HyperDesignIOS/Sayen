//
//  SubService+CollectionView.swift.swift
//  Sayen 
//
//  Created by ME-MAC on 2/2/22.
//


import UIKit


extension SubServiceVC : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard ad.isOnline() else {
            return
        }
        let checkSub = data[indexPath.row].checkSub
        if checkSub > 0 {
            let vc = SubServiceVC()
            vc.subServiceId = data[indexPath.row].id
            vc.subServiceTitle =  data[indexPath.row].name
            vc.user = user
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = SendOrder()
            vc.infoText = data[indexPath.row].text
            vc.user = user
            vc.pageTransformeTitle = data[indexPath.row].name
            vc.id = data[indexPath.row].id
            vc.initial_price = String(data[indexPath.row].initial_price)
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeUserCell", for: indexPath) as! HomeUserCell
        cell.labelCell.text = data[indexPath.row].name
        cell.offerImageView.isHidden = data[indexPath.row].offer == 0 ? true : false
        cell.infoTextLabel.text = data[indexPath.row].text
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
          let h : CGFloat =  160
          let size = CGSize(width: w , height: h)
          return size
      }

 
    func handleCollectionView(){
        self.collectionView.register(UINib(nibName: "HomeUserCell", bundle: nil), forCellWithReuseIdentifier: "HomeUserCell")
        collectionView.semanticContentAttribute = .forceRightToLeft
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.addSubview(refresher)
        
    }
    
}
