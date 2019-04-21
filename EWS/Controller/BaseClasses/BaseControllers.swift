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
import GooglePlaces

class BaseVC: UIViewController {

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
}

class FormVC: FormViewController {
    
    var fieldsChanged = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Table config
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        setupForm()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    func setupForm() {}
    
    // Email field
    func email(_ tag: String = "email", height: CGFloat = 48) -> EmailFloatLabelRow {
        return EmailFloatLabelRow(tag) {
            $0.title = "EMAIL"
            $0.cell.height = { height }
            $0.add(rule: RuleRequired())
            $0.add(rule: RuleEmail())
        }.cellUpdate { cell, row in
            if !row.isValid {
                cell.floatLabelTextField.titleTextColour = UIColor.red
            }
        }.onChange { _ in self.fieldsChanged = true }
    }
    
    // Password field
    func password(_ tag: String = "pass", height: CGFloat = 48) -> PasswordFloatLabelRow {
        return PasswordFloatLabelRow(tag) {
            $0.title = "PASSWORD"
            $0.cell.height = { height }
            $0.add(rule: RuleRequired(msg: "Password required!"))
            $0.add(rule: RuleMinLength(minLength: 6, msg: "Password must be at least 6 characters."))
            $0.add(rule: RuleMaxLength(maxLength: 30, msg: "Password cannot be longer than 30 characters."))
        }.onChange { _ in self.fieldsChanged = true }
    }
    
    // Confirm Password field
    func confirmPass(_ tag: String = "cpass", height: CGFloat = 48) -> PasswordFloatLabelRow {
        return PasswordFloatLabelRow(tag) { row in
            row.title = "CONFIRM PASSWORD"
            row.cell.height = { height }
            row.add(rule: RuleRequired(msg: "Please confirm your password."))
            row.add(rule: RuleClosure { _ in
                if let pass = (self.form.rowBy(tag: "pass") as? PasswordFloatLabelRow)?.value, pass != row.value {
                    return ValidationError(msg: "Passwords do not match!")
                }
                return nil
            })
        }.onChange { _ in self.fieldsChanged = true }
    }
    
    // Name field
    func name(_ tag: String, _ title: String, _ msg: String, height: CGFloat = 48 ) -> TextFloatLabelRow {
        return TextFloatLabelRow(tag) {
            $0.title = title
            $0.cell.height = { height }
            $0.add(rule: RuleRequired(msg: msg))
        }.onChange { _ in self.fieldsChanged = true }
    }
    
    // Phone field
    func phone(_ tag: String = "phone", height: CGFloat = 48) -> PhoneFloatLabelRow {
        return PhoneFloatLabelRow(tag) {
            $0.title = "PHONE NO."
            $0.cell.height = { height }
            $0.add(rule: RuleRequired(msg: "Phone number required."))
            $0.add(rule: RuleRegExp(regExpr: "^\\d{10}$", allowsEmpty: false, msg: "Not a valid phone number."))
        }.onChange { _ in self.fieldsChanged = true }
    }
    
    // DOB field
    func birthdate(_ tag: String = "dob", height: CGFloat = 48) -> DateRow {
        return DateRow(tag) {
            $0.title = "DATE OF BIRTH"
            $0.add(rule: RuleRequired(msg: "Date of birth required."))
        }.cellSetup { cell, row in
            row.maximumDate = Date()
            cell.height = { height }
            cell.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.cornerRadius = 5
            cell.layer.borderWidth = 2
            cell.layer.masksToBounds = true
            cell.textLabel?.textColor = .white
            cell.detailTextLabel?.isHidden = true
        }.onChange { row in
            if let date = row.value {
                row.cell.textLabel?.text = row.dateFormatter?.string(from: date)
            }
            self.fieldsChanged = true
        }.cellUpdate { (cell, row) in
            cell.textLabel?.textColor = .white
            if let date = row.value {
                cell.textLabel?.text = row.dateFormatter?.string(from: date)
            }
        }
    }
    
    
    func gender(_ tag: String = "gender", height: CGFloat = 48) -> SegmentedRow<String> {
        return SegmentedRow<String>(tag) {
            $0.options = ["MALE", "FEMALE"]
            $0.value = ($0.options?.first)!
            
            $0.cell.height = { height }
            $0.cell.segmentedControl.backgroundColor = .clear
            $0.cell.layer.masksToBounds = true
            $0.cell.segmentedControl.tintColor = .white
            $0.cell.textLabel?.textColor = .white
            $0.cell.backgroundColor = .clear
            $0.add(rule: RuleRequired())
        }.cellUpdate { cell, row in
            cell.textLabel?.textColor = .white
        }.onChange { _ in self.fieldsChanged = true }
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
