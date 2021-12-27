//
//  HomeWorker+LocationManager.swift
//  Sayen  Worker
//
//  Created by ME-MAC on 12/26/21.
//

import UIKit
import CoreLocation

extension HomeWorkerVC : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        
        locationManager.stopUpdatingLocation()
        //        if ((error) != nil)
        //        {
        print("\(error)")
        //        }
    }
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coord = locationObj.coordinate
        self.lat = (coord.latitude)
        self.lng = (coord.longitude)
        print(coord.latitude)
        print(coord.longitude)
        locationManager.stopUpdatingLocation()

        if !didUpdateLocation {
            didUpdateLocation = true
             updateTeamLocation()
        }
     }

    
    private func updateTeamLocation() {
        
        guard lat != 0 , lng != 0 else { return }

        APIClient.updateLocation(lat: lat, lng: lng, completionHandler: { (status, sms) in
            
            
            
        }) { (err) in
            
            
            
        }
        
    }
}
