//
//  RoundViews.swift
//  EWS
//
//  Created by Alvin Ling on 4/10/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        cornerRadius = frame.height / 2
    }
}

class CircleButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        cornerRadius = frame.height / 2
    }
}
