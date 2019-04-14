//
//  PostInfo.swift
//  EWS
//
//  Created by Alvin Ling on 4/12/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit

final class PostInfo {
    var description: String
    var likeCount: Int
    var pid: String
    var uid: String
    var timestamp: Double
    var user: UserInfo?
    var image: UIImage?
    
    
    init(_ pid: String, info: [String : Any]) {
        self.pid = pid
        description = info["description"] as! String
        likeCount = (info["likeCount"] as? Int) ?? 0
        uid = info["uid"] as! String
        timestamp = info["timestamp"] as! Double
    }
    
    static func <(left: PostInfo, right: PostInfo) -> Bool {
        return left.timestamp < right.timestamp
    }
}
