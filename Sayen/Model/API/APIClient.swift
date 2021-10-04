//
//  APIClient.swift
//  Eyas
//
//  Created by emad ios on 12/12/18.
//  Copyright © 2018 emad ios. All rights reserved.
//

import Alamofire
//import PromisedFuture
import SwiftyJSON

class APIClient {
    
    
 
    @discardableResult
    static func performSwiftyRequest(route:APIRouter, headers: HTTPHeaders? = nil,  _ completion:@escaping (JSON)->Void,_ failure:@escaping (Error?)->Void) -> DataRequest {
        
        if  headers != nil ,let url = route.requestURL{
            return Alamofire.request(url, method: route.method, parameters: route.parameters, encoding: URLEncoding.queryString, headers: headers).responseJSON(completionHandler: { (response) in
                //                print(String.init(data: response.data!, encoding: .utf8) )
                switch response.result {
                case .success :
                    guard let _ = response.result.value else {
                        failure(response.result.error)
                        return
                    }
                    print(response.result , route.urlRequest)
                    let json = JSON(response.result.value)
                    print(json)
                    if let status_code = json["error"].string {
                        print(status_code)
                        completion(json)
                    }else {
                        completion(json)
                    }
                case .failure(let error):
                    failure(response.result.error)
                    guard ad.isOnline() else{ return }
                }
            })
            
        }else {
            return Alamofire.request(route)
                .responseJSON(completionHandler: { (response) in
                    //                print(String.init(data: response.data!, encoding: .utf8) )
                    switch response.result {
                    case .success :
                        guard let _ = response.result.value else {
                            failure(response.result.error)
                            return
                        }
                        print(response.result , route.urlRequest)
                        let json = JSON(response.result.value)
                        print(json)
                        if let status_code = json["error"].string {
                            print(status_code)
                            completion(json)
                        }else {
                            completion(json)
                        }
                    case .failure(let error):
                        
                        failure(response.result.error)
                        guard ad.isOnline() else{ return }
                    }
                })
        }
    }
    
    
    static  func cancelAllRequests(completed : @escaping ()->() ) {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach { $0.cancel() }
            uploadData.forEach { $0.cancel() }
            downloadData.forEach { $0.cancel() }
            completed()
        }
    }
   static let longSessionManager : SessionManager = {
        let con = URLSessionConfiguration.default
        con.timeoutIntervalForResource = TimeInterval(60)
        con.timeoutIntervalForRequest = TimeInterval(60)
        return  Alamofire.SessionManager(configuration: con)
    }()
     
}


enum CONSULATATION_DATA_TYPE {
    case wait , active , finished, canceled
    // wait == new at user
}
