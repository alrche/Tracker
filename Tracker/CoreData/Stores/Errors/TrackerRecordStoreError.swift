//
//  TrackerRecordStoreError.swift
//  Tracker
//
//  Created by Aliaksandr Charnyshou on 19.10.2024.
//

import Foundation

enum TrackerRecordStoreError: Error {
    case decodingTrackerRecordIdError
    case decodingTrackerRecordDateError
    case fetchTrackerRecordError
}
