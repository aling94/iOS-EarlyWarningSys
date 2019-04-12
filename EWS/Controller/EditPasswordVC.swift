//
//  EditPasswordVC.swift
//  EWS
//
//  Created by Alvin Ling on 4/12/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit
import Eureka

class EditPasswordVC: ProfileVC {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    override func setupForm() {
        // Form config
        fields = ["pass", "cpass"]
        let cellHeight: CGFloat = 48
        
        form
        +++ Section()
        // Password field
        <<< PasswordFloatLabelRow("pass") {
            $0.title = "PASSWORD"
            $0.cell.height = { cellHeight }
            
            $0.add(rule: RuleRequired())
            $0.add(rule: RuleMinLength(minLength: 6))
            $0.add(rule: RuleMaxLength(maxLength: 30))
        }
        
        <<< spacer
        // Confirm Password field
        <<< PasswordFloatLabelRow("cpass") {
            $0.title = "CONFIRM PASSWORD"
            $0.cell.height = { cellHeight }
            $0.add(rule: RuleRequired())
            $0.add(rule: RuleMinLength(minLength: 6))
            $0.add(rule: RuleMaxLength(maxLength: 30))
        }
    }
    
    override func loadUserInfo() {
        
    }
    
    @IBAction override func saveInfo(_ sender: Any) {
        
    }
    
    @IBAction override func resetFields(_ sender: Any) {
        
    }

}
