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
import FirebaseMessaging
import SVProgressHUD
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class LoginVC: FormVC {

    @IBOutlet weak var googleSigninBtn: GIDSignInButton!
    @IBOutlet weak var fbSigninBtn: FBSDKLoginButton!
    
    var email, passw: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "LOGIN"
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        fbSigninBtn.delegate = self
    }

    override func setupForm() {
        form
        +++ Section()
        <<< email(height: 50)
        <<< spacer(gapSize: 15)
        <<< password(height: 50)
    }

    @IBAction func loginBtn(_ sender: Any) {
        let errors = form.validate()
        guard errors.isEmpty else {
            let msgs = errors.map( {$0.msg} )
            showAlert(title: "Oops", msg: msgs.joined(separator: "\n\n"))
            return
        }
        guard let vals = form.values() as? [String : String] else { return }
        SVProgressHUD.show()
        FirebaseManager.shared.loginUser(email: vals["email"]!, passw: vals["pass"]!, errorHandler: loginHandler)
    }
    
    @IBAction func resetPass(_ sender: Any) {
        let title = "Forgot your password?"
        let msg = "Please enter the associated email."
        promptInput(title: title, msg: msg, placeHolder: "Email") { (email) in
            guard !email.isEmpty else { return }
            FirebaseManager.shared.resetPassword(email: email, errorHandler: self.alertError)
        }
    }
    
    @IBAction func loginToGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func thirdPartyLogin(_ credential: AuthCredential) {
        SVProgressHUD.show()
        Auth.auth().signInAndRetrieveData(with: credential) { (result, error) in
            guard let uid = result?.user.uid else {
                SVProgressHUD.dismiss()
                self.showAlert(title: "Oops", msg: (error?.localizedDescription)!)
                FirebaseManager.shared.signoutUser()
                return
            }
            Messaging.messaging().subscribe(toTopic: uid)
            FirebaseManager.shared.userExists { exists in
                if exists { self.goToHome() }
                else {
                    let info = UserInfo.userDict(authInfo: result!)
                    let handler = self.loginHandler
                    FirebaseManager.shared.updateUserInfo(uid: info["uid"] as! String, info: info, errorHandler: handler)
                }
            }
        }
    }
}

extension LoginVC: GIDSignInDelegate, GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        guard error == nil else { return }
        
        guard let auth = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        thirdPartyLogin(credential)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {}
}

extension LoginVC: FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let token = FBSDKAccessToken.current() else { return }
        let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
        thirdPartyLogin(credential)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {}
    
    
}
