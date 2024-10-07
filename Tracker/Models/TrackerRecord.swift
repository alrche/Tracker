//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Aliaksandr Charnyshou on 05.10.2024.
//

import Foundation

struct TrackerRecord {
    let id: UUID
    let date: Date

    init(id: UUID, date: Date) {
        self.id = id
        self.date = date
    }
}
