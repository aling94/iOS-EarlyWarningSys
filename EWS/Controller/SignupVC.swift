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

class SignupVC: FormViewController {

    var ref: DatabaseReference!
    
    var email, passw, cpassw: String!
    var fname, lname, phone, dob, gender: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SIGN UP"
        ref = Database.database().reference()
        setupForm()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SVProgressHUD.dismiss()
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
        <<< PasswordFloatLabelRow {
            $0.title = "PASSWORD"
            $0.cell.height = { cellHeight }
            
            $0.add(rule: RuleRequired())
            $0.add(rule: RuleMinLength(minLength: 6))
            $0.add(rule: RuleMaxLength(maxLength: 30))
        }.cellUpdate { (cell, row) in
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
        }.cellUpdate { (cell, row) in
            self.cpassw = cell.textField.text
        }
        <<< spacer
            
        <<< TextFloatLabelRow() {
            $0.title = "FIRST NAME"
            $0.cell.height = { cellHeight }
            $0.add(rule: RuleRequired())
        }.cellUpdate { cell, row in
            self.fname = cell.textField.text
        }
        
        <<< spacer
        
        <<< TextFloatLabelRow() {
            $0.title = "LAST NAME"
            $0.cell.height = { cellHeight }
            $0.add(rule: RuleRequired())
        }.cellUpdate { cell, row in
            self.lname = cell.textField.text
        }
            
        <<< spacer
        // Phone field
        <<< PhoneFloatLabelRow() {
            $0.title = "PHONE NO."
            $0.cell.height = { cellHeight }
            $0.add(rule: RuleRequired())
        }.cellUpdate { cell, row in
            self.phone = cell.textField.text
        }
        
        <<< spacer
        // DOB field
        <<< DateRow() {
            $0.title = "DATE OF BIRTH"
            $0.add(rule: RuleRequired())
        }.cellSetup { cell, row in
            row.maximumDate = Date()
            cell.height = { cellHeight }
            cell.backgroundColor = .clear
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
        
        let valid = form.validate().isEmpty && (passw == cpassw)
        if valid { registerToDB() }
        else {
            showAlert(title: "Ooops", msg: "You've got some errors.")
        }
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
