//
//  OrderHistoryVC.swift
//  Sayen 
//
//  Created by Maher on 6/13/20.
//

import UIKit

class OrderHistoryVC: UIViewController {

    @IBOutlet weak var lastAndCurrentSeg: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var noDataLbl: UILabel!
    
    
    
    var data : [Orders] = []
    lazy var refresher : UIRefreshControl = {
       let refresher = UIRefreshControl()
       refresher.addTarget(self, action: #selector(getDataCurrent), for: .valueChanged)
       return refresher
     }()
    var offset : Int = 0

    var totalCurrent = 0
    var totalPervious = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lastAndCurrentSeg.defaultConfiguration(font: UIFont(name: "Tajawal-Medium", size: 17)!, color: .lightGray)
        lastAndCurrentSeg.selectedConfiguration(font: UIFont(name: "Tajawal-Medium", size: 17)!, color: .mainColor)
        lastAndCurrentSeg.semanticContentAttribute = .forceRightToLeft
        self.tableView.register(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: "OrderCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.addSubview(refresher)
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDataCurrent()
        lastAndCurrentSeg.addTarget( self, action: #selector(segmentSelected(sender:)), for: UIControl.Event.valueChanged )
    }
   
    @objc func segmentSelected(sender: UISegmentedControl)
    {
        print("selected index: \(sender.selectedSegmentIndex)")

            getDataCurrent ()
  
    }
 
    
    @objc func getDataCurrent () {
        self.offset = 0
        if lastAndCurrentSeg.selectedSegmentIndex == 0 {
            
      
        self.refresher.endRefreshing()
        ad.isLoading()
       
        APIClient.getCurrentOrder(offset: self.offset,completionHandler: { (state, data , total) in
            ad.killLoading()
            guard state else {
                self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                return
            }
            if let data = data {
                if data.count == 0{
                    self.noDataLbl.alpha = 1
                    self.noDataLbl.text = "noCurrentRequest".localized
                     self.tableView.reloadData()
                }else{
                    self.noDataLbl.alpha = 0
                    
                }
                self.totalCurrent = total
                self.data = data
                self.tableView.reloadData()
            }
        }) { (err) in
            self.refresher.endRefreshing()
            ad.killLoading()
            self.data = []
            self.tableView.reloadData()
            self.noDataLbl.text = "noInternetConnection".localized
            self.noDataLbl.alpha = 1
            self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            print(err)
        }
        }else{
            
                 self.refresher.endRefreshing()
                 ad.isLoading()
        
            APIClient.getPreviousOrder(offset: self.offset, completionHandler: { (state, data , total) in
                     ad.killLoading()
                     guard state else {
                         self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                         return
                     }
                     if let data = data {
                        self.offset = 1
                        if data.count == 0{
                            self.noDataLbl.alpha = 1
                            self.tableView.reloadData()
                            self.noDataLbl.text = "noCompeleteRequests".localized
                         
                        }else{
                            self.noDataLbl.alpha = 0
                        }
                        self.totalPervious = total
                        self.data = data
                        self.tableView.reloadData()
                      
                     }
                 }) { (err) in
                     self.refresher.endRefreshing()
                     ad.killLoading()
                    self.data = []
                    self.tableView.reloadData()
                    self.noDataLbl.text = "noInternetConnection".localized
                              self.noDataLbl.alpha = 1
                     self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                     print(err)
                 }
        }
    }
    
    
    func loadmorePrevious () {
        if lastAndCurrentSeg.selectedSegmentIndex == 0 {
            

            APIClient.getCurrentOrder(offset: self.offset, completionHandler: { (state, data , total) in
                     ad.killLoading()
                     guard state else {
                         self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                         return
                     }
                     if let data = data {
                        self.offset += 1
                        self.data.append(contentsOf: data)
                        self.tableView.reloadData()
                      
                     }
                 }) { (err) in
                     self.refresher.endRefreshing()
                     ad.killLoading()
                     self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                     print(err)
                 }
            
            
            
        }else{

            APIClient.getPreviousOrder(offset: self.offset, completionHandler: { (state, data , total) in
                 ad.killLoading()
                 guard state else {
                     self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                     return
                 }
                 if let data = data {
                    self.offset += 1
                    self.data.append(contentsOf: data)
                    self.tableView.reloadData()
                  
                 }
             }) { (err) in
                 self.refresher.endRefreshing()
                 ad.killLoading()
                 self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                 print(err)
             }
        
    }
    }

}




extension OrderHistoryVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        cell.title.text = self.data[indexPath.row].title
        cell.date.text = self.data[indexPath.row].date
        cell.orderNum.text = "#\(self.data[indexPath.row].order_number)"
        if self.data[indexPath.row].order_number == "3740" {
            print("\(self.data[indexPath.row].order_status)")
        }
        cell.setStatus(orderStatus: self.data[indexPath.row].order_status)
        //        cell.setStatus(orderStatus: "6")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard ad.isOnline() else{return}
        let vc = OrderDetailesVC()
        vc.order_id = data[indexPath.row].id
        vc.order_status = data[indexPath.row].order_status
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let count = self.data.count
        if indexPath.row == count-1 {
            if lastAndCurrentSeg.selectedSegmentIndex == 0 {
                if count < totalCurrent {
                    loadmorePrevious()
                }
            }else{
                if count < totalPervious {
                    loadmorePrevious()
                }
            }
        }
    }
}
