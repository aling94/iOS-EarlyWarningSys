//
//  Conversation.swift
//  EWS
//
//  Created by Alvin Ling on 4/15/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import Foundation

struct Conversation {
    let message: String
    let receiverID: String
    let time: TimeInterval
    
    init(info: [String : Any]) {
        message = info["message"] as! String
        receiverID = info["receiverID"] as! String
        time = info["time"] as! TimeInterval
    }
}
