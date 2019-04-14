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
    let splashImages = ["Splash1", "Splash2", "Splash3", "Splash4", "Splash5", ""]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupSplashContent()
        setupPageCtrl()
    }
    
    func setupSplashContent() {
        carousel = SplashCarousel(view: carouselView)
        carousel.delegate = self
        carousel.setItems(splashImages)
    }
    
    func setupPageCtrl() {
        pageControl.numberOfPages = splashImages.count
        pageControl.currentPage = 0
        pageControl.dotImage = UIImage(named: "pageControlUnselected")
        pageControl.currentDotImage = UIImage(named: "pageControlSelected")
    }

}

// MARK: - VGCarouselContentDelegate
extension SplashVC: VGCarouselContentDelegate {
    
    func content(_ content: VGURLContent!, didChangeCurrentItem item: Any!) {
        pageControl.currentPage = carouselView.currentItemIndex
        playSelectedVideo()
    }
    
    func playSelectedVideo() {
        if let screen = carousel.selectedItem as? String {
            if screen.isEmpty{
                let vc = getVC(identifier: "LoginNav")
                UIApplication.shared.keyWindow?.rootViewController = vc
            }
        }
    }
}
