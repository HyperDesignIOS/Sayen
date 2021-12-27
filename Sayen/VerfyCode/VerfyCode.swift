//
//  VerfyCode.swift
//  Sayen
//
//  Created by Maher on 5/31/20.
//  Copyright © 2020 maher. All rights reserved.
//

import UIKit
enum type {
    case register
    case teamRegister
    case forgetPass
    case changePhone
}
class VerfyCode: UIViewController {

    @IBOutlet weak var titleLBl: UILabel!
    @IBOutlet weak var pinView: VKPinCodeView!
    @IBOutlet weak var counterLbl: UILabel!
    @IBOutlet weak var counterStack: UIStackView!
    @IBOutlet weak var buttonsStack: UIStackView!
    var seconds = 30
    //    var seconds = 1
//    _layoutDirection
    var phone = ""
    var code_type = "1"
    weak var delegate : ChangePhone!
    var timer:Timer? = Timer()
    var isTimeRunning = false
    var type : type = .register
    var user_type : String {
           return ad.user_type()
       }
    var tabBar : UITabBarController?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        switch type {
        case .changePhone:
            self.titleLBl.text = "confirmMobile".localized
            self.code_type = "3"
        case .register  , .teamRegister:
            self.titleLBl.text = "confirmMobile".localized
            self.code_type = "1"
        case .forgetPass:
            self.titleLBl.text = "forgetPassword".localized
            self.code_type = "2"
        }
       pinView.onSettingStyle = {
            BorderStyle(
                textColor: .mainColor,
                borderWidth: 0,
                backgroundColor: .white,
                selectedBackgroundColor: UIColor.secondaryWhiteColor
                )
         
        }
        
        pinView.validator = validator(_:)
        runTimer()
        pinView.onComplete = { [weak self] (code , _) in
                self?.sendCode()
            }
    }

    
    

    
      override func viewDidDisappear(_ animated: Bool) {
          super.viewDidDisappear(animated)
          timer?.invalidate()
          timer = nil
          
      }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds -= 1
        let countS =  seconds < 10 ? "0\(seconds)" : "\(seconds)"
        counterLbl.text = countS +  " " + "second".localized + " "
        isTimeRunning = true
        buttonsStack.alpha = 0
        counterStack.alpha = 1
        
        if seconds == 0 {
            timer?.invalidate()
            timer = nil
            seconds = 30
            isTimeRunning  = false
            self.counterStack.alpha = 0
            buttonsStack.alpha = 1
        }
    }
    
    
    

    @IBAction func verfyCode(_ sender: Any) {
        self.pinView.regisnFireResponder()
        sendCode()
        
    }
    @IBAction func dismiss(_ sender: Any) {
        self.dismissViewC()
    }
    
    
    @objc func sendCode() {
    
        guard self.pinView.code.count == 4 else {
            self.showDAlert(title: "Error".localized, subTitle: "enterRightCode".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            return }
        self.pinView.isUserInteractionEnabled = false
          ad.isLoading()
        APIClient.verifyCodeReuqest(mobile: self.phone, code: self.pinView.code,country_code : "966" , code_type : self.code_type,user_type : self.user_type ,type  : self.type , completionHandler: {[weak self] (status, sms) in
            defer {
                DispatchQueue.main.async {
                    self?.pinView.isUserInteractionEnabled = true
                }

            }
            print(status, sms)
            guard status else {
                
                DispatchQueue.main.async {
                ad.killLoading()
                    self?.showDAlert(title: "Error".localized, subTitle: "enterRightCode".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                    self?.pinView.isError = true
                  
                    
                }
                return }
            DispatchQueue.main.async {
                guard let self = self else {return}
                    ad.killLoading()
                    self.pinView.isUserInteractionEnabled = true
                    Constants.phoneNum = self.phone
                switch self.type {
                case .teamRegister :
                    DispatchQueue.main.async {
                        self.showDAlert(title: "requestRecived".localized, subTitle: "youWillGetVerificationMessage".localized, type: .success, completionHandler: { (_) in
                        
                        DispatchQueue.main.async {

                        ad.restartApplicationToLogin()
                        }
                    })
                    }
                case .register:
                    DispatchQueue.main.async {
                        self.showDAlert(title: "thanks".localized, subTitle: "welcomToSayen".localized, type: .success, buttonTitle: "") { (_) in
                        
                        self.goToHome()
                        }
                    }
                    
                case .forgetPass:
                    self.goToResetPass()
                case .changePhone:
                    
                    DispatchQueue.main.async {
                        self.showDAlert(title: "thanks".localized, subTitle:  "requestSentSuccessfully".localized, type: .success, buttonTitle: "") { (_) in
                            DispatchQueue.main.async {
                                self.dismissViewC()
                            }
                        }
                    }
                    self.dismissViewC()
                    self.delegate.dismissAndShowSms(state: true)
                    
                }
                    
             

            
            }

        }) { [weak self] (err) in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                ad.killLoading()
                self?.pinView.isUserInteractionEnabled = true

             }
            
        }
        
    }
    func goToResetPass () {
        let vc = NewPasswordVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func goToHome(){
        DispatchQueue.main.async {
            let navController = UINavigationController()
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            guard let window = keyWindow else {return}
            let storyb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            self.tabBar = storyb.instantiateViewController(withIdentifier: "rootNav") as? UITabBarController
            navController.navigationBar.isHidden = true
            navController.viewControllers = [self.tabBar!]
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
        
    }
    
    @IBAction func sendAgain(_ sender: Any) {
        seconds = 30
        self.runTimer()
              
        reSendVerifyCode()
    }
    
    private func reSendVerifyCode() {
        
        self.pinView.resetCode()

        APIClient.resendCodeReqeust(mobile: self.phone,country_code : "966" , code_type : self.code_type,user_type : self.user_type , completionHandler: { (status, sms) in

            guard status else { return }
            DispatchQueue.main.async {
              

            }
        }) { (err) in
            self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)


        }
    }
    
    private func validator(_ code: String) -> Bool {
          
          return !code.trimmingCharacters(in: CharacterSet.decimalDigits.inverted).isEmpty
      }
      
}


protocol ChangePhone : class {
    func dismissAndShowSms (state : Bool)
}
