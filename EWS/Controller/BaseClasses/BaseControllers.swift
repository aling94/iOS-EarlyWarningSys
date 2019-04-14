//
//  File.swift
//  EWS
//
//  Created by Alvin Ling on 4/11/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit
import Eureka
import SVProgressHUD

class BaseVC: UIViewController {

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
}

class FormVC: FormViewController {

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
}

class NavController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
}
