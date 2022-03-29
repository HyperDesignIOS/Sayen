//
//  AllPriceVCT+CollectionView.swift
//  Sayen  Worker
//
//  Created by ME-MAC on 3/28/22.
//


import UIKit

extension AllPriceVCT : UICollectionViewDelegate , UICollectionViewDataSource  , UICollectionViewDelegateFlowLayout , RemoveImagePro{

    func removeImageFunc(i: Int) {
        self.deleteAlertImage(i: i)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.imagesCollection.dequeueReusableCell(withReuseIdentifier: "imagesCell", for: indexPath) as! imagesCell
        
            cell.problemImg.image = self.selectedImages[indexPath.row]
        
        
        cell.problemImg.layer.cornerRadius = 5
        cell.deleteBtn.layer.setValue(indexPath.row, forKey: "index")
        cell.deleteBtn.addTarget(self, action: #selector(deleteUser(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = self.imagesCollection.frame.width / 5.1
             let h =  self.imagesCollection.frame.height - 10
             let size = CGSize(width: w , height: h)
             return size
         }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
 
      
    @objc func deleteUser(sender:UIButton) {
        
        let i : Int = (sender.layer.value(forKey: "index")) as! Int
        let vc = removeImage()
        vc.i = i
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
        
    }
    func handleCollectionView(){
        self.imagesCollection.semanticContentAttribute = .forceRightToLeft
        self.imagesCollection.register(UINib(nibName: "imagesCell", bundle: nil), forCellWithReuseIdentifier: "imagesCell")
        self.imagesCollection.delegate = self
        self.imagesCollection.dataSource = self
    }
    
    func deleteAlertImage (i : Int) {
        selectedImages.remove(at: i)
        imagesCollection.reloadData()
        if self.selectedImages.count == 0 {
            self.imageHieght.constant = 52
            self.imagesCollection.alpha = 0
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
}
