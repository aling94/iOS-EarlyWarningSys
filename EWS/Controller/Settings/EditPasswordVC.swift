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
        title = "Edit Password"
    }
    
    override func setupForm() {
        // Form config
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
        let form = self.form
        (form.rowBy(tag: "pass") as! PasswordFloatLabelRow).value = ""
        (form.rowBy(tag: "cpass") as! PasswordFloatLabelRow).value = ""
        DispatchQueue.main.async {
            form.rows.forEach( {$0.reload()} )
        }
    }
    
    @IBAction override func saveInfo(_ sender: Any) {
        let vals = form.values() as! [String : String]
        if form.validate().isEmpty {
            if vals["pass"] == vals["cpass"] {
                let handler = alertError(successMsg: "Password changed.")
                FirebaseManager.shared.updatePassword(vals["pass"]!, errorHandler: handler)
            } else {
                showAlert(title: "Oops", msg: "Passwords don't match!")
            }
        } else {
            showAlert(title: "Oops", msg: "Invalid passwords.")
        }
    }
}
