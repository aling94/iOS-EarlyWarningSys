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
import GoogleSignIn
import FBSDKCoreKit

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
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        FBSDKApplicationDelegate.sharedInstance()?.application(application, didFinishLaunchingWithOptions: launchOptions)
        checkAlreadyLoggedIn()
        return true
    }
    
    func checkAlreadyLoggedIn() {
        if let _ = FirebaseManager.shared.currentUser {
            let initialView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Tabs")
            window?.rootViewController = initialView
        }
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            let sourceApp = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
            let gidHandled = GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApp, annotation: [:])
            let fbHandled = FBSDKApplicationDelegate.sharedInstance()?.application(application, open: url, sourceApplication: sourceApp, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
            
            return gidHandled || fbHandled!
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
            let info: [String : Any] = [
                "latitude": loc.coordinate.latitude,
                "longitude": loc.coordinate.longitude,
                "location": place
            ]
            FirebaseManager.shared.updateCurrentUserInfo(info)
        }
        
    }
    
}

let app = UIApplication.shared.delegate as! AppDelegate
