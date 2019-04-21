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
        form
        +++ Section()
        <<< password()
        <<< spacer
        <<< confirmPass()
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
