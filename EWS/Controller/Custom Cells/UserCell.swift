//
//  UserCell.swift
//  EWS
//
//  Created by Alvin Ling on 4/9/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    @IBOutlet weak var userImage: CircleImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var addFriendBtn: UIButton!
    @IBOutlet weak var deleteFriendBtn: UIButton!
    
    func set(_ data: UserInfo) {
        userImage.image = data.image ?? UIImage(named: "default-user")
        nameLabel.text = data.name
    }
}
