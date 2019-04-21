//
//  PostCell.swift
//  EWS
//
//  Created by Alvin Ling on 4/13/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var userImage: CircleImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentText: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    func set(_ data: PostInfo) {
        nameLabel.text = data.user?.name
        commentText.text = data.description
        userImage.image = data.user?.image ?? UIImage(named: "default-user")
        postImage.image = data.image
    }
}
