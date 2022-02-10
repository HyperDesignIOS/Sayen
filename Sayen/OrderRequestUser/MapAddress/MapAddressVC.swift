//
//  MapAddressVC.swift
//  Sayen 
//
//  Created by Maher on 6/9/20.
//

import UIKit
import GoogleMaps
import MOLH

class MapAddressVC: UIViewController {
    
    @IBOutlet weak var currentOutl: UIButtonX!
    @IBOutlet weak var detailesAddress: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var zoomLevel: Float = 15.0
    let marker = GMSMarker()
    weak var delegate : sendAddress!
    var addressDetailes = ""
    var lat : Double = 0.0
    var long : Double = 0.0
    var floor = ""
    var address = ""
    
    var latTran : Double = 0.0
    var longTran : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        UserDefaults.standard.set(["ar"], forKey: "AppleLanguages")
        
        self.currentOutl.semanticContentAttribute = .forceRightToLeft
        setupGoogleLocation()
        setStyleMap()
        //    checkLocation()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let camera = GMSCameraPosition.camera(withLatitude: latTran ,longitude: longTran , zoom: zoomLevel)
        self.mapView.animate(to: camera)
        if address != "" {
            self.addressTextField.text =  address
        }
        if floor != "" {
            self.detailesAddress.text = floor
        }
    }
    
    
    func setStyleMap() {
        mapView.layer.cornerRadius = 12
        
        // shadow
        mapView.layer.shadowColor = UIColor.lightGray.cgColor
        mapView.layer.shadowOffset = CGSize(width: 1, height: 1)
        mapView.layer.shadowOpacity = 0.5
        mapView.layer.shadowRadius = 3
        mapView.layer.shadowPath = UIBezierPath(roundedRect: mapView.bounds, cornerRadius: 15).cgPath
        mapView.layer.shouldRasterize = true
        mapView.layer.rasterizationScale = UIScreen.main.scale
        
    }
    
    func setupGoogleLocation() {
        mapView.isMyLocationEnabled = true
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        mapView.delegate = self

//        guard let lat = self.mapView.myLocation?.coordinate.latitude,
//              let lng = self.mapView.myLocation?.coordinate.longitude else { return }
//
//        let camera = GMSCameraPosition.camera(withLatitude: lat ,longitude: lng , zoom: zoomLevel)
//        self.mapView.animate(to: camera)
        
    }
    
    func checkLocation(){
//        if !CLLocationManager.locationServicesEnabled() {
        self.showDAlert(title: "Error".localized, subTitle: "disabledLocationService".localized, type: .error, buttonTitle: "openLocationService".localized) { (_) in
                
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)")
                    })
                }
        //    }
            
        }
                    
    }
    
    func showMarker(position: CLLocationCoordinate2D){
        marker.position = position
        marker.icon = UIImage(named: "placeholder-filled-point (1)")
        marker.isDraggable=true
        marker.map = mapView
    }
    
    func getAddressFromLatLon(_ lat : Double , _ long : Double , completed : @escaping (String)->()) {
        DispatchQueue.main.async {
            ad.isLoading()
        }
        
        let geoCoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude:lat, longitude: long)
        let locale = Locale(identifier: "ar")
        geoCoder.reverseGeocodeLocation(loc, preferredLocale: locale ,completionHandler: { [weak self ] (placemarks, error) -> Void in
            
            guard let placeMark = placemarks?.first else {
                return
            }
            
            
            var addressString : String = ""
            
            
            
            if let subThoroughfare = placeMark.subThoroughfare{
                print(subThoroughfare, terminator: "")
                addressString = addressString + subThoroughfare + ","
            }
            if let thoroughfare = placeMark.thoroughfare{
                print(thoroughfare, terminator: "")
                addressString = addressString + thoroughfare + ","
            }
            
            
            if let locality = placeMark.locality{
                print(locality, terminator: "")
                addressString = addressString + locality + ","
            }
            if let locality = placeMark.administrativeArea{
                print(locality, terminator: "")
                addressString = addressString + locality + ","
            }
            if let country = placeMark.country{
                print(country, terminator: "")
                addressString = addressString + country + ","
            }
            
            
            DispatchQueue.main.async {
                ad.killLoading()
//                self?.floorTextField.text = addressString
                self?.addressDetailes = addressString
                self?.lat = lat
                self?.long = long
            }
            completed(addressString)
        })
        
    }
    
    @IBAction func getCurrentLocation(_ sender: Any) {
         guard let lat = self.mapView.myLocation?.coordinate.latitude,
                let lng = self.mapView.myLocation?.coordinate.longitude else { return }
          let camera = GMSCameraPosition.camera(withLatitude: lat ,longitude: lng , zoom: zoomLevel)
          self.mapView.animate(to: camera)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismissViewC()
    }
    @IBAction func saveAddress(_ sender: Any) {
        view.endEditing(true)
        if self.detailesAddress.text == "" ||  self.addressTextField.text == "" {
        
            var sms = ""
            if self.detailesAddress.text == "" {
                sms = "enterFloorNum".localized
            }else{
                sms = "enterAddress".localized
            }
            self.showDAlert(title: "Error".localized, subTitle: sms , type: .error,buttonTitle: "tryAgain".localized, completionHandler: nil)
            return
        }
        print(self.lat , self.long)
        self.delegate.sendAddress(address: self.addressTextField.text!, lat: self.lat, long: self.long, floor: self.detailesAddress.text ?? "")
        self.dismissViewC()
  
    }
    
}



extension MapAddressVC: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        marker.position = coordinate
        print("didTapAt")
        let lat = marker.position.latitude
        let long = marker.position.longitude
        getAddressFromLatLon(lat, long) { (address) in

            print("thats the address  \(address)")
        }
    }
    //MARK - GMSMarker Dragging
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        print("didBeginDragging")
    }
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("didDrag")
    }
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("didEndDragging")
        //        print("current lat and long :\(marker.position.latitude)_ \(marker.position.longitude)")
        let lat = marker.position.latitude
        let long = marker.position.longitude
        getAddressFromLatLon(lat, long) { (address) in

            print("thats the address  \(address)")
        }
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
//        print("🛂idleAt position🛂")
        let lat = marker.position.latitude
        let long = marker.position.longitude
        getAddressFromLatLon(lat, long) { (address) in

            print("thats the address  \(address)")
        }
    }
    // Camera change Position this methods will call every time
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        var destinationLocation = CLLocation()
        //        if self.mapView == true
        //        {
//        print("🚸 mapView: GMSMapView, didChange🚸")
        destinationLocation = CLLocation(latitude: position.target.latitude,  longitude: position.target.longitude)
        //            destinationCoordinate = destinationLocation.coordinate
        showMarker(position: destinationLocation.coordinate)
        //        }
    }
    /* handles Info Window tap */
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("didTapInfoWindowOf")
    }
    
    /* handles Info Window long press */
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("didLongPressInfoWindowOf")
    }
    
    /* set a custom Info Window */
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 70))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6
        
        let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
        lbl1.text = self.addressTextField.text
        view.addSubview(lbl1)
        
      
        
        return view
    }
}


extension MapAddressVC : CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        if self.latTran == 0.0 {
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
      
        
           self.showMarker(position: camera.target)
      
           mapView.camera = camera
       
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted  :
             checkLocation()
            print("Location access was restricted.")

        case .denied  :
             checkLocation()
             print("Location access was restricted.")
        case .notDetermined:
           //    checkLocation()
            print("Location access was restricted.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}


protocol sendAddress : class{
    func sendAddress (address : String , lat : Double , long : Double , floor : String)
}
