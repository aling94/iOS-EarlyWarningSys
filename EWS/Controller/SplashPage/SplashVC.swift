//
//  SplashVC.swift
//  EWS
//
//  Created by Alvin Ling on 4/14/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit
import iCarousel
import VGContent
import TAPageControl

class SplashVC: UIViewController {

    @IBOutlet weak var carouselView: iCarousel!
    @IBOutlet weak var pageControl: TAPageControl!
    
    var carousel : SplashCarousel!
    let splashImages = ["Splash1", "Splash2", "Splash3", "Splash4", "Splash5", "Splash6"]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupSplashContent()
        setupPageCtrl()
    }
    
    func setupSplashContent() {
        carousel = SplashCarousel(view: carouselView)
        carousel.setItems(splashImages)
        carouselView.delegate = self
    }
    
    func setupPageCtrl() {
        pageControl.numberOfPages = splashImages.count - 1
        pageControl.currentPage = 0
        pageControl.dotImage = UIImage(named: "pageControlUnselected")
        pageControl.currentDotImage = UIImage(named: "pageControlSelected")
    }

}

// MARK: - VGCarouselContentDelegate &iCarouselDelegate
extension SplashVC: iCarouselDelegate {

    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        pageControl.currentPage = min(carouselView.currentItemIndex, splashImages.count - 2)
    }

    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        if carouselView.currentItemIndex == splashImages.count - 1 {
            let vc = getVC(identifier: "LoginNav")
            UIApplication.shared.keyWindow?.rootViewController = vc
        }
    }
}
