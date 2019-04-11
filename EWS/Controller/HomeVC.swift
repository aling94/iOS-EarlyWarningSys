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
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    var weatherData: WeatherResponse? {
        didSet {
            DispatchQueue.main.async {
                self.collection.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavBarClear()
        navigationController?.navigationBar.tintColor = .white
        fetchWeatherData()
        setupUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        if weatherData == nil {
            fetchWeatherData()
        }
    }
    
    func fetchWeatherData() {
        guard let loc = app.currentLocation?.coordinate else { return }
        
        APIHandler.shared.fetchWeatherData(loc.latitude, loc.longitude) { (response) in
            guard let data = response else { return }
            self.weatherData = data
            DispatchQueue.main.async {
                self.setWeatherInfo()
            }
        }
    }
    
    func setWeatherInfo() {
        let data = weatherData!
        weatherIcon.image = UIImage(named: (data.currently?.icon)!)
        dateLabel.text = "\(data.date!)"
        highLabel.text = "\(data.high!) °F"
        lowLabel.text = "\(data.low!) °F"
        let summ = (data.currently?.summary)!
        summaryLabel.text = "Today expect...\n\n\(summ)"
    }
    
    func setupUserData() {
        emailLabel.text = FirebaseManager.shared.currentUser?.email
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
        cell.icon.image = UIImage(named: data.icon!)
        cell.highLabel.text = "\(data.high!) °F"
        cell.lowLabel.text = "\(data.low!) °F"
        cell.dateLabel.text = data.day
    }
}
