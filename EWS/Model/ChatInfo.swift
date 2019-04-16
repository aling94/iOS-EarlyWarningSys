//
//  ChatInfo.swift
//  EWS
//
//  Created by Alvin Ling on 4/15/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import Foundation

struct ChatInfo {
    let message: String
    let receiverID: String
    let time: TimeInterval
    
    init(info: [String : Any]) {
        message = info["message"] as! String
        receiverID = info["receiverID"] as! String
        time = info["time"] as! TimeInterval
    }
    
    static func <(left: ChatInfo, right: ChatInfo) -> Bool {
        return left.time < right.time
    }
    
    static func >(left: ChatInfo, right: ChatInfo) -> Bool {
        return left.time > right.time
    }
}
