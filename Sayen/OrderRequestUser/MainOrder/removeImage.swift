//
//  removeImage.swift
//  Sayen 
//
//  Created by Maher on 7/8/20.
//

import UIKit

class removeImage: UIViewController {
    
   var delegate : RemoveImagePro!
    var i : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    @IBAction func yesAction(_ sender: Any) {
        self.dismissViewC()
        delegate.removeImageFunc(i: self.i)
        
    }
    
    @IBAction func noAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    
}


protocol RemoveImagePro : class{
    func removeImageFunc (i : Int)
}
