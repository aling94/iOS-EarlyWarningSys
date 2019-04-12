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
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var clManager: CLLocationManager!
    var currentLocation: CLLocation?
    var locationName: String?
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        GMSServices.provideAPIKey(GoogleAPIKeys.maps)
        GMSPlacesClient.provideAPIKey(GoogleAPIKeys.places)
        setupCoreLocation()
        requestLocation()
        FirebaseApp.configure()
        RunLoop.current.run(until: NSDate(timeIntervalSinceNow: 2) as Date)
        checkAlreadyLoggedIn()
        return true
    }
    
    func checkAlreadyLoggedIn() {
        if let _ = FirebaseManager.shared.currentUser {
            let initialView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Tabs")
            window?.rootViewController = initialView
        }
    }
    
}

extension AppDelegate: CLLocationManagerDelegate {
    
    var hasAllowedCoreLocation: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    
    func setupCoreLocation() {
        clManager = CLLocationManager()
        clManager.delegate = self
        clManager.desiredAccuracy = kCLLocationAccuracyBest
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
        print("\n--- Your Location: \(loc) ---\n")
        currentLocation = loc
//        manager.stopUpdatingLocation()
        
        let gc = CLGeocoder()
        gc.reverseGeocodeLocation(loc) { (placemarks, error) in
            guard let place = placemarks?.last?.locality else { return }
            DispatchQueue.main.async { self.locationName = place }
            print("\n--- Your Location: \(place) ---\n")
        }
        
    }
    
}

let app = UIApplication.shared.delegate as! AppDelegate
