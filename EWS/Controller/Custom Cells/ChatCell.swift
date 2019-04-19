//
//  ChatCell.swift
//  EWS
//
//  Created by Alvin Ling on 4/15/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var friendText: UILabel!
    @IBOutlet weak var senderText: UILabel!

    func setup(wasSent: Bool, message: String) {
        senderText.isHidden = !wasSent
        friendText.isHidden = wasSent
        if wasSent { senderText.text = message }
        else { friendText.text = message }
    }

}
