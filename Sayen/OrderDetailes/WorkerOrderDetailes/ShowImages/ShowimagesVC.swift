//
//  ShowimagesVC.swift
//  Sayen 
//
//  Created by Maher on 6/30/20.
//

import UIKit

class ShowimagesVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var indexPathRow  = 0
    var transProbImages : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(UINib(nibName: "ProImageCell", bundle: nil), forCellWithReuseIdentifier: "ProImageCell")
       
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isPagingEnabled = true
        collectionView.allowsMultipleSelection = false
        collectionView.semanticContentAttribute = .forceRightToLeft
          

    }


    
  
  
    @IBAction func dismiss(_ sender: Any) {
        self.dismissViewC()
        
    }
    
}
extension ShowimagesVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout , UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transProbImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProImageCell", for: indexPath) as! ProImageCell
        
        if let url = URL(string: transProbImages[indexPath.row]) {
            cell.image.kf.indicatorType = .activity
            cell.image.kf.setImage(with: url)
        }
        if indexPathRow != 0 {
            self.collectionView.selectItem(at: IndexPath(row: indexPathRow, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            
            indexPathRow = 0
            
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
      print(indexPath)
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h = self.collectionView.frame.height
        let w = self.collectionView.frame.width
        return CGSize(width: w, height: h)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.collectionView.scrollToNearestVisibleCollectionViewCell()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.collectionView.scrollToNearestVisibleCollectionViewCell()
        }
    }
}
extension UICollectionView {
    func scrollToNearestVisibleCollectionViewCell() {
        self.decelerationRate = UIScrollView.DecelerationRate.fast
        let visibleCenterPositionOfScrollView = Float(self.contentOffset.x + (self.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<self.visibleCells.count {
            let cell = self.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)

            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = self.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            self.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}
