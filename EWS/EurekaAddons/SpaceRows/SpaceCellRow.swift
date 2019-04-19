//
//  SpaceCellRow.swift
//  EWS
//
//  Created by Alvin Ling on 4/18/19.
//  Copyright © 2019 iOSPlayground. All rights reserved.
//

import Foundation
import Eureka

final class SpaceCellRow: Row<SpaceCell>, RowType {
    
    required init(tag: String?) {
        super.init(tag: tag)
        cellProvider = CellProvider<SpaceCell>(nibName: "SpaceCell")
    }
}
