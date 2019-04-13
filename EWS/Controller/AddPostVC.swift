//
//  AddPostVC.swift
//  EWS
//
//  Created by Alvin Ling on 4/13/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit

class AddPostVC: UIViewController {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var commentBox: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Post"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func savePost(_ sender: Any) {
    }
    
    @IBAction func uploadImage(_ sender: Any) {
    }
}

extension AddPostVC: UITextViewDelegate {
    
    
}
