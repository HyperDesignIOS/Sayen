//
//  LogOutAlert.swift
//  Sayen 
//
//  Created by Maher on 7/6/20.
//

import UIKit

class LogOutAlert: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
