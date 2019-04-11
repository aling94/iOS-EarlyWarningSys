//
//  FriendsVC.swift
//  EWS
//
//  Created by Alvin Ling on 4/11/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit
import SVProgressHUD
import TWMessageBarManager

class FriendsVC: UsersVC {
    
    override func getUsers() {
        SVProgressHUD.show()
        FirebaseManager.shared.getFriends { (friends) in
            if let friends = friends { self.userList = friends }
            else { self.userList = [] }
            SVProgressHUD.dismiss()
        }
    }
    
    override func setCell(_ cell: UserCell, indexPath: IndexPath) {
        let user = userList[indexPath.item]
        if let image = user.image { cell.userImage.image = image}
        cell.nameLabel.text = "\(user.fname) \(user.lname)"
        cell.deleteFriendBtn.tag = indexPath.item
        cell.deleteFriendBtn.addTarget(self, action: #selector(deleteFriend), for: .touchUpInside)
    }
    
    @objc func deleteFriend(sender: UIButton) {
        let user = userList[sender.tag].uid
        FirebaseManager.shared.removeFriend(user) { (error) in
            if let error = error {
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Oops!", description: error.localizedDescription, type: .error)
            } else {
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Success!", description: "You've lost a friend!", type: .success)
                DispatchQueue.main.async {
                    self.getUsers()
                }
            }
        }
    }
    
    
}
