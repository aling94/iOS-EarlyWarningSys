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
    var selectedMarker : GMSMarker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navbarIsHidden = false
        setupMap()
    }
 
    func setupMap() {
        map.mapType = .hybrid
        map.delegate = self
        guard let myLoc = app.currentLocation?.coordinate else { return }
        let marker = GMSMarker()
        marker.position = myLoc
        marker.title = "Me"
        if let icon = FirebaseManager.shared.currentUserInfo?.image {
            let imageV = UIImageView(frame: CGRect(x: myLoc.latitude, y: myLoc.longitude, width: 40, height: 40))
            imageV.image = icon
            imageV.cornerRadius = imageV.frame.height / 2
            imageV.borderWidth = 3
            imageV.borderColor = .white
            marker.iconView = imageV
        }
        marker.map = map
        map.camera = GMSCameraPosition(target: myLoc, zoom: map.minZoom)
    }
}

extension GMSMarkerVC : GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if let marker = selectedMarker {
            marker.iconView?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            marker.iconView?.cornerRadius = marker.iconView!.frame.height / 2
        }
        
        if let imageView = marker.iconView as? UIImageView{
            selectedMarker = marker
            imageView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            imageView.cornerRadius = imageView.frame.height / 2
            self.map.camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: 13)
            
        }
        return true
    }
}
