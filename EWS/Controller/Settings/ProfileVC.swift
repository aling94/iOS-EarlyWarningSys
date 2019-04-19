//
//  ProfileVC.swift
//  EWS
//
//  Created by Alvin Ling on 4/10/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit
import Eureka
import SVProgressHUD

class ProfileVC: FormVC, UINavigationControllerDelegate {

    @IBOutlet private weak var userImage: UIButton!
    
    private var picChanged = false
    private var fieldsChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Profile"
    }
    
    var spacer: SpaceCellRow {
        return spacer(gapSize: 10)
    }

    override func setupForm() {
        
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
        .onChange { _ in self.fieldsChanged = true }
        <<< spacer
        
        <<< TextFloatLabelRow("lname") {
            $0.title = "LAST NAME"
            $0.cell.height = { cellHeight }
            $0.add(rule: RuleRequired())
        }
        .onChange { _ in self.fieldsChanged = true }
        <<< spacer
            
        // Phone field
        <<< PhoneFloatLabelRow("phone") {
            $0.title = "PHONE NO."
            $0.cell.height = { cellHeight }
            $0.add(rule: RuleRequired())
        }
        .onChange { _ in self.fieldsChanged = true }
        <<< spacer
            
        // DOB field
        <<< DateRow("dob") {
            $0.title = "DATE OF BIRTH"
            $0.add(rule: RuleRequired())
        }
        .cellSetup { cell, row in
            row.maximumDate = Date()
            cell.height = { cellHeight }
            cell.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
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
            self.fieldsChanged = true
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
        .onChange { _ in self.fieldsChanged = true }
        .cellUpdate { cell, row in
            cell.textLabel?.textColor = .white
        }
        
        loadUserInfo()
        fieldsChanged = false
    }
    
    func loadUserInfo() {
        if let currentInfo = FirebaseManager.shared.currentUserInfo {
            setUserInfo(currentInfo)
            return
        }
        
        FirebaseManager.shared.getCurrentUserInfo { (userInfo) in
            guard let userInfo = userInfo else { return }
            self.setUserInfo(userInfo)
        }
    }
    
    private func setUserInfo(_ userInfo: UserInfo) {
        let form = self.form
        (form.rowBy(tag: "fname") as! TextFloatLabelRow).value = userInfo.fname
        (form.rowBy(tag: "lname") as! TextFloatLabelRow).value = userInfo.lname
        (form.rowBy(tag: "phone") as! PhoneFloatLabelRow).value = userInfo.phone
        (form.rowBy(tag: "gender") as! SegmentedRow<String>).value = userInfo.gender
        let dateRow = form.rowBy(tag: "dob") as! DateRow
        if let dob = userInfo.dob, let date = dateRow.dateFormatter?.date(from: dob) {
            dateRow.value = date
        }
        
        DispatchQueue.main.async {
            if let pic = userInfo.image { self.userImage.setImage(pic, for: .normal) }
            form.rows.forEach( {$0.reload()} )
        }
    }
    
    
    @IBAction func resetFields(_ sender: Any) {
        picChanged = false
        fieldsChanged = false
        loadUserInfo()
    }
    
    @IBAction func saveInfo(_ sender: Any) {
        guard picChanged || fieldsChanged else { return }
        guard form.validate().isEmpty else {
            showAlert(title: "Oops", msg: "Some inputs are invalid.")
            return
        }
        SVProgressHUD.show()
        let info = infoDict
        
        var errorsMsgs: [String] = []
        let dpg = DispatchGroup()
        dpg.enter()
        
        if picChanged {
            dpg.enter()
            FirebaseManager.shared.saveUserImage(userImage.currentImage!) { error in
                if let error = error {
                    DispatchQueue.global().async(flags: .barrier) {
                        errorsMsgs.append(error.localizedDescription)
                        dpg.leave()
                    }
                } else { dpg.leave() }
            }
            picChanged = false
        }
        FirebaseManager.shared.updateCurrentUserInfo(info) { error in
            if let error = error {
                DispatchQueue.global().async(flags: .barrier) {
                    errorsMsgs.append(error.localizedDescription)
                    dpg.leave()
                }
            } else { dpg.leave() }
        }
        
        dpg.notify(queue: .main) {
            SVProgressHUD.dismiss()
            if errorsMsgs.isEmpty {
                self.showAlert(title: "Success!", msg: "Your profile info has been updated!")
            } else {
                self.showAlert(title: "Oops!", msg: errorsMsgs.joined(separator: "\n\n"))
            }
        }
    }
    
    @IBAction private func changePic(_ sender: Any) {
        SVProgressHUD.show()
        let imgPicker = ImagePicker()
        imgPicker.selectImageAction = { [unowned self] img in self.changeUserImage(img) }
        let hasCamera = UIImagePickerController.isSourceTypeAvailable(.camera)
        imgPicker.sourceType = hasCamera ? .camera : .photoLibrary
        self.present(imgPicker, animated:true)
    }
    
    private func changeUserImage(_ image: UIImage?) {
        guard let image = image else { return }
        self.userImage?.setImage(image, for: .normal)
        self.picChanged = true
    }
}
