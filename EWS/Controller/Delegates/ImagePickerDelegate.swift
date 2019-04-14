//
//  ImagePickerDelegate.swift
//  EWS
//
//  Created by Alvin Ling on 4/13/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit

class ImagePickerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectImageAction: ((UIImage?) -> Void)?
    
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
