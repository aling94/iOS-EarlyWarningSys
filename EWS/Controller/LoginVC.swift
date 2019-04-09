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

class LoginVC: FormViewController {

    var email, passw: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupForm()
    }
    
    func setupUI() {
        title = "LOGIN"
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
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
        }
        .cellUpdate { (cell, row) in
            self.passw = cell.textField.text
        }
        
    }

    @IBAction func resetPass(_ sender: Any) {
        let msg = "Please enter the associated email."
        promptInput(title: "Forgot your password?", msg: msg, placeHolder: "Email") { (email) in
            guard !email.isEmpty else { return }
            Auth.auth().sendPasswordReset(withEmail: email)
        }
    }
    
}

