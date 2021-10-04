//
//  SelectLanguageVC.swift
//  Sayen 
//
//  Created by Awab's Mac on 9/2/21.
//

import UIKit
import MOLH
class SelectLanguageVC: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func selectEnglishLang(){
        Constants.current_Language = "en"
        MOLH.setLanguageTo("en")
        ad.restartApplicationToLogin()
    }
    
    @IBAction func selectArabicLang(){
        Constants.current_Language = "ar"
        MOLH.setLanguageTo("ar")
        ad.restartApplicationToLogin()
    }
}
