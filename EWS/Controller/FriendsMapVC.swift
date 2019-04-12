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
        for (i, friend) in friendsList.enumerated() { addMarker(friend, zIndex: i) }
    }
    
    func addMarker(_ info: UserInfo, zIndex: Int) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: info.latitude, longitude: info.longitude)
        marker.title = info.name
        let icon = info.image ?? UIImage(named: "default-user")
        marker.iconView = UIImageView(image: icon?.imageWith(side: 50))
        marker.iconView?.cornerRadius = 25
        marker.zIndex = Int32(zIndex)
        marker.map = map
    }
}
