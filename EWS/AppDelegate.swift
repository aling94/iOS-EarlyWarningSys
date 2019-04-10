//
//  AppDelegate.swift
//  EWS
//
//  Created by Alvin Ling on 4/8/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var clManager: CLLocationManager!
    var currentLocation: CLLocation?
    var locationName: String?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupCoreLocation()
        requestLocation()
        
        FirebaseApp.configure()
        FirebaseManager.shared.signoutUser()
        return true
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    
    var hasAllowedCoreLocation: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    
    func setupCoreLocation() {
        clManager = CLLocationManager()
        clManager.delegate = self
    }
    
    func requestLocation() {
        clManager.requestWhenInUseAuthorization()
        if hasAllowedCoreLocation {
            clManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = manager.location else { return }
        print("-- Your Location: \(loc) --")
        currentLocation = loc
        manager.stopUpdatingLocation()
        
        let gc = CLGeocoder()
        gc.reverseGeocodeLocation(loc) { (placemarks, error) in
            guard let place = placemarks?.last?.locality else { return }
            self.locationName = place
            print("-- Your Location: \(place) --")
        }
        
    }
    
}

let app = UIApplication.shared.delegate as! AppDelegate
