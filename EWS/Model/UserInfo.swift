//
//  UserInfo.swift
//  EWS
//
//  Created by Alvin Ling on 4/9/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit

final class UserInfo {
    var fname, lname, email, dob, phone, gender : String
    var latitude, longitude: Double
    var location: String
    var uid: String
    var image: UIImage?
    
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
}
