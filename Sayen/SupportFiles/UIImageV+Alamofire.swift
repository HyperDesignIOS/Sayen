//
//  UIImageV+Alamofire.swift
//  Sreer
//
//  Created by admin on 4/8/19.
//  Copyright © 2019 emad ios. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
 
extension UIImageView {
    
  
   
    func getApiImage(imagePath : String,contentMode :  UIView.ContentMode? = .scaleAspectFill ) {
        guard let url = URL(string: imagePath ) else { return }
        self.contentMode = contentMode ?? .scaleAspectFill
        self.af_setImage(
            withURL: url ,
            placeholderImage: #imageLiteral(resourceName: "Csm-app-theme-01-concept02-1"),
            filter: nil,
            imageTransition: .crossDissolve(0.2)
        )
    }
    func getApiImage(imagePath : String,placeHolderImg: UIImage) {
        guard let url = URL(string: imagePath ) else { return }
        self.af_setImage(
            withURL: url ,
            placeholderImage: placeHolderImg,
            filter: nil,
            imageTransition: .crossDissolve(0.2)
        )
    }
}



struct ImageHeaderData {
    static var PNG: [UInt8] = [0x89]
    static var JPEG: [UInt8] = [0xFF]
    static var GIF: [UInt8] = [0x47]
    static var TIFF_01: [UInt8] = [0x49]
    static var TIFF_02: [UInt8] = [0x4D]
}
enum ImageFormat {
    case Unknown, PNG, JPEG, GIF, TIFF
}
extension Data {
    var imageFormat: ImageFormat {
        var buffer = [UInt8](repeating: 0, count: 1)
        copyBytes(to: &buffer, from: 0..<1)
        if buffer == ImageHeaderData.PNG { return .PNG }
        if buffer == ImageHeaderData.JPEG { return .JPEG }
        if buffer == ImageHeaderData.GIF { return .GIF }
        if buffer == ImageHeaderData.TIFF_01 ||
            buffer == ImageHeaderData.TIFF_02 {
            return .TIFF
        }
        return .Unknown
    }
}
