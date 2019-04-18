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
            if let friends = friends { self.userList = friends.sorted(by: <) }
            else { self.userList = [] }
            SVProgressHUD.dismiss()
        }
    }

    override func setCell(_ cell: UserCell, indexPath: IndexPath) {
        let user = userList[indexPath.item]
        cell.userImage.image = user.image ?? UIImage(named: "default-user")
        cell.nameLabel.text = user.name
        cell.deleteFriendBtn.tag = indexPath.item
        cell.deleteFriendBtn.addTarget(self, action: #selector(deleteFriend), for: .touchUpInside)
        cell.chatBtn.tag = indexPath.item
        cell.chatBtn.addTarget(self, action: #selector(showChat), for: .touchUpInside)
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
    
    @objc func showChat(sender: UIButton) {
        let friend = userList[sender.tag]
        let vc = getVC(identifier: "ChatVC") as! ChatVC
        vc.friend = friend
        present(vc, animated: true)
    }
    
    
    @IBAction private func refreshBtn(_ sender: Any) {
        getUsers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! FriendsMapVC
        vc.friendsList = userList
    }
}
