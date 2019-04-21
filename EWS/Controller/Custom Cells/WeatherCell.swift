//
//  WeatherCell.swift
//  EWS
//
//  Created by Alvin Ling on 4/9/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit

class WeatherCell: UICollectionViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func set(_ data: DailyForecast) {
        if let imageName = data.icon, let image = UIImage(named: imageName) {
            icon.image = image
        }
        highLabel.text = "\(data.high!) °F"
        lowLabel.text = "\(data.low!) °F"
        dateLabel.text = data.day
    }
}
