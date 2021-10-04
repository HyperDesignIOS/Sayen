//
//  PublicQuVC.swift
//  Sayen 
//
//  Created by Maher on 6/28/20.
//

import UIKit

class PublicQuVC: UIViewController {

    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var numStack: UIStackView!
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var counterLbl: UILabel!
    @IBOutlet weak var breBtnout: UIButton!
    @IBOutlet weak var quCollection: UICollectionView!
    var questions : [QuModel] = []
    var totalNum : Int = 0
    var selected : Int = 0
    var labelSelected : Int = 1
    var selectedIndexPath: IndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.breBtnout.alpha = 0.5

          let tabBar = self.tabBarController as? TabBarController
          tabBar?.hideTab()
        commonQuestions ()
        
        self.quCollection.isPagingEnabled = true
        breBtnout.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        self.quCollection.register(UINib(nibName: "PubLicQuCell", bundle: nil), forCellWithReuseIdentifier: "PubLicQuCell")
        self.quCollection.delegate = self
        self.quCollection.dataSource = self
       // quCollection.semanticContentAttribute = .forceRightToLeft
        quCollection.transform = CGAffineTransform(scaleX: 1.0, y: -1.0)
    }

    
    func commonQuestions () {
        ad.isLoading()
        APIClient.commonQuestions(completionHandler: { (state, data) in
            print(state)
            ad.killLoading()
            if let data = data {
                if data.count == 0 {
                    self.noDataLbl.alpha = 1
                    self.quCollection.alpha = 0
                    self.numStack.alpha = 0
                }else{
                    self.noDataLbl.alpha = 0
                    self.quCollection.alpha = 1
                    self.numStack.alpha = 1
                    self.questions = data
                    self.totalNum = data.count
                    self.counterLbl.text = "\(self.labelSelected)\\\(self.totalNum)"
                    self.quCollection.reloadData()
                }
              
                
            }
        }) { (err) in
        
            print("err")
        }
    }

    @IBAction func nextbtn(_ sender: Any) {
       
       
        
     guard self.selected < self.totalNum - 1 else {
        self.nextBtn.alpha = 0.5
              
               return}
            self.breBtnout.alpha = 1
            self.nextBtn.alpha = 1
           self.selected += 1
           selectedIndexPath = IndexPath(item: self.selected, section: 0)
           self.quCollection.scrollToItem(at: selectedIndexPath!, at: .centeredHorizontally, animated: true)
      //     self.quCollection.selectItem(at: selectedIndexPath!, animated: true, scrollPosition: .centeredHorizontally)
           self.labelSelected += 1
           self.counterLbl.text = "\(self.labelSelected)\\\(self.totalNum)"
       
       
    }
    
    @IBAction func previousBtn(_ sender: Any) {
      guard self.selected >= 1 else {
                  self.breBtnout.alpha = 0.5
                 return}
                 self.nextBtn.alpha = 1
                 self.breBtnout.alpha = 1
                 self.selected -= 1
                 self.labelSelected -= 1
                 selectedIndexPath = IndexPath(item: self.selected, section: 0)
                 self.quCollection.scrollToItem(at: selectedIndexPath!, at: .centeredHorizontally, animated: true)
               //  self.quCollection.selectItem(at: selectedIndexPath!, animated: true, scrollPosition: .centeredHorizontally)
           
             self.counterLbl.text = "\(self.labelSelected)\\\(self.totalNum)"
       
        
    }
    
    @IBAction func dismiss(_ sender: Any) {
        let tabBar = self.tabBarController as? TabBarController
        self.dismissViewC()
        tabBar?.showTab()
    }
}


extension PublicQuVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         
         let cell = self.quCollection.dequeueReusableCell(withReuseIdentifier: "PubLicQuCell", for: indexPath) as! PubLicQuCell
            cell.transform = CGAffineTransform(scaleX: 1.0, y: -1.0)
            cell.qusionText.text = questions[indexPath.row].question
            cell.answerText.text = questions[indexPath.row].answer
  
         return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = self.quCollection.frame.width
        let h = self.quCollection.frame.height
        return CGSize(width: w, height: h)
    }
}
