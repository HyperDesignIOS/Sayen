//
//  ContianuAlert.swift
//  Sayen 
//
//  Created by Maher on 7/8/20.
//

import UIKit

class ContianuAlert: UIViewController {

    var delegate : containuProtocol!

     override func viewDidLoad() {
         super.viewDidLoad()
         
     }


     @IBAction func yesAction(_ sender: Any) {
         self.dismissViewC()
         delegate.continueFunc()
         
     }
     
     @IBAction func noAction(_ sender: Any) {
         self.dismiss(animated: false, completion: nil)
     }
     
     
     
 }


protocol containuProtocol : class{
     func continueFunc ()
 }

