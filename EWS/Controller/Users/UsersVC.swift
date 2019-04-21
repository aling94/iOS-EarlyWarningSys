//
//  UsersVC.swift
//  EWS
//
//  Created by Alvin Ling on 4/9/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit
import SVProgressHUD
import TWMessageBarManager

class UsersVC: BaseVC {

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var notice: UILabel!
    
    var userList: [UserInfo] = [] {
        didSet {
            DispatchQueue.main.async {
                self.notice.isHidden = !self.userList.isEmpty
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navbarIsHidden = true
        notice.isHidden = true
        getUsers()
    }
    
    func getUsers() {
        SVProgressHUD.show()
        let uid = FirebaseManager.shared.currentUser?.uid
        FirebaseManager.shared.getUsers([uid!]) { (users) in
            if let users = users {
                self.userList = users.sorted(by: <)
                DispatchQueue.main.async { self.table?.reloadData() }
            }
            DispatchQueue.main.async { SVProgressHUD.dismiss() }
        }
    }
    
    func setCellSelector(_ cell: UserCell, indexPath: IndexPath) {
        cell.addFriendBtn.tag = indexPath.row
        cell.addFriendBtn.addTarget(self, action: #selector(addFriend), for: .touchUpInside)
    }
    
    @objc func addFriend(sender: UIButton) {
        let user = userList[sender.tag]
        FirebaseManager.shared.addFriend(user.uid) { error in
            if let error = error {
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Oops!", description: error.localizedDescription, type: .error)
            } else {
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Success!", description: "You've added \(user.name) as a friend!", type: .success)
            }
        }
    }
}

extension UsersVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UserCell
        cell.set(userList[indexPath.item])
        setCellSelector(cell, indexPath: indexPath)
        return cell
    }
}
