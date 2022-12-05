//
//  SendOrder+TableView.swift
//  Sayen 
//
//  Created by ME-MAC on 2/28/22.
//


import UIKit
extension SendOrder : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OfferTableViewCell", for: indexPath) as! OfferTableViewCell
        let title = offers[indexPath.row].offer.title
        let isSelected = offers[indexPath.row].isSelected
        let price  = "\(offers[indexPath.row].offer.price ?? 0)"
        cell.configerCell(title: title ?? "", isSelected: isSelected , price: price)
//        cell.kindWork.text = data[indexPath.row].date
//        cell.callBtn.isHidden = true
//        cell.mapbtn.isHidden = true
        
        return cell
    }
    
//        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return self.tableView.frame.height / 4.5
//    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isSelected = offers[indexPath.row].isSelected
        offers[indexPath.row].isSelected = !isSelected
         
        if let iPath = selectedOfferIndexPath {
            if iPath != indexPath {
                offers[iPath.row].isSelected = false
                tableView.reloadRows(at: [indexPath, iPath], with: .automatic)
            }
            
        }else {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        selectedOfferIndexPath = indexPath
        offerQuantityRang  = (max: offers[indexPath.row].offer.to ?? 0, min: offers[indexPath.row].offer.from ?? 0)
        parameters["offer_id"] = offers[indexPath.row].offer.id ?? 0
        quantitiyTextFeild.text = "\(offerQuantityRang.min)"
        offerPriceCalculator(count: Float(offerQuantityRang.min) ?? 0.0)
    }
    
    func handleTableView(){
        offersTableView.register(UINib(nibName: "OfferTableViewCell", bundle: nil), forCellReuseIdentifier: "OfferTableViewCell")
        offersTableView.addObserver(self, forKeyPath: Constants.contentSizeObserverKey, options: .new, context: nil)
        offersTableView.delegate = self
        offersTableView.dataSource = self
        
    }
}
