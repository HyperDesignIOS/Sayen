//
//  RatingVC.swift
//  Sayen 
//
//  Created by Maher on 6/16/20.
//

import UIKit
import SwiftyStarRatingView

class RatingVC: UIViewController {

    @IBOutlet weak var placeHolderLbl2: UILabel!
    @IBOutlet weak var placeHolderLbl: UILabel!
    @IBOutlet weak var workRate: SwiftyStarRatingView!
    var order_id : Int = 0
    @IBOutlet weak var workerComment: UITextView!
    @IBOutlet weak var workComment: UITextView!
    @IBOutlet weak var workerRate: SwiftyStarRatingView!
    var tabBar : UITabBarController?
    
    var controllerType: RateType = .order
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workerComment.delegate = self
        workComment.delegate = self
        workRate.value = 0
        workerRate.value = 0
        workRate.transform = CGAffineTransform(scaleX: -1, y: 1)
        workerRate.transform = CGAffineTransform(scaleX: -1, y: 1)
        // Do any additional setup after loading the view.
    }


    @IBAction func doneRate(_ sender: Any) {
        let rateWork = Int(workRate.value)
        let rateWorker = Int(workerRate.value)
        guard rateWork != 0 , rateWorker != 0 , workerComment.text.count >= 1 else{
            self.showDAlert(title: "Error".localized, subTitle: "rateWorker".localized , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            return}
        ad.isLoading()

        APIClient.ratingTeamService(order_id: self.order_id, rate_service_value: rateWork, rate_team_value: rateWorker, rate_service_comment: self.workComment.text, rate_team_comment: self.workerComment.text, type: controllerType.rawValue, completionHandler: { (state, sms) in
            ad.killLoading()
            guard state else {
                return
            }
            self.showDAlert(title: "", subTitle: "rateDone".localized, type: .success, buttonTitle: "done".localized ) { (_) in
                self.goToHome()
            }
        }) { (err) in
            print("error")
        }
    }
    
      func goToHome(){
          let navController = UINavigationController()
          let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
          guard let window = keyWindow else {return}
          let storyb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
          tabBar = storyb.instantiateViewController(withIdentifier: "rootNav") as? UITabBarController
          navController.navigationBar.isHidden = true
          navController.viewControllers = [tabBar!]
          window.rootViewController = navController
          window.makeKeyAndVisible()
          
      }
    @IBAction func dismiss(_ sender: Any) {
        self.dismissViewC()
    }
    
}

extension RatingVC : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.placeHolderLbl.alpha = 0
        self.placeHolderLbl2.alpha = 0
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.workComment.text == "" {
             self.placeHolderLbl2.alpha = 1
        }
        if self.workerComment.text == "" {
            self.placeHolderLbl.alpha = 1
        }
       }
    
}

enum  RateType : String{
    case order
    case EmergencyOrder
}
