//
//  AddPostVC.swift
//  EWS
//
//  Created by Alvin Ling on 4/13/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class AddPostVC: UIViewController {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var commentBox: UITextView!
    
    var picChanged = false
    
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
        picChanged = true
    }
    
    @IBAction func savePost(_ sender: Any) {
        
        if let newPic = postImage.image, picChanged, !commentBox.text.isEmpty {
            FirebaseManager.shared.addPost(img: newPic, postdesc: commentBox.text) { error in
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
        promptImageUpload()
    }
}

extension AddPostVC: UITextViewDelegate {
    
    
}

// MARK : - ImagePicker
extension AddPostVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        let selected = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        dismiss(animated: true) {
            self.changePostImage(selected)
        }
    }
}
