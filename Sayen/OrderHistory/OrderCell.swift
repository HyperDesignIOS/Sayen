//
//  OrderCell.swift
//  Sayen 
//
//  Created by Maher on 6/13/20.
//

import UIKit

class OrderCell: UITableViewCell {

    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var orderNum: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var inWayTitle: UILabel!
    @IBOutlet weak var endTitle: UILabel!
    @IBOutlet weak var inProgTitle: UILabel!
    @IBOutlet weak var newOrderTite: UILabel!
    @IBOutlet weak var newOrderImg: UIImageView!
    @IBOutlet weak var inWayImg: UIImageView!
    @IBOutlet weak var inProgImg: UIImageView!
    @IBOutlet weak var endImg: UIImageView!
    @IBOutlet weak var inProgV: UIView!
    @IBOutlet weak var inWayV: UIView!
    @IBOutlet weak var gotoEndV: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    func setStatus (orderStatus : String){
        if  orderStatus == "1" || orderStatus == "5"  {
            self.inWayTitle.text = "inMyWay".localized
            self.newOrderImg.image = UIImage(named: "Group 1069")
            self.inWayImg.image = UIImage(named: "Ellipse 69")
            self.inProgImg.image = UIImage(named: "Ellipse 70")
            self.endImg.image = UIImage(named: "Ellipse 70")
            self.inWayV.backgroundColor = UIColor.secondaryColor
            self.inWayTitle.textColor = UIColor.secondaryColor
            self.endTitle.textColor = UIColor.secondaryColor
            self.inProgTitle.textColor = UIColor.secondaryColor
            self.newOrderTite.textColor = UIColor.brownMainColor
            self.inProgV.backgroundColor =  UIColor.secondaryColor
            self.inWayV.backgroundColor =  UIColor.brownMainColor
            self.gotoEndV.backgroundColor =  UIColor.secondaryColor
            self.inWayTitle.alpha = 1
            self.endTitle.alpha = 1
            self.inProgTitle.alpha = 1
            self.newOrderTite.alpha = 1
            self.newOrderImg.alpha = 1
            self.inWayImg.alpha = 1
            self.inProgImg.alpha = 1
            self.endImg.alpha = 1
            self.inProgV.alpha = 1
            self.inWayV.alpha = 1
            self.gotoEndV.alpha = 1
        } else if orderStatus == "2"{
            //To in progress
            self.inWayImg.image = UIImage(named: "Group 1069")
            self.inProgImg.image =  UIImage(named: "Group 1069")
            self.endImg.image = UIImage(named: "Ellipse 69")
            self.inWayV.backgroundColor = UIColor.brownMainColor
            self.inProgV.backgroundColor = UIColor.brownMainColor
            self.newOrderTite.textColor = UIColor.brownMainColor
            self.inWayTitle.textColor = UIColor.brownMainColor
            self.inProgTitle.textColor = UIColor.brownMainColor
            self.gotoEndV.backgroundColor = UIColor.brownMainColor
            
        }else if orderStatus == "3"{
            //To end prog
            self.inWayImg.image = UIImage(named: "Group 1069")
            self.inProgImg.image  =  UIImage(named: "Group 1069")
            self.endImg.image  =  UIImage(named: "Group 1069")
            self.inWayV.backgroundColor = UIColor.brownMainColor
            self.inProgV.backgroundColor = UIColor.brownMainColor
            self.gotoEndV.backgroundColor = UIColor.brownMainColor
            self.newOrderTite.textColor = UIColor.brownMainColor
            self.inWayTitle.textColor = UIColor.brownMainColor
            self.inProgTitle.textColor = UIColor.brownMainColor
            self.endTitle.textColor = UIColor.brownMainColor
            self.inProgV.alpha = 1
            self.gotoEndV.alpha = 1
            self.inProgImg.alpha = 1
            self.endImg.alpha = 1
            self.inProgTitle.alpha = 1
            self.endTitle.alpha = 1
            
        }else if (orderStatus == "4") {
            self.newOrderImg.image = UIImage(named: "Group 1069")
            self.inWayV.backgroundColor = UIColor.brownMainColor
            self.newOrderTite.textColor = UIColor.brownMainColor
            self.inWayImg.image = UIImage(named: "Group 1070")
            self.inWayTitle.textColor = UIColor.red
            self.inWayTitle.text = "canceled".localized
            self.inProgV.alpha = 0
            self.gotoEndV.alpha = 0
            self.inProgImg.alpha = 0
            self.endImg.alpha = 0
            self.inProgTitle.alpha = 0
            self.endTitle.alpha = 0
            
        }  else if orderStatus == "6"{
            //To in way
            self.inWayImg.image = UIImage(named: "Group 1069")
            self.inProgImg.image =  UIImage(named: "Ellipse 69")
            self.inWayTitle.textColor = UIColor.brownMainColor
            self.inProgV.backgroundColor = UIColor.brownMainColor
        }
        
    }
    
}
//{
//    if orderStatus == "1" {
//        self.newOrderimg.image = UIImage(named: "Group 1069")
//        self.goToDoneV.backgroundColor = UIColor.secondaryColor
//        self.newOrderTit.textColor = UIColor.brownMainColor
//        self.goDoneImg.image = UIImage(named: "Ellipse 70")
//        self.gotoEndV.backgroundColor = UIColor.secondaryColor
//        self.inProcTitle.textColor = UIColor.secondaryColor
//        self.endImg.image = UIImage(named: "Ellipse 70")
//        self.endTitle.textColor = UIColor.secondaryColor
//        self.inProcTitle.text = "قيد الإجراء"
//        self.endImg.alpha = 1
//        self.endTitle.alpha = 1
//        self.gotoEndV.alpha = 1
//
//    }else if orderStatus == "2" {
//        self.newOrderimg.image = UIImage(named: "Group 1069")
//        self.goToDoneV.backgroundColor = UIColor.brownMainColor
//        self.newOrderTit.textColor = UIColor.brownMainColor
//        self.goDoneImg.image = UIImage(named: "Group 1069")
//        self.gotoEndV.backgroundColor = UIColor.brownMainColor
//        self.inProcTitle.textColor = UIColor.brownMainColor
//        self.endImg.image = UIImage(named: "Ellipse 69")
//        self.endTitle.textColor = UIColor.secondaryColor
//        self.endImg.alpha = 1
//        self.inProcTitle.text = "قيد الإجراء"
//        self.endTitle.alpha = 1
//        self.gotoEndV.alpha = 1
//
//    } else if orderStatus == "3" {
//        self.newOrderimg.image = UIImage(named: "Group 1069")
//        self.goToDoneV.backgroundColor = UIColor.brownMainColor
//        self.newOrderTit.textColor = UIColor.brownMainColor
//        self.goDoneImg.image = UIImage(named: "Group 1069")
//        self.gotoEndV.backgroundColor = UIColor.brownMainColor
//        self.inProcTitle.textColor = UIColor.brownMainColor
//        self.endImg.image = UIImage(named: "Group 1069")
//        self.endTitle.textColor = UIColor.brownMainColor
//        self.inProcTitle.text = "قيد الاجراء"
//        self.gotoEndV.alpha = 1
//        self.endImg.alpha = 1
//        self.endTitle.alpha = 1
//
//        //Group 1070
//    }else if orderStatus == "4" {
//        self.newOrderimg.image = UIImage(named: "Group 1069")
//        self.goToDoneV.backgroundColor = UIColor.brownMainColor
//        self.newOrderTit.textColor = UIColor.brownMainColor
//        self.goDoneImg.image = UIImage(named: "Group 1070")
//        self.inProcTitle.textColor = UIColor.red
//        self.inProcTitle.text = "canceled".localized
//        self.gotoEndV.alpha = 0
//        self.endImg.alpha = 0
//        self.endTitle.alpha = 0
//    }else if orderStatus == "5" {
//        self.newOrderimg.image = UIImage(named: "Group 1069")
//        self.goToDoneV.backgroundColor = UIColor.brownMainColor
//        self.newOrderTit.textColor = UIColor.brownMainColor
//        self.goDoneImg.image = UIImage(named: "Ellipse 69")
//        self.inProcTitle.text = "قيد الإجراء"
//        self.gotoEndV.backgroundColor = UIColor.secondaryColor
//        self.inProcTitle.textColor = UIColor.secondaryColor
//        self.endImg.image = UIImage(named: "Ellipse 70")
//        self.endTitle.textColor = UIColor.secondaryColor
//        self.endImg.alpha = 1
//        self.endTitle.alpha = 1
//        self.gotoEndV.alpha = 1
//
//    }
//
//}
