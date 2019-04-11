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
        setupSeachBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUsers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    func getUsers() {
        SVProgressHUD.show()
        FirebaseManager.shared.getUsers { (users) in
            if let users = users { self.userList = users }
            SVProgressHUD.dismiss()
        }
    }
    
    func setCell(_ cell: UserCell, indexPath: IndexPath) {
        let user = userList[indexPath.item]
        if let image = user.image { cell.userImage.image = image}
        cell.nameLabel.text = "\(user.fname) \(user.lname)"
        cell.addFriendBtn.tag = indexPath.item
        cell.addFriendBtn.addTarget(self, action: #selector(addFriend), for: .touchUpInside)
    }
    
    @objc func addFriend(sender: UIButton) {
        let user = userList[sender.tag]
        FirebaseManager.shared.addFriend(user.uid) { error in
            if let error = error {
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Oops!", description: error.localizedDescription, type: .error)
            } else {
                TWMessageBarManager.sharedInstance().showMessage(withTitle: "Success!", description: "You've added \(user.fname) as a friend!", type: .success)
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
