//
//  ServicesOffers+TableView.swift
//  Sayen 
//
//  Created by ME-MAC on 3/2/22.
//



import UIKit
extension ServicesOffers : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotiCell", for: indexPath) as! NotiCell
        let title =  offers[indexPath.row].offer.title
        cell.maintitle.text = offers[indexPath.row].service.name
        cell.dateLbl.text = title
        if let url = URL(string: offers[indexPath.row].service.image_path) {
            cell.notiImage.kf.indicatorType = .activity
            cell.notiImage.kf.setImage(with: url,placeholder:#imageLiteral(resourceName: "Mask Group 19") )
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SendOrder()
        vc.user = user
        vc.infoText = offers[indexPath.row].service.text
        vc.pageTransformeTitle = offers[indexPath.row].service.name
        vc.id = offers[indexPath.row].service.id
        vc.initial_price = String(offers[indexPath.row].service.initial_price)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
}

