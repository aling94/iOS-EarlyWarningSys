//
//  LoginVC.swift
//  EWS
//
//  Created by Alvin Ling on 4/8/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit
import Eureka
import FirebaseAuth

class LoginVC: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    func setupUI() {
        title = "SIGN IN"
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func setupForm() {
        
    }

    @IBAction func resetPass(_ sender: Any) {
        let msg = "Please enter the associated email."
        promptInput(title: "Forgot your password?", msg: msg, placeHolder: "Email") { (email) in
            guard !email.isEmpty else { return }
            Auth.auth().sendPasswordReset(withEmail: email)
        }
    }
    
}

