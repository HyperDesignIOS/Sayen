//
//  HomeWorker+TableView.swift
//  Sayen  Worker
//
//  Created by ME-MAC on 12/26/21.
//

import UIKit
extension HomeWorkerVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderWorkerCell", for: indexPath) as! OrderWorkerCell
        cell.kindWork.text = data[indexPath.row].title
        cell.timeLbl.text = data[indexPath.row].time
        cell.callBtn.layer.setValue(indexPath.row, forKey: "index")
        cell.mapbtn.layer.setValue(indexPath.row, forKey: "index")
        cell.callBtn.addTarget(self, action: #selector(callClint(sender:)), for: .touchUpInside)
        cell.mapbtn.addTarget(self, action: #selector(getMapAddress(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func callClint (sender : UIButton) {
         let i : Int = (sender.layer.value(forKey: "index")) as! Int
         guard data[i].user_phone != "" else {
                   
                          return
                      }
                      print("that's the phone Number : \(data[i].user_phone)")
                      guard let pNum = data[i].user_phone else { return }
                      guard  let phoneCallURL:URL = URL(string: "tel:\(pNum)") else {
                         
                          return
                      }
                      let application:UIApplication = UIApplication.shared
                      if (application.canOpenURL(phoneCallURL)) {
                          let alertController = UIAlertController(title: "", message:"continueAndCall".localized + " \n\(pNum)?", preferredStyle: .alert)
                          let yesPressed = UIAlertAction(title: "نعم", style: .default, handler: { (action) in
                              application.openURL(phoneCallURL)
                          })
                          let noPressed = UIAlertAction(title: "no".localized, style: .default, handler: { (action) in
                              
                          })
                          alertController.addAction(yesPressed)
                          alertController.addAction(noPressed)
                          present(alertController, animated: true, completion: nil)
                      }
        
    }
    
    
    
    
    @objc func getMapAddress (sender : UIButton) {
        let i : Int = (sender.layer.value(forKey: "index")) as! Int
        guard data[i].lat != "" , data[i].lng != "" else {
            
            return
        }
        guard let latdist = data[i].lat , let lngdist = data[i].lng else { return }
        print(latdist)
        print(lngdist)
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app

                if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(latdist),\(lngdist)&directionsmode=driving") {
                          UIApplication.shared.open(url, options: [:])
                 }}
            else {
                   //Open in browser
                  if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(latdist),\(lngdist)&directionsmode=driving") {
                                     UIApplication.shared.open(urlDestination)
                                 }
                      }
        
        
        
        
        
        
    }
        


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.height / 4.5
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard ad.isOnline() else{return}
        let vc = WorderDetailes()
        let id = data[indexPath.row].id!
        vc.tranId = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
