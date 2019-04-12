//
//  GMSMarkerVC.swift
//  EWS
//
//  Created by Alvin Ling on 4/12/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit
import GoogleMaps

class GMSMarkerVC: UIViewController {
    
    @IBOutlet weak var map: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navbarIsHidden = false
        setupMap()
    }
 
    func setupMap() {
        map.mapType = .hybrid
        guard let myLoc = app.currentLocation?.coordinate else { return }
        let coord = CLLocationCoordinate2D(latitude: myLoc.latitude, longitude: myLoc.longitude)
        let marker = GMSMarker()
        marker.position = coord
        marker.title = "Me"
        if let icon = FirebaseManager.shared.currentUserInfo?.image {
            marker.iconView = UIImageView(image: icon.imageWith(side: 50))
            marker.iconView?.cornerRadius = 25
            marker.iconView?.borderWidth = 3
            marker.iconView?.borderColor = .white
        }
        marker.map = map
        map.camera = GMSCameraPosition(target: coord, zoom: map.minZoom)
    }
}
