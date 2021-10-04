//
//  String+HTML.swift
//  Theme
//
//  Created by Eslam Abo El Fetouh on 3/29/20.
//  Copyright © 2020 Eslam Abo El Fetouh. All rights reserved.
//

import Foundation
import UIKit

extension String {
    private var convertHtmlToNSAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data,options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func convertToDictionary() -> [String: Any]? {
         let text = self
         if let data = text.data(using: .utf8) {
             do {
                 return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
             } catch {
                 print(error.localizedDescription)
             }
         }
         return nil
     }
    
    public func convertHtmlToAttributedStringWithCSS(font: UIFont? , csscolor: String , lineheight: Int, csstextalign: String) -> NSAttributedString? {
        guard let font = font else {
            return convertHtmlToNSAttributedString
        }
        let modifiedString = "<style>body{font-family: '\(font.fontName)'; font-size:\(font.pointSize)px; color: \(csscolor); line-height: \(lineheight)px; text-align: \(csstextalign); }</style>\(self)";
        guard let data = modifiedString.data(using: .utf8) else {
            return nil
        }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }
        catch {
            print(error)
            return nil
        }
    }
}
