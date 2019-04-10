//
//  Controllers.swift
//  EWS
//
//  Created by Alvin Ling on 4/8/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit
import Eureka

extension UIViewController {
    
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
        present(alert, animated: true, completion: nil)
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
    
    var alertError: ErrorHandler {
        let handler: ErrorHandler = { error in
            guard let error = error else  { return }
            DispatchQueue.main.async {
                self.showAlert(title: "Oops!", msg: error.localizedDescription)
            }
        }
        return handler
    }
}

extension FormViewController {
    
}
