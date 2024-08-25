//
//  OrderHistoryVC+tableView.swift
//  Sayen 
//
//  Created by ME-MAC on 2/3/22.
//

import UIKit


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
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 170
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard ad.isOnline() else{return}
        if emergencySeg.selectedSegmentIndex == 0{
            let vc = OrderDetailesVC()
            vc.order_id = data[indexPath.row].id
            vc.order_status = data[indexPath.row].order_status
            self.navigationController?.pushViewController(vc, animated: true)
        }  else {
            let vc = EmergencyOrderDetailesVC()
            vc.order_id = data[indexPath.row].id
            vc.order_status = data[indexPath.row].order_status
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
