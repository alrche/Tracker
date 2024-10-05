//
//  CreationTrackerDelegate.swift
//  Tracker
//
//  Created by Aliaksandr Charnyshou on 05.10.2024.
//

import Foundation

protocol CreationTrackerDelegate: AnyObject {
    func createTracker(tracker: Tracker, category: String)
}
