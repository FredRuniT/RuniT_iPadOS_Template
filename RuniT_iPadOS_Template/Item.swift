//
//  Item.swift
//  RuniT_iPadOS_Template
//
//  Created by Fredrick Burns on 3/12/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
