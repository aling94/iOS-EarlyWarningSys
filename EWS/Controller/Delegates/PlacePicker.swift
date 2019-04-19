//
//  PlacePicker.swift
//  EWS
//
//  Created by Alvin Ling on 4/19/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import GooglePlaces

class GMSPlacePicker: GMSAutocompleteViewController, GMSAutocompleteViewControllerDelegate {
    
    var selectPlaceAction: ((GMSPlace) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        placeFields = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.coordinate.rawValue))!
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        autocompleteFilter = filter
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        selectPlaceAction?(place)
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
