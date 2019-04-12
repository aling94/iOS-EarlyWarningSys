//
//  File.swift
//  EWS
//
//  Created by Alvin Ling on 4/11/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit
import SVProgressHUD

class BaseVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavBarClear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
}
