//
//  ProfileViewModel.swift
//  Sayen 
//
//  Created by Maher on 6/4/20.
//

import UIKit
class ProfileViewModel {
    var data : [MenuList] = [.popualarQu,.aboutSayen,.contactUs,.share,.rateApp,.changeLanguage,.logout]
    
    
}



enum MenuList {
    
    case popualarQu, aboutSayen,share,rateApp,contactUs,changeLanguage,logout
    
    
    func getData() -> (title:String,image:UIImage) {
        switch self {
        case .popualarQu:
            return ("commonQuestion".localized , UIImage(named: "Group 1080")!)
        case .aboutSayen:
            return ("aboutSayen".localized ,UIImage(named: "Group 1081")!)
        case .contactUs:
            return ("contactUs".localized ,UIImage(named: "Group 1088")!)
        case .share:
            return ("shareApp".localized ,UIImage(named: "Group 1083")!)
        case .rateApp:
            return ("rateApp".localized ,UIImage(named: "Group 1084")!)
        case .changeLanguage:
            return ("changeLanguage".localized ,UIImage(named: "Group 10899")!)
        case .logout:
            return ("signOut".localized ,UIImage(named: "Group 1086")!)
         }
    }
}
