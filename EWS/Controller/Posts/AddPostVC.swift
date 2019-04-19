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
    }
    
    @IBAction func savePost(_ sender: Any) {
        
        if let newPic = postImage.image, !commentBox.text.isEmpty {
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
            if postImage.image == nil {
                errors.append("You haven't selected a photo to upload!")
            }
            showAlert(title: "Hey!", msg: errors.joined(separator: "\n\n"))
        }
    }
    
    @IBAction func uploadImage(_ sender: Any) {
        SVProgressHUD.show()
        let imgPicker = ImagePicker()
        imgPicker.selectImageAction = { [unowned self] img in self.changePostImage(img) }
        let hasCamera = UIImagePickerController.isSourceTypeAvailable(.camera)
        imgPicker.sourceType = hasCamera ? .camera : .photoLibrary
        self.present(imgPicker, animated:true)
    }
}
