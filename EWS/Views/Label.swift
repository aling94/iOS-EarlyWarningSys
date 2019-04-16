//
//  Label.swift
//  EWS
//
//  Created by Alvin Ling on 4/16/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit

class Label: UILabel {
    
    @IBInspectable var topPadding: CGFloat = 5.0
    @IBInspectable var botPadding: CGFloat = 5.0
    @IBInspectable var leftPadding: CGFloat = 10.0
    @IBInspectable var rightPadding: CGFloat = 10.0
    
    override func drawText(in rect: CGRect) {
        let padding = UIEdgeInsets.init(top: topPadding, left: leftPadding, bottom: botPadding, right: rightPadding)
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftPadding + rightPadding,
                      height: size.height + topPadding + botPadding)
    }
    
    override func sizeToFit() {
        super.sizeThatFits(intrinsicContentSize)
    }
}
