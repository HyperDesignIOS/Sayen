//
//  EmergencyOrderTeam+TableView.swift
//  Sayen  Worker
//
//  Created by ME-MAC on 2/22/22.
//


import UIKit
extension EmergencyOrderTeam : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderWorkerCell", for: indexPath) as! OrderWorkerCell
        cell.timeLbl.text = data[indexPath.row].title
        cell.kindWork.text = data[indexPath.row].date
        cell.callBtn.isHidden = true
        cell.mapbtn.isHidden = true
        
        return cell
    }
    
//        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return self.tableView.frame.height / 4.5
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard ad.isOnline() else{return}
        let vc = EmergencyOrderDetailesTeamVC()
        
        let id = data[indexPath.row].id!
        vc.order_id = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
