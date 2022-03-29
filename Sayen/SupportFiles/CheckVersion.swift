//
//  CheckVersion.swift
//  Sayen 
//
//  Created by ME-MAC on 3/21/22.
//


import Alamofire

class VersionCheck {
  
  public static let shared = VersionCheck()
  
    func isUpdateAvailable(callback: @escaping (Bool)->Void){}
//    {
//    let bundleId = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
//    Alamofire.request("https://itunes.apple.com/lookup?bundleId=\(bundleId)").responseJSON { response in
//      if let json = response.result.value as? NSDictionary,
//         let results = json["results"] as? NSArray,
//         let entry = results.firstObject as? NSDictionary,
//         let versionStore = entry["version"] as? String,
//         let versionLocal = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
//       
//        {
//        let arrayStore = versionStore.split(separator: ".").compactMap { Int($0) }
//        let arrayLocal = versionLocal.split(separator: ".").compactMap { Int($0) }
//
//        if arrayLocal.count != arrayStore.count {
//          callback(true) // different versioning system
//          return
//        }
//
//        // check each segment of the version
//        for (localSegment, storeSegment) in zip(arrayLocal, arrayStore) {
//          if localSegment < storeSegment {
//            callback(true)
//            return
//          }
//        }
//      }
//      callback(false) // no new version or failed to fetch app store version
//    }
//  }
  
}
