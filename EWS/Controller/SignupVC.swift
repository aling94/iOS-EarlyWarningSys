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
    var phone, dob: String?
    
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
        let cellHeight: CGFloat = 48
        let cellGap: CGFloat = 10
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
        // Phone field
        <<< PhoneFloatLabelRow() {
            $0.title = "PHONE NO."
            $0.cell.height = { cellHeight }
        }
        .cellUpdate { cell, row in
            self.phone = cell.textField.text
        }
        
        <<< spacer
        // DOB field
        <<< DateRow() {
            $0.title = "DATE OF BIRTH"
        }
        .cellSetup { cell, row in
            cell.height = { cellHeight }
            cell.backgroundColor = .clear
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.cornerRadius = 5
            cell.layer.borderWidth = 2
            cell.layer.masksToBounds = true
            cell.textLabel?.textColor = .white
            cell.detailTextLabel?.textColor = .white
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 18)
            cell.detailTextLabel?.text = ""
        }
        .cellUpdate { (cell, row) in
            
            cell.textLabel?.textColor = .white
            if let date = row.value {
                cell.textLabel?.text = row.dateFormatter?.string(from: date)
            }
            cell.detailTextLabel?.text = ""
            self.dob = cell.detailTextLabel?.text
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
