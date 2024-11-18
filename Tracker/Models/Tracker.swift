//
//  Tracker.swift
//  Tracker
//
//  Created by Aliaksandr Charnyshou on 05.10.2024.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: Set<WeekDays>
    let isPinned: Bool

    init(name: String, color: UIColor, emoji: String, schedule: Set<WeekDays>, isPinned: Bool) {
        self.id = UUID()
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
        self.isPinned = isPinned
        }

    init(id: UUID, name: String, color: UIColor, emoji: String, schedule: Set<WeekDays>, isPinned: Bool) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
        self.isPinned = isPinned
        }
}
