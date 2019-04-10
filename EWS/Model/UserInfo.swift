//
//  UserInfo.swift
//  EWS
//
//  Created by Alvin Ling on 4/9/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import Foundation

struct UserInfo {
    var fname, lname, email, dob, phone, gender : String
    var uid: String
    
    init(_ uid: String, info: [String: String]) {
        fname = info["fname"]!
        lname = info["lname"]!
        email = info["email"]!
        dob = info["dob"]!
        phone = info["phone"]!
        gender = info["gender"]!
        self.uid = uid
    }
}
