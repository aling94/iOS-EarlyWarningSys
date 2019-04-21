//
//  SignupVC.swift
//  EWS
//
//  Created by Alvin Ling on 4/8/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit
import Eureka
import CoreLocation
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class SignupVC: FormVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SIGN UP"
    }
    
    var spacer: SpaceCellRow {
        return spacer(gapSize: 10)
    }
    
    override func setupForm() {
        form
        +++ Section()
        <<< email()
        <<< spacer
        <<< password()
        <<< spacer
        <<< confirmPass()
        <<< spacer
        <<< name("fname", "FIRST NAME", "First name required.")
        <<< spacer
        <<< name("lname", "LAST NAME", "Last name required.")
        <<< spacer
        <<< phone()
        <<< spacer
        <<< birthdate()
        <<< gender()
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        guard app.hasAllowedCoreLocation else {
            showAlert(title: "Ooops", msg: "This app requires access to your location. Please allow it.")
            app.requestLocation()
            return
        }
        
        let errors = form.validate()
        if !errors.isEmpty {
            let msgs = errors.map( {$0.msg} )
            showAlert(title: "Oops", msg: msgs.joined(separator: "\n\n"))
        } else { registerToDB() }
    }
    
    func registerToDB() {
        guard let coords = app.currentLocation?.coordinate, let locName = app.locationName else {
            showAlert(title: "Ooops", msg: "Error in retrieving location. Please restart or try again.")
            return
        }
        var info = infoDict
        info["latitude"] = coords.latitude
        info["longitude"] = coords.longitude
        info["location"] = locName
        
        let email = info["email"] as! String
        let passw = info["pass"] as! String
        info.removeValue(forKey: "pass")
        info.removeValue(forKey: "cpass")
        
        SVProgressHUD.show()
        FirebaseManager.shared.registerUser(email: email, passw: passw, info: info) { (result, error) in
            if let _ = result?.user {
                self.loginUser(email, passw)
            } else {
                SVProgressHUD.dismiss()
                self.alertError(error)
            }
        }
    }
    
    func loginUser(_ email: String, _ passw: String) {
        FirebaseManager.shared.loginUser(email: email, passw: passw) { error in
            if error == nil {
                DispatchQueue.main.async {
                    let vc = self.getVC(identifier: "Tabs")
                    self.present(vc!, animated: true, completion: nil)
                }
            } else {
                SVProgressHUD.dismiss()
                self.alertError(error)
            }
        }
    }
}
