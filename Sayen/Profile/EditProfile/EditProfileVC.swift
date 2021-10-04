//
//  EditProfileVC.swift
//  Sayen 
//
//  Created by Maher on 6/4/20.
//

import UIKit

class EditProfileVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel = EditProfileVM()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        
        let tabBar = self.tabBarController as! TabBarController
        tabBar.hideTab()
       

        self.tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
       
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navigationController = self.navigationController{
            navigationController.setStatusBar(backgroundColor: UIColor.backgroundMainColor)
        }
    }

    @IBAction func dismiss(_ sender: Any) {
        
       
       let tabBar = self.tabBarController as! TabBarController
        self.dismissViewC()
        tabBar.showTab()
      
    }
    
}


extension EditProfileVC : UITableViewDataSource , UITableViewDelegate {


        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.data.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
            let data = viewModel.data[indexPath.row].getData()
            if indexPath.row == 2 {
                cell.sepratorV.alpha = 0
            }
            cell.cellImage.image = data.image
            cell.cellLbl.text =  data.title
            cell.cellLbl.textColor = .mainColor
            
            return cell
        }
    
        
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let data = viewModel.data[indexPath.row]
            
            switch data {
            case .editMyInfo :
                let vc = selfInfoVC()
                self.navigationController?.pushViewController(vc, animated: true)
            case .editPhone :
                let vc = EditPhoneVC()
                self.navigationController?.pushViewController(vc, animated: true)
            case .changePass :
                let vc = ChangePassVC()
                self.navigationController?.pushViewController(vc, animated: true)
         
            }
        }
        
        
        

}
