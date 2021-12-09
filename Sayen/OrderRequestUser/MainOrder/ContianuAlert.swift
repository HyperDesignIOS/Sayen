//
//  ContianuAlert.swift
//  Sayen 
//
//  Created by Maher on 7/8/20.
//

import UIKit

class ContianuAlert: UIViewController {

    var delegate : containuToPaymentProtocol!

     override func viewDidLoad() {
         super.viewDidLoad()
         
     }


     @IBAction func yesAction(_ sender: Any) {
         delegate.continueToPaymentFunc()
        self.dismissViewC()
         
     }
     
     @IBAction func noAction(_ sender: Any) {
        self.dismissViewC()
     }
     
     
     
 }


protocol containuToPaymentProtocol : class{
     func continueToPaymentFunc()
 }

