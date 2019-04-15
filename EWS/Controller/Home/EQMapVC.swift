//
//  EQMapVC.swift
//  EWS
//
//  Created by Alvin Ling on 4/10/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit
import GoogleMaps

class EQMapVC: GMSMarkerVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        displayEarthquakes()
        title = "Earthquakes"
    }

    func displayEarthquakes() {
        let icon = UIImage.animatedMarker!
        APIHandler.shared.fetchEQData { (earthquakes) in
            guard let earthquakes = earthquakes else { return }
            DispatchQueue.main.async {
                for eq in earthquakes { self.addMaker(eq, icon: icon) }
            }
        }

    }
    
    func addMaker(_ eq: Earthquake, icon: UIImage) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: eq.lat!, longitude: eq.long!)
        marker.title = eq.place!
        marker.icon = icon
        marker.map = map
    }

}
