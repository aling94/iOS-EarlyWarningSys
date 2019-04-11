//
//  EQMapVC.swift
//  EWS
//
//  Created by Alvin Ling on 4/10/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit
import GoogleMaps

class EQMapVC: UIViewController {
    
    @IBOutlet weak var gmap: GMSMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        setupGMsp()
        fetchEQData()
    }
    
    func fetchEQData() {
        APIHandler.shared.fetchEQData { (earthquakes) in
            guard let earthquakes = earthquakes else { return }
            DispatchQueue.main.async {
                self.displayEarthQuakes(earthquakes)
            }
        }
    }
    
    func setupGMsp() {
        gmap.mapType = .hybrid
        guard let myLoc = app.currentLocation?.coordinate else { return }
        let coord = CLLocationCoordinate2D(latitude: myLoc.latitude, longitude: myLoc.longitude)
        addMaker(coord, title: "Me")
        gmap.camera = GMSCameraPosition(target: coord, zoom: gmap.minZoom)
    }
    
    func displayEarthQuakes(_ earthquakes: [Earthquake]) {
        let icon = UIImage.animatedMarker
        
        for eq in earthquakes {
            let coord = CLLocationCoordinate2D(latitude: eq.lat!, longitude: eq.long!)
            addMaker(coord, title: eq.place!, icon: icon)
        }
    }
    
    func addMaker(_ coords: CLLocationCoordinate2D, title: String = "", icon: UIImage? = nil) {
        let marker = GMSMarker()
        marker.position = coords
        marker.title = title
        if let icon = icon { marker.icon = icon }
        marker.map = gmap
    }

}
