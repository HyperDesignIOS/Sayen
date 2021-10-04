//
//  NotificationVC.swift
//  Sayen 
//
//  Created by Maher on 6/24/20.
//

import UIKit

class NotificationVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noDataLbl: UILabel!
    var newNoti : [NotiModel] = []
    var oldNoti : [NotiModel] = []
    var offset = 0
    var total = 0
     lazy var refresher : UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(getNotification), for: .valueChanged)
        return refresher
      }()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib(nibName: "NotiCell", bundle: nil), forCellReuseIdentifier: "NotiCell")
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.addSubview(refresher)
      
    }
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getNotification ()
    }
    
    
    @objc func getNotification () {
        ad.isLoading()
        self.refresher.endRefreshing()
        self.offset = 0
        APIClient.getNotification(user_type: ad.user_type() , offset : offset, completionHandler: { (stateNew , stateOld, newNoti , oldNoti , total) in
          
            ad.killLoading()
//                   guard stateNew ,stateOld   else {
//                       self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
//                       return
//                   }
                   if let newNoti = newNoti , let oldNoti = oldNoti{
                    if newNoti.count == 0 && oldNoti.count == 0{
                           self.noDataLbl.alpha = 1
                       }else{
                           self.noDataLbl.alpha = 0
                           
                       }
                       self.offset = 1
                       self.total = total
                       self.newNoti = newNoti
                       self.oldNoti = oldNoti
                       self.tableView.reloadData()
                   }
        }) { (error) in
            ad.killLoading()
            print("error")
        }
    }
    
    
    
    func loadMore () {
                APIClient.getNotification(user_type: ad.user_type() , offset : offset, completionHandler: { (stateNew , stateOld, newNoti , oldNoti , total) in
                  
                    ad.killLoading()
       
                           if let newNoti = newNoti , let oldNoti = oldNoti{
                           
                               self.offset += 1
                               self.total = total
                               self.newNoti.append(contentsOf: newNoti)
                               self.oldNoti.append(contentsOf: oldNoti)
                               self.tableView.reloadData()
                           }
                }) { (error) in
                    print("error")
                }
    }
    
    
    func notifcationSeen (user_type : String , notiId : Int , orderId : Int) {
        ad.isLoading()
        APIClient.notificationSeen(user_type: user_type, notification_id: notiId, completionHandler: { (state, sms) in
            ad.killLoading()
            guard state else {
                return
            }
            DispatchQueue.main.async {
                if ad.isUser(){
                    let vc = OrderDetailesVC()
                    vc.order_id = orderId
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = WorderDetailes()
                    vc.tranId = orderId
                     self.navigationController?.pushViewController(vc, animated: true)
                }
           
            }
        }) { (err) in
             ad.killLoading()
            print("error")
        }
    }

}



extension NotificationVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            let v = UIView(frame: CGRect(x: 0, y:0, width: tableView.frame.width, height: 40))
            v.backgroundColor = .clear
            let label = UILabel(frame: CGRect(x: 8.0, y: 0.0, width: v.bounds.size.width - 16.0, height: v.bounds.size.height))
            label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            label.textAlignment = .right
            label.text = "الاشعارات السابقه"
            label.textColor = .mainColor
            label.font = UIFont(name: "Tajawal-Regular", size: 17)
            v.addSubview(label)
            if oldNoti.count == 0{
                v.alpha = 0
            }
            return v
        }else{
            return nil
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 50
        }else{
            return 0
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == -0 {
            return newNoti.count
        }else{
            return oldNoti.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.height / 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotiCell", for: indexPath) as! NotiCell
        if indexPath.section == 0 {
            cell.maintitle.text = newNoti[indexPath.row].message
            cell.dateLbl.text = newNoti[indexPath.row].created_at
            if let url = URL(string: newNoti[indexPath.row].image_path!) {
                cell.notiImage.kf.indicatorType = .activity
                cell.notiImage.kf.setImage(with: url,placeholder:#imageLiteral(resourceName: "Mask Group 19") )
            }
        }else{
            cell.maintitle.text = oldNoti[indexPath.row].message
            cell.dateLbl.text = oldNoti[indexPath.row].created_at
            if let url = URL(string: oldNoti[indexPath.row].image_path!) {
                cell.notiImage.kf.indicatorType = .activity
                cell.notiImage.kf.setImage(with: url,placeholder:#imageLiteral(resourceName: "Mask Group 19"))
            }
            
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let notiid = newNoti[indexPath.row].id ,
                let orderId = newNoti[indexPath.row].order_id else{
                    return
            }
            
            self.notifcationSeen(user_type: ad.user_type(), notiId: notiid, orderId: orderId)
        }else{
            guard let notiid = oldNoti[indexPath.row].id ,
                let orderId = oldNoti[indexPath.row].order_id else{
                    return
            }
            DispatchQueue.main.async {
                if ad.isUser(){
                    let vc = OrderDetailesVC()
                    vc.order_id = orderId
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = WorderDetailes()
                    vc.tranId = orderId
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
            //     self.notifcationSeen(user_type: ad.user_type(), notiId: notiid, orderId: orderId)
        }
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let count = self.newNoti.count
            if indexPath.row == count-1 {
                if count < total-oldNoti.count {
                    
                    loadMore()
                }
                
            }
            
        }else {
            let count = self.oldNoti.count
            if indexPath.row == count-1 {
                if count < total-newNoti.count{
                    
                    loadMore()
                }
                
            }
        }
    }
          
       
    
}
