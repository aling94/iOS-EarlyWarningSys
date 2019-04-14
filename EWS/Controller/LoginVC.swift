//
//  LoginVC.swift
//  EWS
//
//  Created by Alvin Ling on 4/8/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit
import Eureka
import FirebaseAuth
import SVProgressHUD

class LoginVC: FormViewController {

    var email, passw: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "LOGIN"
        setupForm()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SVProgressHUD.dismiss()
    }
    
    func setupForm() {
        // Table config
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        
        // Form config
        let cellHeight: CGFloat = 50
        let cellGap: CGFloat = 15
        let spacer = SpaceCellRow {
            $0.cell.spaceHeight = cellGap
            $0.cell.backgroundColor = .clear
        }
        
        // Create form
        form
        +++ Section()
        // Email field
        <<< EmailFloatLabelRow {
            $0.title = "EMAIL"
            $0.cell.height = { cellHeight }
            $0.add(rule: RuleRequired())
            $0.add(rule: RuleEmail())
        }
        .cellUpdate { cell, row in
            if !row.isValid {
                cell.floatLabelTextField.titleTextColour = UIColor.red
            }
            self.email = cell.textField.text
        }
            
        <<< spacer
            
        // Password field
        <<< PasswordFloatLabelRow {
            $0.title = "PASSWORD"
            $0.cell.height = { cellHeight }
            $0.add(rule: RuleRequired())
            $0.add(rule: RuleMinLength(minLength: 6))
            $0.add(rule: RuleMaxLength(maxLength: 30))
        }
        .cellUpdate { (cell, row) in
            self.passw = cell.textField.text
        }
        
    }

    @IBAction func loginBtn(_ sender: Any) {
        guard form.validate().isEmpty else {
            showAlert(title: "Oops", msg: "Some fields are invalid.")
            return
        }
        SVProgressHUD.show()
        FirebaseManager.shared.loginUser(email: email, passw: passw) { error in
            if error == nil {
                DispatchQueue.main.async {
                    let vc = self.getVC(identifier: "Tabs")
                    self.present(vc!, animated: true, completion: nil)
                }
            } else {
                self.alertError(error)
                SVProgressHUD.dismiss()
            }
        }
    }
    
    @IBAction func resetPass(_ sender: Any) {
        let title = "Forgot your password?"
        let msg = "Please enter the associated email."
        promptInput(title: title, msg: msg, placeHolder: "Email") { (email) in
            guard !email.isEmpty else { return }
            FirebaseManager.shared.resetPassword(email: email, errorHandler: self.alertError)
        }
    }
    
}

