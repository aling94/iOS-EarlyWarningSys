//
//  SignupVC.swift
//  EWS
//
//  Created by Alvin Ling on 4/8/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit
import Eureka
import CoreLocation
import FirebaseAuth
import FirebaseDatabase
class SignupVC: FormViewController {

    var ref: DatabaseReference!
    
    var email, passw, cpassw: String!
    var fname, lname, phone, dob: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "JOIN"
        ref = Database.database().reference()
        setupForm()
    }
    
    var spacer: SpaceCellRow {
        let cellGap: CGFloat = 10
        return SpaceCellRow {
            $0.cell.spaceHeight = cellGap
            $0.cell.backgroundColor = .clear
        }
    }
    
    func setupForm() {
        // Table config
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        
        // Form config
        let cellHeight: CGFloat = 48
        
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
        
        <<< spacer
        // Confirm Password field
        <<< PasswordFloatLabelRow {
            $0.title = "CONFIRM PASSWORD"
            $0.cell.height = { cellHeight }
            $0.add(rule: RuleRequired())
            $0.add(rule: RuleMinLength(minLength: 6))
            $0.add(rule: RuleMaxLength(maxLength: 30))
            }
            .cellUpdate { (cell, row) in
                self.cpassw = cell.textField.text
        }
        <<< spacer
            
        <<< TextFloatLabelRow() {
            $0.title = "FIRST NAME"
            $0.cell.height = { cellHeight }
        }
        .cellUpdate { cell, row in
            self.fname = cell.textField.text
        }
        
        <<< spacer
        
        <<< TextFloatLabelRow() {
            $0.title = "LAST NAME"
            $0.cell.height = { cellHeight }
        }
        .cellUpdate { cell, row in
            self.lname = cell.textField.text
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
            row.maximumDate = Date()
            cell.height = { cellHeight }
            cell.backgroundColor = .clear
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.cornerRadius = 5
            cell.layer.borderWidth = 2
            cell.layer.masksToBounds = true
            cell.textLabel?.textColor = .white
            cell.detailTextLabel?.textColor = .white
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 18)
        }
        .cellUpdate { (cell, row) in
            
            cell.textLabel?.textColor = .white
            if let date = row.value {
                cell.textLabel?.text = row.dateFormatter?.string(from: date)
            }
            cell.detailTextLabel?.text = ""
            self.dob = cell.textLabel?.text
        }
        
//        <<< spacer
//        
//        <<< StepperRow {
//            $0.title = "MALE"
//        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if allRowsValid { return true }
        showAlert(title: "Oops", msg: "Some inputs are invalid!")
        return false
    }
    
    @IBAction func submitBtn(_ sender: Any) {

    }
    
    var fieldsAsDict: [String: String] {
        return [
            "email": email,
            "phone": phone,
            "dob": dob,
        ]
    }
    
    func registerToDB() {
        FirebaseManager.shared.registerUser(email: email, passw: passw, info: fieldsAsDict, errorHandler: alertError)
    }
}
