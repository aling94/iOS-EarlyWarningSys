//
//  WeatherInfoView.swift
//  EWS
//
//  Created by Alvin Ling on 4/21/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit

class WeatherInfoView: UIView {

    @IBOutlet weak var weatherIcon: UIImageView?
    @IBOutlet weak var dateLabel: UILabel?
    @IBOutlet weak var highLabel: UILabel?
    @IBOutlet weak var lowLabel: UILabel?
    @IBOutlet weak var summaryLabel: UILabel?
    
    func set(data: WeatherResponse) {
        if let icon = weatherIcon, let iconName = data.currently?.icon { icon.image = UIImage(named: iconName) }
        if let summLabel = summaryLabel, let summ = data.currently?.summary {
            summLabel.text = summ
        }
        dateLabel?.text = "\(data.date!)"
        highLabel?.text = "\(data.high!) °F"
        lowLabel?.text = "\(data.low!) °F"
        
    }

}
