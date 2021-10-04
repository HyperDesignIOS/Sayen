//
//  cancelSendOrder.swift
//  Sayen 
//
//  Created by Maher on 7/8/20.
//

import UIKit

class cancelSendOrder: UIViewController {
     var delegate : cancelAlertSend!

         override func viewDidLoad() {
             super.viewDidLoad()
             
         }


         @IBAction func yesAction(_ sender: Any) {
             self.dismissViewC()
             delegate.cancelAlertSendFunc()
             
         }
         
         @IBAction func noAction(_ sender: Any) {
             self.dismiss(animated: false, completion: nil)
         }
         
         
         
     }


    protocol cancelAlertSend : class{
         func cancelAlertSendFunc ()
     }

