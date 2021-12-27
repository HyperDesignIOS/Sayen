//
//  HomeWorker+CollectionView.swift
//  Sayen  Worker
//
//  Created by ME-MAC on 12/26/21.
//

import UIKit

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
