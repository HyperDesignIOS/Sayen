//
//  LogOutAlert.swift
//  Sayen 
//
//  Created by Maher on 7/6/20.
//

import UIKit

class LogOutAlert: UIViewController {
    
    @IBOutlet weak var alertImage: UIImageView!
    @IBOutlet weak var alertMsg: UILabel!
    @IBOutlet weak var deletAccountButtonOutlet: UIButton!
    
    var type : LogoutType = .logout
    override func viewDidLoad() {
        super.viewDidLoad()
        if type == .deleteAccount {
            alertImage.image = UIImage(named: "remove-user")
            alertMsg.text = "deactivateMsg".localized
            deletAccountButtonOutlet.setTitle("deletAccount".localized, for: .normal)
        }

        // Do any additional setup after loading the view.
    }

    @IBAction func logOutHandler(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
        logout()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    //    self.navigationController?.popViewController(animated: false)
    }
    
    func logout() {
        ad.isLoading()
            guard ad.isOnline() else {
                 return
            }
        print(ad.user_type())
            APIClient.logoutHandler(user_type : ad.user_type() , completionHandler: { (status) in
                ad.killLoading()
                guard status else { return }
                DispatchQueue.main.async {
                ad.save(userId: nil, token: nil)
                ad.restartApplicationToLogin()
                UserDefaults.standard.setValue(nil, forKey: Constants.firebaseTokenKey)
                }
            }) { (err) in
                
                ad.killLoading()
            }

    }

}
enum LogoutType{
    case logout
    case deleteAccount
}
