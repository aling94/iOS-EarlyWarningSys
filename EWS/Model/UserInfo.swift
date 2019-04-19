//
//  UserInfo.swift
//  EWS
//
//  Created by Alvin Ling on 4/9/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseAuth

final class UserInfo {
    var uid: String
    var fname, lname, email, dob, phone, gender : String?
    var latitude, longitude: Double?
    var location: String?
    var image: UIImage?
    
    var name: String {
        let result = "\(fname ?? "") \(lname ?? "")"
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var coords: CLLocationCoordinate2D? {
        if let lat = latitude, let lon = longitude {
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
        return nil
        
    }
    
    init(_ uid: String) {
        self.uid = uid
    }
    
    init(_ uid: String, info: [String: Any]) {
        self.uid = uid
        fname = info["fname"] as? String
        lname = info["lname"] as? String
        email = info["email"] as? String
        dob = info["dob"] as? String
        gender = info["gender"] as? String
        phone = info["phone"] as? String
        location = info["location"] as? String
        latitude = info["latitude"] as? Double
        longitude = info["longitude"] as? Double
    }
    
    func update(with info: [String : Any]) {
        if let fname = info["fname"] as? String, !fname.isEmpty { self.fname = fname }
        if let lname = info["lname"] as? String, !lname.isEmpty { self.lname = lname}
        if let  email = info["email"] as? String, !email.isEmpty { self.email = email}
        if let dob = info["dob"] as? String, !dob.isEmpty { self.dob = dob }
        if let gender = info["gender"] as? String, !gender.isEmpty { self.gender = gender }
        if let phone = info["phone"] as? String, !phone.isEmpty { self.phone = phone }
        if let location = info["location"] as? String, !location.isEmpty { self.location = location }
        if let latitude = info["latitude"] as? Double { self.latitude = latitude }
        if let longitude = info["longitude"] as? Double { self.longitude = longitude }
    }
    
    
    static func userDict(authInfo: AuthDataResult) -> [String : Any] {
        let user = authInfo.user
        return [
            "uid": user.uid,
            "email": user.email ?? "",
            "phone": user.phoneNumber ?? "",
            "fname": user.displayName ?? "",
        ]
    }
    
    static func <(left: UserInfo, right: UserInfo) -> Bool {
        return (left.fname ?? "") < (right.fname ?? "")
    }
}
