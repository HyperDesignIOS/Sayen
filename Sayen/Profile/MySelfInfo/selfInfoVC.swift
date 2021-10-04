//
//  selfInfoVC.swift
//  Sayen 
//
//  Created by Maher on 6/4/20.
//

import UIKit
import  DLRadioButton
import MobileCoreServices
import AVFoundation
import Kingfisher
import DropDown

class selfInfoVC: UIViewController {

     var tabBar : UITabBarController?
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var clint: DLRadioButton!
    @IBOutlet weak var company: DLRadioButton!
    @IBOutlet weak var client_typeLbl: UILabel!
    @IBOutlet weak var flatNameStackV: UIStackView!
    @IBOutlet weak var flatNameContainerV: CardView!
    @IBOutlet weak var flatNameTxtF: UITextField!
    @IBOutlet weak var flatNumStackV: UIStackView!
    @IBOutlet weak var flatNumTxtF: UITextField!
    
    var oldProfileImage : UIImage?
    var data: UserProfile_Data?
    fileprivate let picker = UIImagePickerController()
    fileprivate var imageDict : [String:Any] = [:]
    let dropDown = DropDown()
    var buildingData = [BuildingM]()
    var selectedData : BuildingM?
    var firstLaunch = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
       
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.borderWidth = 3
      
