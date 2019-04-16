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
    var fname, lname, email, dob, phone, gender : String
    var latitude, longitude: Double
    var location: String
    var uid: String
    var image: UIImage?
    
    var name: String { return "\(fname) \(lname)"}
    
    var coords: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(_ uid: String, info: [String: Any]) {
        fname = info["fname"] as! String
        lname = info["lname"] as! String
        email = info["email"] as! String
        dob = info["dob"] as! String
        phone = info["phone"] as! String
        gender = info["gender"] as! String
        location = info["location"] as! String
        latitude = info["latitude"] as! Double
        longitude = info["longitude"] as! Double
        self.uid = uid
    }
    
    init(authInfo: AuthDataResult) {
        let user = authInfo.user
        email = user.email ?? ""
        phone = user.phoneNumber ?? ""
        uid = user.uid
        fname = user.displayName ?? ""
        dob = ""
        lname = ""
        gender = "MALE"
        location = ""
        latitude = 0
        longitude = 0
    }
    
    static func userDict(authInfo: AuthDataResult) -> [String : Any] {
        let user = authInfo.user
        return [
            "uid": user.uid,
            "email": user.email ?? "",
            "phone": user.phoneNumber ?? "",
            "fname": user.displayName ?? "",
            "lname": "",
            "dob": "",
            "gender": "MALE",
            "location": "",
            "latitude": 0,
            "longitude": 0
        ]
    }
    
    static func <(left: UserInfo, right: UserInfo) -> Bool {
        return left.fname < right.fname
    }
}
