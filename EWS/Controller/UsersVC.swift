//
//  UsersVC.swift
//  EWS
//
//  Created by Alvin Ling on 4/9/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit

class UsersVC: UIViewController {

    @IBOutlet weak var collection: UICollectionView!
    
    var users: [UserInfo] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collection.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func getUsers() {
        FirebaseManager.shared.getUsers { (users) in
            self.users = users
        }
    }
}

extension UsersVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
}
