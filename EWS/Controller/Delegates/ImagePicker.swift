//
//  ImagePicker.swift
//  EWS
//
//  Created by Alvin Ling on 4/19/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit

class ImagePicker: UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectImageAction: ((UIImage?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selected = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        picker.dismiss(animated: true) {
            self.selectImageAction?(selected)
        }
    }
}
