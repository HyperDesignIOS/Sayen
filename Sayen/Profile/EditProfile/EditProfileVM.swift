//
//  EditProfileVM.swift
//  Sayen 
//
//  Created by Maher on 6/4/20.
//

import UIKit


class EditProfileVM {
    
    
    var data : [MenuList2] = [.editMyInfo , .editPhone,.changePass , .deletAccount]
    
}


enum MenuList2 {
    
    case editMyInfo, editPhone ,changePass , deletAccount
     
    func getData() -> (title:String,image:UIImage) {
        switch self {
        case .editMyInfo:
            return ("changePersonalInfo".localized ,UIImage(named: "Group 1087")!)
        case .editPhone:
            return ("chagneMobile".localized ,UIImage(named: "Group 1088")!)
        case .changePass:
            return ("changePassw".localized ,UIImage(named: "Group 1089")!)
        case .deletAccount:
            return ("deletAccount".localized ,UIImage(named: "remove-user")!)
            
        }
    }
}
