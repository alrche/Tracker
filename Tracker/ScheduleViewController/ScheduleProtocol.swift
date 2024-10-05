//
//  ScheduleProtocol.swift
//  Tracker
//
//  Created by Aliaksandr Charnyshou on 05.10.2024.
//

import Foundation

protocol ScheduleProtocol: AnyObject {
    func saveSelectedDays(selectedDays: Set<WeekDays>)
}
