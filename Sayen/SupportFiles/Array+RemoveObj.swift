//
//  Array+RemoveObj.swift
//  Theme
//
//  Created by Eslam Abo El Fetouh on 3/26/20.
//  Copyright © 2020 Eslam Abo El Fetouh. All rights reserved.
//

import Foundation
import UIKit


 extension Array where Element: Equatable {

    // Remove first collection element that is equal to the given `object`:
    mutating func remove(object: Element) {
        guard let index = firstIndex(of: object) else {return}
        remove(at: index)
    }

}
