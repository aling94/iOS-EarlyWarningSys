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
    
    var fields: [String] = []
    private var picChanged = false
    private var imagePickerDelegate: ImagePickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupForm()
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
        fields = ["fname", "lname", "phone", "dob", "gender"]
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
    
    @IBAction func resetFields(_ sender: Any) {
        // TODO use stored current user info instead
        loadUserInfo()
    }
    
    @IBAction func saveInfo(_ sender: Any) {
        guard form.validate().isEmpty else {
            showAlert(title: "Oops", msg: "Some inputs are invalid.")
            return
        }
        SVProgressHUD.show()
        let info = formToDict(tags: fields)
        var errorsMsgs: [String] = []
        let dpg = DispatchGroup()
        dpg.enter()
        FirebaseManager.shared.updateCurrentUserInfo(info) { error in
            if let error = error {
                DispatchQueue.global().async(flags: .barrier) {
                    errorsMsgs.append(error.localizedDescription)
                    dpg.leave()
                }
            } else { dpg.leave() }
        }
        
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
        imagePickerDelegate = ImagePickerDelegate()
        imagePickerDelegate?.selectImageAction = { [unowned self] img in self.changeUserImage(img) }
        
        let imgPicker = UIImagePickerController()
        let hasCamera = UIImagePickerController.isSourceTypeAvailable(.camera)
        imgPicker.sourceType = hasCamera ? .camera : .photoLibrary
        imgPicker.delegate = imagePickerDelegate
        SVProgressHUD.show()
        self.present(imgPicker, animated:true)
    }
    
    private func changeUserImage(_ image: UIImage?) {
        guard let image = image else { return }
        self.userImage?.setImage(image, for: .normal)
        self.picChanged = true
    }
}
