//
//  AppDelegate.swift
//  Takaful
//
//  Created by Eslam Abo El Fetouh on 3/15/20.
//  Copyright © 2020 Eslam Abo El Fetouh. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import IQKeyboardManagerSwift
import MOLH
import GoogleMaps
import Locksmith
import FirebaseCore
import FirebaseMessaging
import DropDown

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let activityData = ActivityData()
    var window: UIWindow?
    private let gcmMessageIDKey = "gcm.message_id"
    var GOOGLE_MAPS_API_KEY = Constants.GOOGLE_MAPS_API_KEY

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        MOLH.shared.activate(true)
        
       //  Thread.sleep(forTimeInterval: 2.0)
         IQKeyboardManager.shared.enable = true
         IQKeyboardManager.shared.toolbarDoneBarButtonItemText =  "done".localized 
         IQKeyboardManager.shared.shouldResignOnTouchOutside = true
         IQKeyboardManager.shared.keyboardDistanceFromTextField = 50
         IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
         
        DropDown.appearance().setupCornerRadius(10)
        DropDown.startListeningToKeyboard()

        Thread.sleep(forTimeInterval: 1.5)

         GMSServices.provideAPIKey(GOOGLE_MAPS_API_KEY)
         handleTOkenInFirstLaunch()
         FirebaseApp.configure()
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
       
   
         UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Tajawal-Regular", size: 10)!], for: .normal)
        //   MOLH.shared.activate(true)

//        MOLH.setLanguageTo("en")
       if #available(iOS 13, *) {
            window?.overrideUserInterfaceStyle = .light
        }
       

        return true
    }
    
    
  
    func handleTOkenInFirstLaunch() {
        
        if     UserDefaults.standard.value(forKey: "firstRun") == nil {
            UserDefaults.standard.setValue(true, forKey: "firstRun")
            do {
                try Locksmith.deleteDataForUserAccount(userAccount: "token")
              print(" Did Delete the saveTOken ")
                
            } catch {
              print("Couldn't Delete token ")
            }
            
            do {
                try Locksmith.deleteDataForUserAccount(userAccount: "UserId")
              print(" Did Delete the UserId ")
                
            } catch {
              print("Couldn't Delete UserId ")
            }
        }
    }
 
    
    func sendPlayerId (_ playerId : String ) {
        
        let user_type = ad.user_type()
        APIClient.requestUpdatePlayerID(playerID: playerId, user_type: user_type, completionHandler: { (state, sms) in
            guard state else{
                print("Player ID Didnot Updated!")
                UserDefaults.standard.setValue(false, forKey: "hasSentPlayerID")
                return
                
            }
            DispatchQueue.main.async {
                print("Player ID Updated!")
                UserDefaults.standard.setValue(true, forKey: "hasSentPlayerID")
            }
        }) { (err) in
            print("Player ID Didnot Updated!")
            UserDefaults.standard.setValue(false, forKey: "hasSentPlayerID")
        }
        
    }
    func checkIfTokenSent() {
        guard  let playerID = UserDefaults.standard.value(forKey: Constants.firebaseTokenKey) as? String /* , isUserLoggedIn()*/ else { return }
        sendPlayerId(playerID)
    }

    
    
    func handelNoti (id : Int) {
        var tabBar : UITabBarController?
        let navController = UINavigationController()
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        guard let window = keyWindow else {return}
        let storyb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        tabBar = storyb.instantiateViewController(withIdentifier: "rootNav") as? UITabBarController
        navController.navigationBar.isHidden = true
        tabBar?.selectedIndex = ad.isUser() ? 1 : 0
        navController.viewControllers = [tabBar!]
        if !ad.isUser(){
            let vc = WorderDetailes()
            vc.tranId = id
            navController.pushViewController(vc, animated: true)
        }else{
            let vc = OrderDetailesVC()
            vc.order_id = id
            navController.pushViewController(vc, animated: true)
        }
      
             window.rootViewController = navController
             window.makeKeyAndVisible()
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }
        if !ad.isUser() {
        let notName =  Notification.Name("didReceiveData")
         NotificationCenter.default.post(name: notName, object: nil)

        }
      // Print full message.
      print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
        if !ad.isUser() {
        let notName =  Notification.Name("didReceiveData")
         NotificationCenter.default.post(name: notName, object: nil)

        }
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
    

}

 



