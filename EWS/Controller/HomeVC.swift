//
//  HomeVC.swift
//  EWS
//
//  Created by Alvin Ling on 4/9/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    
    var weatherData: DarkSkyResponse? {
        didSet {
            DispatchQueue.main.async {
                self.collection.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWeatherData()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func fetchWeatherData() {
        let app = UIApplication.shared.delegate as! AppDelegate
        let loc = app.currentLocation.coordinate
        
        APIHandler.shared.fetchWeatherData(loc.latitude, loc.longitude) { (response) in
            guard let data = response else { return }
            self.weatherData = data
        }
    }
}

extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherData?.daily?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        setCell(cell, indexPath: indexPath)
        return cell
    }
    
    func setCell(_ cell: WeatherCell, indexPath: IndexPath) {
        let data = (weatherData?.daily?[indexPath.item])!
        cell.highLabel.text = "H: \(data.high!) F"
        cell.lowLabel.text = "L: \(data.low!) F"
        cell.locLabel.text = (UIApplication.shared.delegate as! AppDelegate).locationName
    }
}
