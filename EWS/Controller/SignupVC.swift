//
//  SignupVC.swift
//  EWS
//
//  Created by Alvin Ling on 4/8/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit
import Eureka

class SignupVC: FormViewController {

    var email, passw, cpassw: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "JOIN"
        setupForm()
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
        
        <<< spacer
        
        // Confirm Password field
        <<< PasswordFloatLabelRow {
            $0.title = "CONFIRM PASSWORD"
            $0.cell.height = { cellHeight }
        }
        .cellUpdate { (cell, row) in
            self.cpassw = cell.textField.text
        }
        
    }

}
