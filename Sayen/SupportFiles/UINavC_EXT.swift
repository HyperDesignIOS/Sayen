//
//  UINavC_EXT.swift
//  Theme
//
//  Created by Eslam Abo El Fetouh on 3/20/20.
//  Copyright © 2020 Eslam Abo El Fetouh. All rights reserved.
//

import Foundation
import UIKit


extension UINavigationController {
    var rootViewController : UIViewController? {
        return viewControllers.first
    }
  

        func setStatusBar(backgroundColor: UIColor) {
            let statusBarFrame: CGRect
            if #available(iOS 13.0, *) {
                statusBarFrame = view.window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero
            } else {
                statusBarFrame = UIApplication.shared.statusBarFrame
            }
            let statusBarView = UIView(frame: statusBarFrame)
            statusBarView.backgroundColor = backgroundColor
            view.addSubview(statusBarView)
        }



}
