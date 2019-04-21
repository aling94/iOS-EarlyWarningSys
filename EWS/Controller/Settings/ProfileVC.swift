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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Profile"
    }
    
    var spacer: SpaceCellRow {
        return spacer(gapSize: 10)
    }

    override func setupForm() {
        form
        +++ Section()
        <<< name("fname", "FIRST NAME", "First name required.")
        <<< spacer
        <<< name("lname", "LAST NAME", "Last name required.")
        <<< spacer
        <<< phone()
        <<< spacer
        <<< birthdate()
        <<< gender()
        
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
