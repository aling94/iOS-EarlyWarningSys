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
    }
    
    func displayEarthQuakes(_ earthquakes: [Earthquake]) {
        let icon = UIImage.animatedMarker
        
        let markers: [GMSMarker] = earthquakes.map { eq in
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: eq.lat!, longitude: eq.long!)
            marker.title = eq.place!
            marker.icon = icon
            marker.map = gmap
            return marker
        }
        gmap.camera = GMSCameraPosition(target: markers[0].position, zoom: 5)
    }

}
