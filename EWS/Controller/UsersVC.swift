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

class UsersVC: UIViewController {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var userList: [UserInfo] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collection.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavBarClear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navbarIsHidden = true
        getUsers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    func getUsers() {
        SVProgressHUD.show()
        let uid = FirebaseManager.shared.currentUser?.uid
        FirebaseManager.shared.getUsers([uid!]) { (users) in
            if let users = users { self.userList = users.sorted(by: <) }
            DispatchQueue.main.async { SVProgressHUD.dismiss() }
        }
    }
    
    func setCell(_ cell: UserCell, indexPath: IndexPath) {
        let user = userList[indexPath.item]
        cell.userImage.image = user.image ?? UIImage(named: "default-user")
        cell.nameLabel.text = user.name
        cell.addFriendBtn.tag = indexPath.item
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

extension UsersVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! UserCell
        setCell(cell, indexPath: indexPath)
        return cell
    }
}

extension UsersVC: UISearchBarDelegate {
    func setupSeachBar() {
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.black
            textfield.backgroundColor = UIColor.white
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