extension AppDelegate : MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        let dataDict: [String: String] = ["token": fcmToken ]
        NotificationCenter.default.post(
          name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
     //   guard  fcmToken != "" else { return }
         UserDefaults.standard.setValue(fcmToken, forKey: Constants.firebaseTokenKey)
        
     //   let dataDict:[String: String] = ["token": fcmToken]
        
       // NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }

    
 
}


@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)
    if ad.isUser() {
        
        
        if let vc = UIApplication.topViewController() as? OrderDetailesVC {
            
            print("ok")
            
            guard let info = userInfo as? [String:Any]else{return}
            let orderId = info["order_id"] as? String
            
            
            if let orderId = Int(orderId!) {
                vc.order_id = orderId
                vc.getOrderDetails(order_id: orderId)
            }
        }
        
        
    }else{
        
        let notName =  Notification.Name("didReceiveData")
         NotificationCenter.default.post(name: notName, object: nil)

        
        if let vc = UIApplication.topViewController() as? WorderDetailes {
                
                print("ok")
                
                guard let info = userInfo as? [String:Any]else{return}
                let orderId = info["order_id"] as? String
                
                 if let orderId = Int(orderId!) {
                    vc.tranId = orderId
                    vc.getOrderData()
                }
            }
    }
        guard let info = userInfo as? [String:Any]else{return}
        print(info)
    if let databanned = info["data"] as? String {
  
        bnannedAccount(databanned: databanned)
       
   
    }
    
                         
    // Change this to your preferred presentation option
    completionHandler([[.alert, .sound , .badge]])
  }
    
    
    func bnannedAccount (databanned:String) {
        
        if databanned == "201" {
            UserDefaults.standard.set(0, forKey: "banned")
            UIApplication.topViewController()?.showDAlert(title: "", subTitle: "accountSaspended".localized, type: .withContent, buttonTitle: "done".localized , completionHandler: { (ـ) in
                //                ad.logout()
                
                APIClient.logoutHandler(user_type : ad.user_type() , completionHandler: { (status) in
                    
                    guard status else { return }
                    DispatchQueue.main.async {
                        ad.save(userId: nil, token: nil)
                        ad.restartApplicationToLogin()
                        UserDefaults.standard.setValue(nil, forKey: Constants.firebaseTokenKey)
                    }
                }) { (err) in
                    
                    
                }
                
            })
        }
    }
 

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)

    
     guard let info = userInfo as? [String:Any]else{return}
     let orderId = info["order_id"] as? String
     
    if let id = Int(orderId ?? "") {
     
     

        handelNoti(id: id)
   
      //   self.presenttOrPush(vc: vc)
     
        
     
             
        
    }

    if let databanned = info["data"] as? String {
         
             bnannedAccount(databanned: databanned)
    }
    
    

    
    
    
    completionHandler()
  }

}
    
    








/** @abstract UIWindow hierarchy category.  */
public extension UIWindow {
    
    /** @return Returns the current Top Most ViewController in hierarchy.   */
    func topMostWindowController()->UIViewController? {
        
        var topController = rootViewController
        
        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }
        
        return topController
    }
    
    /** @return Returns the topViewController in stack of topMostWindowController.    */
    func currentViewController()->UIViewController? {
        
        var currentViewController = topMostWindowController()
        
        while currentViewController != nil && currentViewController is UINavigationController && (currentViewController as! UINavigationController).topViewController != nil {
            currentViewController = (currentViewController as! UINavigationController).topViewController
        }
        
        return currentViewController
    }
    
    
    
    
    
}





//extension AppDelegate{
//
//    func presenttOrPush(vc : UIViewController) {
//        if  UIApplication.getPresentedViewController()?.navigationController != nil {
//            UIApplication.getPresentedViewController()?.navigationController?.pushViewController(vc, animated: true)
//        }else {
//            UIApplication.getPresentedViewController()?.present(vc, animated: true, completion: nil   )
//        }
//    }
//
//}
//extension UIApplication{
//    class func getPresentedViewController() -> UIViewController? {
//        var presentViewController = UIApplication.shared.keyWindow?.rootViewController
//        while let pVC = presentViewController?.presentedViewController
//        {
//            presentViewController = pVC
//        }
//        return presentViewController
//    }
//}


    

extension UIApplication {
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
}
extension UIApplication{
    class func getPresentedViewController() -> UIViewController? {
        var presentViewController = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentViewController?.presentedViewController
        {
            presentViewController = pVC
        }
        return presentViewController
    }
}
