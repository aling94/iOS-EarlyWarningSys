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

    @IBOutlet weak var userImage: UIButton!
    
    let fields = ["fname", "lname", "phone", "dob", "gender"]
    var picChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        setupTable()
        setupForm()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserInfo()
    }

    var spacer: SpaceCellRow {
        return spacer(gapSize: 10)
    }

    func setupTable() {
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        tableView.separatorColor = .clear
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
            cell.detailTextLabel?.isHidden = true
        }
        .onChange { row in
            if let date = row.value {
                row.cell.textLabel?.text = row.dateFormatter?.string(from: date)
            }
        }
        .cellUpdate { (cell, row) in
            cell.textLabel?.textColor = .white
            if let date = row.value {
                cell.textLabel?.text = row.dateFormatter?.string(from: date)
            }
        }
        
        <<< SegmentedRow<String>("gender") {
            $0.options = ["MALE", "FEMALE"]
            $0.value = "MALE"
            $0.cell.height = { cellHeight }
            $0.cell.segmentedControl.backgroundColor = .clear
            $0.cell.segmentedControl.tintColor = .white
            $0.cell.layer.masksToBounds = true
            $0.cell.textLabel?.textColor = .white
            $0.cell.backgroundColor = .clear
            $0.add(rule: RuleRequired())
        }
        .cellUpdate { cell, row in
            cell.textLabel?.textColor = .white
        }
    }
    
    func loadUserInfo() {
        FirebaseManager.shared.getCurrentUserInfo { (userInfo) in
            guard let userInfo = userInfo else { return }
            let form = self.form
            (form.rowBy(tag: "fname") as! TextFloatLabelRow).value = userInfo.fname
            (form.rowBy(tag: "lname") as! TextFloatLabelRow).value = userInfo.lname
            (form.rowBy(tag: "phone") as! PhoneFloatLabelRow).value = userInfo.phone
            (form.rowBy(tag: "gender") as! SegmentedRow<String>).value = userInfo.gender
            let dateRow = form.rowBy(tag: "dob") as! DateRow
            dateRow.value = dateRow.dateFormatter?.date(from: userInfo.dob)
            
            DispatchQueue.main.async {
                if let pic = userInfo.image { self.userImage.setImage(pic, for: .normal) }
                form.rows.forEach( {$0.reload()} )
            }
        }
    }

    @IBAction func changePic(_ sender: Any) {
        promptImageUpload()
    }
    
    @IBAction func saveInfo(_ sender: Any) {
        var info: [String : Any] = [:]
        for tag in fields {
            let row = form.rowBy(tag: tag)
            if let val = row?.baseValue as? String, !val.isEmpty {
                info[tag] = val
            }
            else if let text = row?.baseCell.textLabel?.text {
                info[tag] = text
            }
        }
 
        FirebaseManager.shared.updateCurrentUserInfo(info)
        if picChanged {
            FirebaseManager.shared.saveUserImage(userImage.currentImage!)
            picChanged = false
        }
        
    }
    
    @IBAction func signOut(_ sender: Any) {
        FirebaseManager.shared.signoutUser()
        jumpToLogin()
    }
}

// MARK : - ImagePicker
extension ProfileVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Prompt the user to upload an image
    func promptImageUpload() {
        let imgPicker = UIImagePickerController()
        let hasCamera = UIImagePickerController.isSourceTypeAvailable(.camera)
        imgPicker.sourceType = hasCamera ? .camera : .photoLibrary
        imgPicker.delegate = self
        self.present(imgPicker, animated:true, completion:nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        let selected = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated: true) {
            guard let newPic = selected else { return }
            self.userImage.setImage(newPic, for: .normal)
            self.picChanged = true
        }
    }
}


