//
//  TrackerInfoCell.swift
//  Tracker
//
//  Created by Aliaksandr Charnyshou on 05.10.2024.
//

import UIKit

struct TrackerInfoCell {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let daysCount: Int
    let currentDay: Date

    init(id: UUID, name: String, color: UIColor, emoji: String, daysCount: Int, currentDay: Date) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.daysCount = daysCount
        self.currentDay = currentDay
    }
}
