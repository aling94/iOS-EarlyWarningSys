//
//  FriendsMapVC.swift
//  EWS
//
//  Created by Alvin Ling on 4/11/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit
import GoogleMaps

class FriendsMapVC: GMSMarkerVC {
    
    var friendsList: [UserInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayFriends()
    }
    
    func displayFriends() {
        for (i, friend) in friendsList.enumerated() {
            addMarker(friend, zIndex: i)
        }

    }
    
    func addMarker(_ info: UserInfo, zIndex: Int) {
        let marker = GMSMarker()
        marker.position = info.coord
        marker.title = info.name
        let icon = info.image ?? UIImage(named: "default-user")
        let imgView = UIImageView(frame: CGRect(x: info.latitude, y: info.longitude, width: 40, height: 40))
        imgView.image = icon
        imgView.borderWidth = 2
        imgView.borderColor = .orange
        imgView.cornerRadius = imgView.frame.height / 2
        
        marker.iconView = imgView
        marker.zIndex = Int32(zIndex)
        marker.map = map
    }
}

