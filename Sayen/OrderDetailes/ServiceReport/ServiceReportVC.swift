//
//  ServiceReport.swift
//  Sayen 
//
//  Created by ME-MAC on 6/19/22.
//

import UIKit

class ServiceReportVC : UIViewController {
    
    @IBOutlet weak var orderNumLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var serviceTitleLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var mainPriceLabel: UILabel!
    @IBOutlet weak var cashStatLabel: UILabel!
    @IBOutlet weak var techNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var paymentMethodLbl: UILabel!
    @IBOutlet weak var orderStateLabel: UILabel!
    @IBOutlet weak var addedPriceLabel: UILabel!
    
    var order_id = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        getInvoiceDetails ()
        
    }
    
    @IBAction func showInvocieButton(_ sender: Any) {
        APIClient.makePdf(order_id: order_id) { status, urlStr in
            if status {
                
                let webURL = NSURL(string: urlStr)!
                if UIApplication.shared.canOpenURL(webURL as URL) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
                    }
                    else {
                        UIApplication.shared.openURL(webURL as URL)
                    }
                }
            }
        } completionFaliure: { error in
            print(error?.localizedDescription)
        }
    }
    
    func getInvoiceDetails () {
        ad.isLoading()
        APIClient.showInvoice(order_id: order_id, completionHandler: { (state , data) in
            ad.killLoading()
            print(state)
            
            guard state else{
                self.showDAlert(title:  "Error".localized, subTitle: "tryAgain".localized , type: .withContent, buttonTitle: "tryAgain".localized) { (_) in
                             // self.goToHome()
                          }
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                
                    self.paymentMethodLbl.text = data.pay_method == "1" ? "PayCash".localized : "payOnline".localized
                    
                    if data.pay_status == "1" {
                        self.cashStatLabel.text = "paid".localized
//                        self.truePay.alpha = 1
                        self.cashStatLabel.textColor = .greenColor
                    }
                    
                    self.serviceTitleLabel.text = data.service
                    self.dateLabel.text = data.date
                    self.orderNumLabel.text = "#\(data.order_number!)"
                    self.totalPriceLabel.text  = "\(data.final_price!) " + "Rial".localized
                    self.mainPriceLabel.text  = "\(data.initial_price!) " + "Rial".localized
                    self.orderStateLabel.text = data.order_status ?? ""
                    self.techNameLabel.text = data.team_name ?? ""
                    let building = (data.building ?? "") + " / "
                    let floor = (data.floor ?? "") + " / "
                    let flat = data.flat ?? ""
                    
                    var address =  building + floor + flat
                    if address == " /  / " {
                        address = "noAddress".localized
                    }
                    self.addressLabel.text = address
//                    self.addedPriceLabel.text = (data.added_price ?? "0") + "Rial".localized
                    self.addedPriceLabel.text  = "\(data.final_price!) " + "Rial".localized
                }
               
              //  print(self.probImages.count)
                
            }
        }) { (error) in
            ad.killLoading()
            self.showDAlert(title:  "Error".localized, subTitle: "tryAgain".localized , type: .withContent, buttonTitle: "tryAgain".localized) { (_) in
             //   self.goToHome()
            }
            print(error)
        }
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        self.dismissViewC()
    }
}