        if ad.isUser(){
            self.clint.alpha = 1
            self.company.alpha = 1
            client_typeLbl.alpha = 1
        }else{
            self.clint.alpha = 0
            self.company.alpha = 0
            client_typeLbl.alpha = 0
            self.flatNumStackV.isHidden = true
            self.flatNameStackV.isHidden = true
        }
    getBuildingNamesData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard !firstLaunch else { return }
         getProfileData()
    }
    
    func getBuildingNamesData() {
        
        
        getBuildingsName { (status) in
            
            guard status else {
                self.getProfileData()
                 return
            }
            self.handleDropDown()
            self.getProfileData()

        }
    }
    
    private func handleDropDown() {
        dropDown.anchorView = flatNameContainerV // UIView or UIBarButtonItem
        dropDown.direction = .bottom
        dropDown.backgroundColor = UIColor.white
        dropDown.transform = CGAffineTransform(translationX: 0, y: 50).concatenating(CGAffineTransform(scaleX: 1, y: 0.9))

        var data = [String]()
        for x in buildingData {
            data.append(x.name)
        }
        dropDown.dataSource = data
        
        
        flatNameContainerV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectFlatName)))
        
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.selectedData = self.buildingData[index]
            self.flatNameTxtF.text = item
                   }
    }
    

    @objc func selectFlatName() {
        
        dropDown.show()
    }
    func getBuildingsName(completionHandler:@escaping((Bool)->())) {
        
        
        APIClient.getBuildingsNames(completionHandler: { [weak self](rData) in
             DispatchQueue.main.async {
                self?.buildingData = rData.buildings
                completionHandler(true)
            }
            
        }) { (err) in
            
            DispatchQueue.main.async {
                completionHandler(false)
            }
            
        }
    }
    
    func getProfileData() {
       
        ad.isLoading()
        APIClient.getProfileData(user_type: ad.user_type(), completionHandler: { (state, sms, data) in
            self.firstLaunch = false
            guard state else{
                ad.killLoading()
                self.showDAlert(title: "Error".localized, subTitle: sms, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                return
            }

            DispatchQueue.main.async {
                ad.killLoading()
                if let data = data {
                    self.data = data
                    self.nameTF.text = data.name
                    self.emailTF.text = data.email
                    
                    if let url = URL(string: data.imageLink) {
                        let placeholderImage = UIImage(named: "imageProfile")!
                        self.profileImage.af_setImage(withURL: url, placeholderImage: placeholderImage)
                    }
                    
                    if ad.isUser(){
                    if data.excellence_client == "2" {
                        self.clint.isSelected = false
                        self.company.isSelected = true
                        self.flatNameStackV.isHidden = true
                        self.flatNumStackV.isHidden = true
                    }else {
                        self.company.isSelected = false
                        self.clint.isSelected = true
                        self.flatNameStackV.isHidden = false
                        self.flatNumStackV.isHidden = false
                        self.flatNumTxtF.text = data.flat
                        
                        for x in self.buildingData where data.building_id == x.id {
                            self.selectedData = x
                            self.flatNameTxtF.text = x.name
                            return
                        }
                    }
                    }



                }

            }
        })  { (err) in
            ad.killLoading()
            self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            print("errr")
        }
    }

    
 func imageTapped()
    {
        
        let actionSheet :UIAlertController = UIAlertController(title: " ",  message:  "selectImagesFrom".localized , preferredStyle: .actionSheet
            
        )
        let cancle:UIAlertAction = UIAlertAction(title:  "close".localized, style: .cancel, handler: nil)
        let photos :UIAlertAction = UIAlertAction(title:  "photos".localized, style: .default) { UIAlertAction in
            
            self.photoFromLibrary()
        }
        let camera :UIAlertAction = UIAlertAction(title: "camira".localized, style: .default) { UIAlertAction in
            
            
            self.shootPhoto()
            
        }
        actionSheet.addAction(photos)
        
        actionSheet.addAction(camera)
        
        actionSheet.addAction(cancle)
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    @IBAction func changeProImg(_ sender: Any) {
        imageTapped()
        self.picker.delegate = self
        self.picker.allowsEditing = true
    }
    

    @IBAction func vipHandler(_ sender: UIButton) {
    
  flatNameStackV.isHidden = false
  flatNumStackV.isHidden = false

    }
    
    @IBAction func normalUserHandler(_ sender: UIButton) {
   
    flatNameStackV.isHidden = true
    flatNumStackV.isHidden = true

    }
    
    @IBAction func saveInfo(_ sender: Any) {
       
        guard let name = self.nameTF.text , name != "" else{
            self.showDAlert(title: "Error".localized, subTitle: "writeName".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            return
        }
        if self.clint.isSelected  {
            guard let _ = selectedData else{
               let alertMessage = "selectBuildingName".localized
                self.showDAlert(title: "Error".localized, subTitle: alertMessage, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                return
            }
            
            guard let num = flatNumTxtF.text ,num != "" else{
                let alertMessage = "selectFlateNumber".localized
                self.showDAlert(title: "Error".localized, subTitle: alertMessage, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)

                return
            }
        }
        
        if let email = emailTF.text , email != "" {
            
            guard email.isEmail else{
                let alertMessage = "wrongEmial".localized
                self.showDAlert(title: "Error".localized, subTitle: alertMessage, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)

                return
            }
        }
        ad.isLoading()
        if ad.isUser(){
            let excellence_client = self.clint.isSelected ? "1" : "2"
            APIClient.changeInfoUser(name: self.nameTF.text!, email: self.emailTF.text!, excellence_client: excellence_client,building_id: self.selectedData?.id ?? 0,flat: self.flatNumTxtF.text ?? "", completionHandler: { (state, sms) in
                guard state else{
                    DispatchQueue.main.async {
                        ad.killLoading()
                        self.showDAlert(title: "Error".localized, subTitle: sms, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                        
                    }
                    
                    return
                }
                
                DispatchQueue.main.async {
                    ad.killLoading()
                    Constants.UserName = name
                   // self.showDAlert(title: "thanks".localized, subTitle: "infoChanged".localized, type: .success,buttonTitle: "", completionHandler: nil)
                    self.showDAlert(title: "thanks".localized, subTitle: "infoChanged".localized, type: .success,buttonTitle: "") { (_) in
                        self.goToMenu()
                    }
                }
                
            }) { (err) in
                ad.killLoading()
                self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                print("errr")
            }
        }else{
            APIClient.changeInfoTeam(name: self.nameTF.text!, email: self.emailTF.text!, completionHandler: { (state, sms) in
                guard state else{
                    DispatchQueue.main.async {
                        ad.killLoading()
                        self.showDAlert(title: "Error".localized, subTitle: sms, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                        
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    ad.killLoading()
                    self.showDAlert(title: "thanks".localized, subTitle: "infoChanged".localized, type: .success,buttonTitle: "", completionHandler: nil)
                }
            }) { (err) in
                ad.killLoading()
                self.showDAlert(title: "Error".localized, subTitle: "tryAgain".localized, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                print("errr")
            }
        }
        
    }
    func goToMenu(){
           let navController = UINavigationController()
           let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
           guard let window = keyWindow else {return}
           let storyb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
           tabBar = storyb.instantiateViewController(withIdentifier: "rootNav") as? UITabBarController
           navController.navigationBar.isHidden = true
           tabBar?.selectedIndex = 3
           navController.viewControllers = [tabBar!]
           window.rootViewController = navController
           window.makeKeyAndVisible()
           
       }

    
    @IBAction func dismiss(_ sender: Any) {
        self.dismissViewC()
    }
    
}

extension selfInfoVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate    {
    func photoFromLibrary() {
           picker.allowsEditing = false
           picker.sourceType = .photoLibrary
           picker.mediaTypes = [kUTTypeImage as String]
           picker.modalPresentationStyle = .popover
           present(picker, animated: true, completion: nil)
           
           
       }
    
    func shootPhoto() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { [weak self ](granted :Bool) -> Void in
           
            if granted == true
            {
                // User granted
                DispatchQueue.main.async {
                    self?.userCamera()
                }
            }
            else
            {
                DispatchQueue.main.async {
                    self?.view.showSimpleAlert("", "camActivactionMsg".localized, .warning)
                    let alert = UIAlertController(title: "" , message:  "camiraNotPermitted".localized, preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title:  "settings".localized, style: .default, handler: { (_) in
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.openURL(settingsURL)
                        }
                        
                        
                    }))
                    alert.addAction(UIAlertAction(title:  "close".localized, style: .cancel, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                    
                }
                return
            }
        });
        
        
    }
    
    func userCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            //            picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
            picker.mediaTypes = [kUTTypeImage as String]
            present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }
    func noCamera(){
        let alertVC = UIAlertController(
            title:  "noCamiraFound".localized,
            message:  "deviceNoCamira".localized,
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           
           
           ad.isLoading()
           var chosenImage = UIImage()
           chosenImage = info[.originalImage] as! UIImage //2
           profileImage.contentMode = .scaleAspectFill //3
           self.oldProfileImage = profileImage.image
           profileImage.image = chosenImage //4
           let myThumb  = chosenImage.resizeImageWith(newSize: CGSize(width: 200, height: 200))
           let image = myThumb
           if let data = image.jpegData(compressionQuality: 1.0) {
               print("Size: \(data.count ) bytes")
           }
           imageDict["image"] = myThumb
           imageDict["user_type"] = ad.user_type()
           APIClient.postProfileUpdate(parameters: ["user_type":ad.user_type()], imageDict: ["image": myThumb]) {[weak self] (state, sms) in
               
               guard state else {
                   DispatchQueue.main.async {
                       self?.profileImage.image = self?.oldProfileImage
                       ad.killLoading()
                       self?.showDAlert(title: "Error".localized, subTitle: sms, type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
                   }
                   return
               }
               DispatchQueue.main.async {
                   self?.profileImage.image = chosenImage
                   ad.killLoading()
//                   self?.view.showSimpleAlert(L0A.Success.stringValue(), "", .success)
               }
           }
           dismiss(animated:true, completion: nil) //5
       }
       
       
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           dismiss(animated: true, completion: nil)
           }
    

}
