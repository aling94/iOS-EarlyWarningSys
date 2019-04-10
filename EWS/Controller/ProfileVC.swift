//
//  ProfileVC.swift
//  EWS
//
//  Created by Alvin Ling on 4/10/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit
import Eureka

class ProfileVC: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
        setupForm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        FirebaseManager.shared.getCurrentUserInfo { (userInfo) in
            DispatchQueue.main.async {
                self.loadUserInfo(userInfo)
            }
        }
    }


    var spacer: SpaceCellRow {
        let cellGap: CGFloat = 10
        return SpaceCellRow {
            $0.cell.spaceHeight = cellGap
            $0.cell.backgroundColor = .clear
        }
    }
    
    func loadUserInfo(_ userInfo: UserInfo) {
        (form.rowBy(tag: "fname") as! TextFloatLabelRow).value = userInfo.fname
        (form.rowBy(tag: "lname") as! TextFloatLabelRow).value = userInfo.lname
        (form.rowBy(tag: "phone") as! PhoneFloatLabelRow).value = userInfo.phone
        (form.rowBy(tag: "gender") as! SegmentedRow<String>).value = userInfo.gender
        let dateRow = form.rowBy(tag: "dob") as! DateRow
        dateRow.value = dateRow.dateFormatter?.date(from: userInfo.dob)
        form.rows.forEach( {$0.reload()} )
    }
    
    func setupForm() {
        
        // Form config
        let cellHeight: CGFloat = 48
        
        // Create form
        form
            +++ Section()
            
            <<< TextFloatLabelRow("fname") {
                $0.title = "FIRST NAME"
                $0.cell.height = { cellHeight }
                $0.add(rule: RuleRequired())
            }
            
            <<< spacer
            
            <<< TextFloatLabelRow("lname") {
                $0.title = "LAST NAME"
                $0.cell.height = { cellHeight }
                $0.add(rule: RuleRequired())
            }
            
            <<< spacer
            // Phone field
            <<< PhoneFloatLabelRow("phone") {
                $0.title = "PHONE NO."
                $0.cell.height = { cellHeight }
                $0.add(rule: RuleRequired())
            }
            
            <<< spacer
            // DOB field
            <<< DateRow("dob") {
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
                    }
                }.cellUpdate { (cell, row) in
                    cell.textLabel?.textColor = .white
                    if let date = row.value {
                        cell.textLabel?.text = row.dateFormatter?.string(from: date)
                    }
            }
            
            <<< SegmentedRow<String>("gender") {
                $0.title = "GENDER"
                $0.options = ["MALE", "FEMALE"]
                $0.value = "MALE"
                
                $0.cell.height = { cellHeight }
                $0.cell.segmentedControl.backgroundColor = .clear
                $0.cell.layer.masksToBounds = true
                $0.cell.segmentedControl.tintColor = .white
                $0.cell.textLabel?.textColor = .white
                $0.cell.backgroundColor = .clear
                $0.add(rule: RuleRequired())
                }.cellUpdate { cell, row in
                    cell.textLabel?.textColor = .white
        }
    }

}
