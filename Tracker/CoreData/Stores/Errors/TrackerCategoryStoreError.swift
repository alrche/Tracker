//
//  TrackerCategoryStoreError.swift
//  Tracker
//
//  Created by Aliaksandr Charnyshou on 19.10.2024.
//

import Foundation

enum TrackerCategoryStoreError: Error {
    case decodingTitleError
    case decodingTrackersError
    case addNewTrackerError
    case fetchingCategoryError
}
