//
//  OnlinePaymentVC.swift
//  MiniSouq-Buyer
//
//  Created by Eslam Abo El Fetouh on 3/2/20.
//  Copyright © 2020 Clouds. All rights reserved.
//

import UIKit
import WebKit
import CDAlertView

class OnlinePaymentVC: UIViewController , WKNavigationDelegate, WKUIDelegate {

      var webView: WKWebView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    var urlSt  = ""
    var loadedOnce = false
    override func viewDidLoad() {
        super.viewDidLoad()
        ad.isLoading()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(webView)

        webView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        webView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

        
        
        webView.navigationDelegate = self

        if let url = URL(string: urlSt) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)

        // Do any additional setup after loading the view.
    }
    
 
    
     func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard !loadedOnce else { return }
        loadedOnce = true
        ad.killLoading()

     }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            print(Float(webView.estimatedProgress))
        }
        if keyPath == "title" {
            if let title = webView.title {
                print(title)
//                titleLbl?.text = title
            }
        }
        print(keyPath , change)
    }
    
 
    @IBAction func dismissHandler(_ sender: UIButton) {
   
        self.dismissViewC()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let urlStr = navigationAction.request.url?.absoluteString  , self.webView.alpha != 0 {
            //urlStr is what you want
            if urlStr.contains("message=Succeeded") {
                self.webView.alpha = 0
                DispatchQueue.main.async{
                    self.showDAlert(title: "thanks".localized, subTitle:  "paymentSuccess".localized, type: .success, buttonTitle: "") { [weak self](_) in
                        DispatchQueue.main.async{
                        self?.gotoOrders()
                        }
                    }
                 }
            }else if urlStr.contains("status=failed") {
                self.showDAlert(title: "Error".localized, subTitle: "paymentError".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            }
        }
            
        decisionHandler(.allow)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func gotoOrders() {
        DispatchQueue.main.async {
            var tabBar : UITabBarController?
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            guard let window = keyWindow else {return}
            let storyb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            tabBar = storyb.instantiateViewController(withIdentifier: "rootNav") as? UITabBarController
            tabBar?.selectedIndex = 1
            window.rootViewController = tabBar
            window.makeKeyAndVisible()
        }
    }
}
