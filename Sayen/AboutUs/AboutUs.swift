//
//  AboutUs.swift
//  Sayen 
//
//  Created by Maher on 6/28/20.
//

import UIKit

class AboutUs: UIViewController {
    @IBOutlet weak var abutTxt: UITextView!
    
    @IBOutlet weak var whatsapBtnOL: UIButton!
    @IBOutlet weak var instaBtnOL: UIButton!
    @IBOutlet weak var twitterBtnOL: UIButton!
    @IBOutlet weak var facebookBtnOL: UIButton!
    @IBOutlet weak var telegramBtnOL: UIButton!
 

    var data : StaticPageModel?
    var telegram : String?
    var twitter : String?
    var whatsapp : String?
    var instagram : String?
    var facebook : String?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBar = self.tabBarController as? TabBarController
        tabBar?.hideTab()
        getAboutText ()
        
 
    }

    @IBAction func dismiss(_ sender: Any) {
        let tabBar = self.tabBarController as? TabBarController
        self.dismissViewC()
        tabBar?.showTab()
        
    }
    func openFaceBook () {
        guard let faceBook = facebook , faceBook != "" else{
            return
        }
        UIApplication.tryURL(urls: [
                  "fb://profile/116374146706", // App
                   faceBook// Website if app fails
                  ])
    }
    
    func whatsApp () {
        guard let whatsApp = self.whatsapp else{
                   return
               }
      let urlWhats = "https://wa.me/\(whatsApp)/?text="
         if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
             if let whatsappURL = URL(string: urlString) {
                 if UIApplication.shared.canOpenURL(whatsappURL){
                     if #available(iOS 10.0, *) {
                         UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                     } else {
                         UIApplication.shared.openURL(whatsappURL)
                     }
                 }
                 else {
                     print("Install Whatsapp")
                 }
             }
         }
    }
    
    func InstagramAction() {
        guard let instagram = self.instagram , instagram != "" else{
                  return
              }
        let Username = instagram // Your Instagram Username here
       // let appURL = URL(string: "instagram://user?username=\(Username)")!
        let appURL = URL(string: Username)!
        let application = UIApplication.shared

        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            // if Instagram app is not installed, open URL inside Safari
            let webURL = URL(string: "https://instagram.com/\(Username)")!
            application.open(webURL)
        }

    }
    
    func followOnTwitter() {
        guard let twitter = self.twitter , twitter != "" else{
                         return
                     }
       let screenName =  "Maher"
//       let appURL = NSURL(string: "twitter://user?screen_name=\(screenName)")!
//       let webURL = NSURL(string: "https://twitter.com/\(screenName)")!
        let appURL = NSURL(string: twitter)!
         let webURL = NSURL(string: twitter)!

       let application = UIApplication.shared

       if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
       } else {
            application.open(webURL as URL)
       }
    }
    
    func openTelgram () {
        guard let telegram = self.telegram , telegram != "" else{
                               return
                           }
        let screenName = telegram  // <<< ONLY YOU NEED TO CHANGE THIS
        let appURL = NSURL(string: "tg://resolve?domain=\(screenName)")!
        let webURL = NSURL(string: "https://t.me/\(screenName)")!
        if UIApplication.shared.canOpenURL(appURL as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(appURL as URL)
            }
        }
        else {
            //redirect to safari because the user doesn't have Telegram
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(webURL as URL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(webURL as URL)
            }
        }
    }
    @IBAction func socialLink(_ sender: UIButton) {
        if sender.tag == 0{
            openTelgram()
        }
        else if sender.tag == 1 {
          openFaceBook ()
        }
        else if sender.tag == 2 {
            followOnTwitter()
        }
        else if sender.tag == 3 {
            InstagramAction()
            
        }
        else if sender.tag == 4 {
            whatsApp ()
        }
    }
    
    
    func getAboutText () {
        ad.isLoading()
        APIClient.static_page(id: 1, completionHandler: { (data) in
            ad.killLoading()
            if let data = data {
                DispatchQueue.main.async {
                     
              
                self.data = data
                self.abutTxt.text = data.content
                self.facebook = data.facebook
                self.whatsapp = data.whatsapp
                self.twitter = data.twitter
                self.telegram = data.telegram
                self.instagram = data.instagram
                self.whatsapBtnOL.isHidden =   data.whatsapp == ""
                self.instaBtnOL.isHidden =   data.instagram == ""
                self.twitterBtnOL.isHidden =   data.twitter == ""
                self.facebookBtnOL.isHidden =   data.facebook == ""
                self.telegramBtnOL.isHidden =   data.telegram == ""
  }
            }
           
            
        }) { (err) in
            ad.killLoading()
            print("error")
        }
    }

}





//تطبيق صاين مملوك لشركة عالم التميز .. إحدي شركات الرائده في السوق السعودي .. عايشت وعاصرت إنطلاقة القطاع العقاري والانشائي منذ تأسيسها في عام 2004 .. وتدربت علي آليات السوق الحديث .. واكتسبت خبرات متميزه .. وانتهجت تجربة مميزه بفضل كوادرهم وخبراتهم . لقد أقمنا علاقات طويلة الأمد مع أكثر من 4000 عميل في المنطقه الشرقية .





extension UIApplication {
    class func tryURL(urls: [String]) {
        let application = UIApplication.shared
        for url in urls {
            if application.canOpenURL(URL(string: url)!) {
                if #available(iOS 10.0, *) {
                    application.open(URL(string: url)!, options: [:], completionHandler: nil)
                }
                else {
                    application.openURL(URL(string: url)!)
                }
                return
            }
        }
    }
}
