//
//  CancelOrderAlert.swift
//  Sayen 
//
//  Created by Maher on 7/6/20.
//

import UIKit

class CancelOrderAlert: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    var delegate : EndYesOrNo!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLbl.font = UIFont(name: "Tajawal-Medium", size: 18)
        // Do any additional setup after loading the view.
    }


    @IBAction func yesAction(_ sender: Any) {
        self.dismissViewC()
        delegate.EndOrderAndFinish(state: true)
        
    }
    
    @IBAction func noAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    
}


protocol EndYesOrNo : class{
    func EndOrderAndFinish (state : Bool)
}
