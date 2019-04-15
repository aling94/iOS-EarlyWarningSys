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
import SVProgressHUD

class SignupVC: FormVC {

    
    var email, passw, cpassw: String!
    var fname, lname, phone, dob, gender: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
        title = "SIGN UP"
    }
    
    var spacer: SpaceCellRow {
        return spacer(gapSize: 10)
    }
    
    func setupForm() {
        // Table config
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        
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
        }.cellUpdate { cell, row in
            if !row.isValid {
                cell.floatLabelTextField.titleTextColour = UIColor.red
            }
            self.email = cell.textField.text
        }
        
        <<< spacer
        // Password field
        <<< PasswordFloatLabelRow("pass") {
            $0.title = "PASSWORD"
            $0.cell.height = { cellHeight }
            
            $0.add(rule: RuleRequired(msg: "Password required!"))
            $0.add(rule: RuleMinLength(minLength: 6, msg: "Password must be at least 6 characters."))
            $0.add(rule: RuleMaxLength(maxLength: 30, msg: "Password cannot be longer than 30 characters."))
        }.cellUpdate { (cell, row) in
            self.passw = cell.textField.text
        }
        
        <<< spacer
        // Confirm Password field
        <<< PasswordFloatLabelRow { row in
            row.title = "CONFIRM PASSWORD"
            row.cell.height = { cellHeight }
            row.add(rule: RuleRequired(msg: "Please confirm your password."))
            
            row.add(rule: RuleClosure(closure: { _ in
                if let pass = (self.form.rowBy(tag: "pass") as? PasswordFloatLabelRow)?.value, pass != row.value {
                    return ValidationError(msg: "Passwords do not match!")
                }
                return nil
            }))
            
        }.cellUpdate { (cell, row) in
            self.cpassw = cell.textField.text
        }
        <<< spacer
            
        <<< TextFloatLabelRow() {
            $0.title = "FIRST NAME"
            $0.cell.height = { cellHeight }
            $0.add(rule: RuleRequired(msg: "First name required."))
        }.cellUpdate { cell, row in
            self.fname = cell.textField.text
        }
        
        <<< spacer
        
        <<< TextFloatLabelRow() {
            $0.title = "LAST NAME"
            $0.cell.height = { cellHeight }
            $0.add(rule: RuleRequired(msg: "First name required."))
        }.cellUpdate { cell, row in
            self.lname = cell.textField.text
        }
            
        <<< spacer
        // Phone field
        <<< PhoneFloatLabelRow() {
            $0.title = "PHONE NO."
            $0.cell.height = { cellHeight }
            $0.add(rule: RuleRequired(msg: "Phone number required."))
            $0.add(rule: RuleRegExp(regExpr: "^\\d{10}$", allowsEmpty: false, msg: "Not a valid phone number."))
        }.cellUpdate { cell, row in
            self.phone = cell.textField.text
        }
        
        <<< spacer
        // DOB field
        <<< DateRow() {
            $0.title = "DATE OF BIRTH"
            $0.add(rule: RuleRequired(msg: "Date of birth required."))
        }.cellSetup { cell, row in
            row.maximumDate = Date()
            cell.height = { cellHeight }
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
                self.dob = row.cell.textLabel?.text
            }
        }.cellUpdate { (cell, row) in
            cell.textLabel?.textColor = .white
            if let date = row.value {
                cell.textLabel?.text = row.dateFormatter?.string(from: date)
                self.dob = row.cell.textLabel?.text
            }
        }
        
 
        <<< SegmentedRow<String> {
            $0.options = ["MALE", "FEMALE"]
            $0.value = ($0.options?.first)!
            gender = $0.value
            
            $0.cell.height = { cellHeight }
            $0.cell.segmentedControl.backgroundColor = .clear
            $0.cell.layer.masksToBounds = true
            $0.cell.segmentedControl.tintColor = .white
            $0.cell.textLabel?.textColor = .white
            $0.cell.backgroundColor = .clear
            $0.add(rule: RuleRequired())
        }.cellUpdate { cell, row in
            cell.textLabel?.textColor = .white
        }.onChange { row in
            self.gender = row.value
        }
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        guard app.hasAllowedCoreLocation else {
            showAlert(title: "Ooops", msg: "This app requires access to your location. Please allow it.")
            app.requestLocation()
            return
        }
        
        let errors = form.validate()
        if !errors.isEmpty {
            let msgs = errors.map( {$0.msg} )
            showAlert(title: "Oops", msg: msgs.joined(separator: "\n\n"))
        } else { registerToDB() }
    }
    
    var fieldsAsDict: [String: Any] {
        return [
            "email": email!,
            "fname": fname!,
            "lname": lname!,
            "phone": phone!,
            "dob": dob!,
            "gender": gender!,
        ]
    }
    
    func registerToDB() {
        guard let coords = app.currentLocation?.coordinate, let locName = app.locationName else {
            showAlert(title: "Ooops", msg: "Error in retrieving location. Please restart or try again.")
            return
        }
        var info = fieldsAsDict
        info["latitude"] = coords.latitude
        info["longitude"] = coords.longitude
        info["location"] = locName
        
        SVProgressHUD.show()
        FirebaseManager.shared.registerUser(email: email, passw: passw, info: info) { (result, error) in
            if let _ = result?.user {
                self.loginUser()
            } else {
                SVProgressHUD.dismiss()
                self.alertError(error)
            }
        }
    }
    
    func loginUser() {
        FirebaseManager.shared.loginUser(email: email, passw: passw) { error in
            if error == nil {
                DispatchQueue.main.async {
                    let vc = self.getVC(identifier: "Tabs")
                    self.present(vc!, animated: true, completion: nil)
                }
            } else {
                SVProgressHUD.dismiss()
                self.alertError(error)
            }
        }
    }
}
