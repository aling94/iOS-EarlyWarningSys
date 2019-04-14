//
//  AddPostVC.swift
//  EWS
//
//  Created by Alvin Ling on 4/13/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit
import UITextView_Placeholder
import SVProgressHUD

class AddPostVC: BaseVC {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var commentBox: UITextView!
    @IBOutlet weak var pickImageBtn: UIButton!
    
    var picChanged = false
    var imagePickerDelegate: ImagePickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Post"
        navbarTextColor = .white
        commentBox.placeholder = "What are your thoughts?"
        commentBox.placeholderColor = .white
    }
    
    func changePostImage(_ image: UIImage?) {
        guard let image = image else { return }
        postImage.image = image
        pickImageBtn.setTitle("", for: .normal)
        picChanged = true
    }
    
    @IBAction func savePost(_ sender: Any) {
        
        if let newPic = postImage.image, picChanged, !commentBox.text.isEmpty {
            let text = commentBox.text.trimmingCharacters(in: .whitespacesAndNewlines)
            FirebaseManager.shared.addPost(img: newPic, postdesc: text) { error in
                if let error = error { self.showAlert(title: "Oops", msg: error.localizedDescription) }
                else { self.navigationController?.popViewController(animated: true) }
            }
        } else {
            var errors: [String] = []
            
            if commentBox.text.isEmpty {
                errors.append("You've let the description box empty!")
            }
            if !picChanged {
                errors.append("You haven't selected a photo to upload!")
            }
            showAlert(title: "Hey!", msg: errors.joined(separator: "\n\n"))
        }
    }
    
    @IBAction func uploadImage(_ sender: Any) {
        imagePickerDelegate = ImagePickerDelegate()
        imagePickerDelegate?.selectImageAction = { [unowned self] img in self.changePostImage(img) }
        
        let imgPicker = UIImagePickerController()
        let hasCamera = UIImagePickerController.isSourceTypeAvailable(.camera)
        imgPicker.sourceType = hasCamera ? .camera : .photoLibrary
        imgPicker.delegate = imagePickerDelegate
        SVProgressHUD.show()
        self.present(imgPicker, animated:true)
    }
}
