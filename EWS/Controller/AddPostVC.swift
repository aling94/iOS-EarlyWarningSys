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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Post"
        navbarTextColor = .white
        commentBox.placeholder = "What are your thoughts?"
        commentBox.placeholderColor = .white
    }
    
    @IBAction func savePost(_ sender: Any) {
    }
    
    @IBAction func uploadImage(_ sender: Any) {
    }
}

extension AddPostVC: UITextViewDelegate {
    
    
}
