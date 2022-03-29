//
//  AlertViewC.swift
//  Sayen
//
//  Created by Maher on 5/31/20.
//  Copyright © 2020 maher. All rights reserved.
//

import UIKit

class AlertViewC: UIViewController {

    @IBOutlet weak var alertSms: UILabel!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var tryAgianOut: UIButtonX!
    @IBOutlet weak var textTopCons: NSLayoutConstraint!
    @IBOutlet weak var alertImage: UIImageView!
    @IBOutlet weak var closeButtonOutlet: UIButton!
    var type : AlertType = .success
    var mainTitle_ = ""
    var subTitle = ""
    var buttonTitle = ""
    var completionHandler : ((Bool)->())?
    override func viewDidLoad() {
        super.viewDidLoad()
        if buttonTitle == "" {
             self.tryAgianOut.alpha = 0
            self.textTopCons.constant = 60
        }else{
             self.tryAgianOut.alpha = 1
             self.textTopCons.constant = 16
             self.tryAgianOut.setTitle(buttonTitle, for: .normal)
        }
       
        self.alertSms.text = subTitle
        alertSms.setLineHeight(lineHeight: 1.5)
        self.mainTitle.text = mainTitle_
        putImage()
        
        switch type {
        case .sucNil:
            DispatchQueue.main.asyncAfter(deadline: .now()+1.0) {
                self.dismissViewC()
            }
        default:
            print("ok")
        }
    }
    
    func putImage () {
        switch type {
        case .sucNil:
            self.alertImage.image = UIImage(named: "Group 22")
        case .success:
            self.alertImage.image = UIImage(named: "Group 22")
        case .error:
            self.alertImage.image = UIImage(named: "Group 1095")
        case .withContent:
            self.alertImage.image = UIImage(named: "Group 1095")
        case .net :
            self.alertImage.image = UIImage(named: "undraw_server_down_s4lk")
        case .updateRequired:
            self.alertImage.image = UIImage(named: "Logo-Final-SAYEN")
            closeButtonOutlet.isHidden = true
        default:
            self.alertImage.image = UIImage(named: "Logo-Final-SAYEN")
        }
    }

    @IBAction func tryAgin(_ sender: Any) {
        if completionHandler == nil {
            self.dismissViewC()
        }else{
         self.dismissHandler(success:true)
        }
    }
    
  
    @IBAction func dismissAllView(_ sender: Any) {
        if buttonTitle == ""{
            if completionHandler == nil {
                self.dismissViewC()
            }else{
                self.dismissHandler(success:true)
            }
            return
        }
        if completionHandler == nil {
            self.dismissViewC()
        }else{
            switch type {
            case .error :
                self.dismissViewC()
            case .updateRequired:
                break
            default:
                self.dismissHandler(success:false)
            }
            
        }
        
    }
    
    func dismissHandler(success:Bool = false ) {
        
        
        DispatchQueue.main.async{ [weak self] in
            guard let self = self else {return}
            switch self.type {
            case .updateRequired:
                break
            default:
                self.dismissViewC()
            }
              
//            self?.dismiss(animated: true, completion: {
                self.completionHandler?(success)
         
      //        })
        }
    }
    
}




