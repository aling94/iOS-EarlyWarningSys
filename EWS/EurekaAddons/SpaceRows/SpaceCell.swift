//
//  SpaceCell.swift
//  EWS
//
//  Created by Alvin Ling on 4/18/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import UIKit
import Eureka

class SpaceCell: Cell<String>, CellType {

    @IBOutlet weak var space: UIView!
    
    var spaceHeight: CGFloat = 1.0
    
    var isInfinite: Bool = false {
        didSet { self.clipsToBounds = !isInfinite }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        selectionStyle = .none
    }
    
    override var backgroundColor: UIColor? {
        didSet {
            space.backgroundColor = backgroundColor
        }
    }
    
    override func setup() {
        super.setup()
        self.height = { [weak self] in
            guard let cell = self else { return 1 }
            assert(cell.spaceHeight >= 0.1)
            return cell.spaceHeight + 1.0
        }
    }
}
