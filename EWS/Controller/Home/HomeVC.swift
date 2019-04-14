//
//  HomeVC.swift
//  EWS
//
//  Created by Alvin Ling on 4/9/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit
import GooglePlaces

class HomeVC: UIViewController {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    var myLocation: CLLocationCoordinate2D?
    
    var weatherData: WeatherResponse? {
        didSet {
            DispatchQueue.main.async {
                self.collection.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let loc = app.currentLocation?.coordinate {
            myLocation = loc
            fetchWeatherData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupUserData()
        if myLocation == nil, let loc = app.currentLocation?.coordinate {
            myLocation = loc
            fetchWeatherData()
        }
    }
    
    func fetchWeatherData() {
        guard let loc = myLocation else { return }
        
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
        if let iconName = data.currently?.icon { weatherIcon.image = UIImage(named: iconName) }
        dateLabel.text = "\(data.date!)"
        highLabel.text = "\(data.high!) °F"
        lowLabel.text = "\(data.low!) °F"
        let summ = (data.currently?.summary)!
        summaryLabel.text = "Today expect...\n\n\(summ)"
    }
    
    func setupUserData() {
        guard let currentUser = FirebaseManager.shared.currentUser else { return }
        emailLabel.text = currentUser.email
        FirebaseManager.shared.getCurrentUserInfo { (userInfo) in
            if let  loc = userInfo?.coords, self.myLocation == nil {
                self.myLocation = loc
                self.fetchWeatherData()
            }
            DispatchQueue.main.async {
                if let pic = userInfo?.image { self.userImage.image = pic }
            }
        }        
    }
    
    @IBAction func searchPlaces(_ sender: Any) {
        displayPlacesController()
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

extension HomeVC: GMSAutocompleteViewControllerDelegate {
    
    func displayPlacesController() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.coordinate.rawValue))!
        autocompleteController.placeFields = fields
        
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        autocompleteController.autocompleteFilter = filter
        
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        myLocation = place.coordinate
        fetchWeatherData()
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
