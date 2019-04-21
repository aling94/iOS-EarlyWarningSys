//
//  SplashVC.swift
//  EWS
//
//  Created by Alvin Ling on 4/14/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit
import iCarousel
import TAPageControl

class SplashVC: UIViewController {

    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var carouselView: iCarousel!
    @IBOutlet weak var pageControl: TAPageControl!
    
    var carousel : SplashCarousel!
    let splashImages = ["Splash1", "Splash2", "Splash3", "Splash4", "Splash5"]

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
        pageControl.numberOfPages = splashImages.count
        pageControl.currentPage = 0
        pageControl.dotImage = UIImage(named: "pageControlUnselected")
        pageControl.currentDotImage = UIImage(named: "pageControlSelected")
    }
    
    @IBAction func goToLogin(_ sender: Any) {
        jumpToLogin()
    }
    
}

// MARK: - iCarouselDelegate
extension SplashVC: iCarouselDelegate {

    var onLastPage: Bool { return carouselView.currentItemIndex == splashImages.count - 1 }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        pageControl.currentPage = min(carouselView.currentItemIndex, splashImages.count - 1)
        skipBtn.isHidden = onLastPage
        if !onLastPage {
            startBtn.isEnabled = false
            startBtn.alpha = 0
        }
    }

    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        if onLastPage {
            startBtn.isEnabled = true
            UIView.animate(withDuration: 0.8) {
                self.startBtn.alpha = 1
                self.view.layoutIfNeeded()
                
            }
        }
    }
}
