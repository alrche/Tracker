//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Aliaksandr Charnyshou on 02.11.2024.
//

import Foundation

typealias Binding<T> = (T) -> Void

final class CategoryViewModel {
    let title: String
    let trackers: [Tracker]

    var titleBinding: Binding<String>? {
        didSet {
            titleBinding?(title)
        }
    }

    var trackersBinding: Binding<[Tracker]>? {
        didSet {
            trackersBinding?(trackers)
        }
    }

    // MARK: - Initializers
    init(title: String, trackers: [Tracker]) {
        self.title = title
        self.trackers = trackers
    }
}
