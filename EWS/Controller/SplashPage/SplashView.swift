//
//  SplashView.swift
//  EWS
//
//  Created by Alvin Ling on 4/13/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit
import VGContent

class SplashView: VGXibView {
  
    @IBOutlet weak var imageView: UIImageView!
    
    override func setup(withItem item: Any!) {
        if let imageName = item as? String {
            imageView.image = UIImage(named: imageName)
        }
    }

}

class SplashCarousel: VGCarouselContent {
    override func setup() {
        super.setup()
        cellIdentifier = SplashView.identifier()
        carousel?.isPagingEnabled = true
    }
}

