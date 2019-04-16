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
import SVProgressHUD
import GoogleSignIn

class LoginVC: FormVC {

    var email, passw: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupForm()
        title = "LOGIN"
    }

    func setupForm() {
        // Table config
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        
        // Form config
        let cellHeight: CGFloat = 50
        
        // Create form
        form
        +++ Section()
        // Email field
        <<< EmailFloatLabelRow {
            $0.title = "EMAIL"
            $0.cell.height = { cellHeight }
            $0.add(rule: RuleRequired(msg: "Email required!"))
            $0.add(rule: RuleEmail())
        }
        .cellUpdate { cell, row in
            if !row.isValid {
                cell.floatLabelTextField.titleTextColour = UIColor.red
            }
            self.email = cell.textField.text
        }
            
        <<< spacer(gapSize: 15)
            
        // Password field
        <<< PasswordFloatLabelRow {
            $0.title = "PASSWORD"
            $0.cell.height = { cellHeight }
            $0.add(rule: RuleRequired(msg: "Password required!"))
            $0.add(rule: RuleMinLength(minLength: 6, msg: "Password must be at least 6 characters."))
            $0.add(rule: RuleMaxLength(maxLength: 30, msg: "Password cannot be longer than 30 characters."))
        }
        .cellUpdate { (cell, row) in
            self.passw = cell.textField.text
        }
        
    }

    @IBAction func loginBtn(_ sender: Any) {
        let errors = form.validate()
        guard errors.isEmpty else {
            let msgs = errors.map( {$0.msg} )
            showAlert(title: "Oops", msg: msgs.joined(separator: "\n\n"))
            return
        }
        SVProgressHUD.show()
        FirebaseManager.shared.loginUser(email: email, passw: passw) { error in
            if error == nil {
                DispatchQueue.main.async {
                    let vc = self.getVC(identifier: "Tabs")
                    self.present(vc!, animated: true, completion: nil)
                }
            } else {
                self.alertError(error)
                SVProgressHUD.dismiss()
            }
        }
    }
    
    @IBAction func resetPass(_ sender: Any) {
        let title = "Forgot your password?"
        let msg = "Please enter the associated email."
        promptInput(title: title, msg: msg, placeHolder: "Email") { (email) in
            guard !email.isEmpty else { return }
            FirebaseManager.shared.resetPassword(email: email, errorHandler: self.alertError)
        }
    }
}

extension LoginVC: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (result, error) in
            print(result)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
}
