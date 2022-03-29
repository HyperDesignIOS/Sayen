//
//  OffersAlert.swift
//  Sayen 
//
//  Created by ME-MAC on 3/1/22.
//


import UIKit

class ServicesOffers: UIViewController {
    
    @IBOutlet weak var serviceTableView: UITableView!
    var user : UserProfile_Data? = nil
    var offers : [OfferService] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serviceTableView.delegate = self
        serviceTableView.dataSource = self
        self.serviceTableView.register(UINib(nibName: "NotiCell", bundle: nil), forCellReuseIdentifier: "NotiCell")
    }
   
    @IBAction func backButtons(_ sender: UIButton){
        self.dismissViewC()
    }
}
