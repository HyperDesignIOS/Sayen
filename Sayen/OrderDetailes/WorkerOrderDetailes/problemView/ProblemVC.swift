//
//  ProblemVC.swift
//  Sayen  Worker
//
//  Created by Maher on 6/17/20.
//

import UIKit
import DLRadioButton

class ProblemVC: UIViewController {
 
    var order_id : Int = 0
    var problem_type : Int = 0
    var tabBar : UITabBarController?
    var data : [ProblemTypes] = []
    @IBOutlet weak var tableView: UITableView!
    var selectedBool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "ProblemCell", bundle: nil), forCellReuseIdentifier: "ProblemCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        getProblemType ()

        // Do any additional setup after loading the view.
    }


    func getProblemType () {
        ad.isLoading()
        APIClient.problemType(completionHandler: { (state, data) in
            ad.killLoading()
            guard state else {
                self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                return
            }
            if let data = data {
             
                self.data = data
                self.tableView.reloadData()
            }
            
        }) { (error) in
            ad.killLoading()
            print("error")
        }
    }
    
    
    
    @IBAction func EndWork(_ sender: Any) {

        guard self.selectedBool else{
            self.showDAlert(title: "Error".localized, subTitle: "setProblem".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            return
        }
        ad.isLoading()
        APIClient.teamReportProblem(order_id: self.order_id, problem_type: problem_type, completionHandler: { (state, sms) in
            ad.killLoading()
            guard state else{
                self.showDAlert(title: "Error".localized, subTitle: sms, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)

                return
            }
            print(sms)
            self.showDAlert(title: "", subTitle: "workDone".localized, type: .success, buttonTitle: "done".localized ) { (_) in
                          self.goToHome()
                      }
        }) { (err) in
            ad.killLoading()
            self.showDAlert(title: "Error".localized, subTitle: "", type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)

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


extension ProblemVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProblemCell" , for: indexPath) as! ProblemCell
        cell.problemTxt.text = data[indexPath.row].problem
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.height / 7
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         let cell = tableView.cellForRow(at: indexPath) as! ProblemCell
         self.problem_type = data[indexPath.row].id!
         if cell.radioBtn.isSelected {
            // cell.radioBtn.isSelected = false
            
            cell.radioBtn.setImage(UIImage(named: "radio-button-off"), for: .normal)
        }else{
            // cell.radioBtn.isSelected = true
            self.selectedBool = true
            cell.radioBtn.setImage(UIImage(named: "radio-button-active"), for: .normal)
        }
        
    }
 //   radio-button-active
 //  radio-button-off
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
         let cell = tableView.cellForRow(at: indexPath) as! ProblemCell
      //  cell.radioBtn.isSelected = false
        cell.radioBtn.setImage(UIImage(named: "radio-button-off"), for: .normal)
    }
    
}
