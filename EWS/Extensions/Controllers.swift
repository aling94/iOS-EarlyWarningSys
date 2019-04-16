//
//  Controllers.swift
//  EWS
//
//  Created by Alvin Ling on 4/8/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit
import Eureka
import GoogleSignIn
import FBSDKLoginKit

extension UIViewController {
    
    var navbarIsHidden: Bool {
        get { return navigationController?.isNavigationBarHidden ?? false }
        set { navigationController?.setNavigationBarHidden(newValue, animated: false) }
    }
    
    var navbarTextColor: UIColor? {
        get { return navigationController?.navigationBar.tintColor }
        set {
            guard let color = newValue else { return }
            navigationController?.navigationBar.tintColor = color
            let textAttributes = [NSAttributedString.Key.foregroundColor : color]
            navigationController?.navigationBar.titleTextAttributes = textAttributes
        }
    }
    
    func makeNavBarClear() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navbarTextColor = .white
    }
    
    func getVC(identifier: String) -> UIViewController? {
        return storyboard?.instantiateViewController(withIdentifier: identifier)
    }
    
    func goToVC(_ vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func gotoVC(identifier: String) {
        goToVC(getVC(identifier: identifier)!)
    }
    
    func showAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func promptInput(title: String, msg: String, placeHolder: String, textAction: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = placeHolder
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            guard let text = alert.textFields?.first?.text else { return }
            textAction(text)
        }
        
        alert.addAction(okAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func alertError(successMsg: String) -> ErrorHandler {
        let handler: ErrorHandler = { error in
            DispatchQueue.main.async {
                let errorMsg = error?.localizedDescription
                if let errorMsg = errorMsg { self.showAlert(title: "Oops!", msg: errorMsg) }
                else { self.showAlert(title: "Success!", msg: successMsg) }
            }
        }
        return handler
    }
    
    var alertError: ErrorHandler {
        let handler: ErrorHandler = { error in
            guard let error = error else  { return }
            DispatchQueue.main.async {
                self.showAlert(title: "Oops!", msg: error.localizedDescription)
            }
        }
        return handler
    }
    
    @IBAction func jumpToLogin() {
        GIDSignIn.sharedInstance().signOut()
        FBSDKLoginManager().logOut()
        FirebaseManager.shared.signoutUser()
        let vc = storyboard?.instantiateInitialViewController()
        app.window?.rootViewController = vc
    }
}

extension FormViewController {
    
    func spacer(gapSize: CGFloat) -> SpaceCellRow {
        return SpaceCellRow {
            $0.cell.spaceHeight = gapSize
            $0.cell.backgroundColor = .clear
        }
    }
    
    func formToDict(tags: [String]) -> [String : Any] {
        var info: [String : Any] = [:]
        for tag in tags {
            let row = form.rowBy(tag: tag)
            if let val = row?.baseValue as? String, !val.isEmpty {
                info[tag] = val
            }
            else if let text = row?.baseCell.textLabel?.text {
                info[tag] = text
            }
        }
        return info
    }
}
