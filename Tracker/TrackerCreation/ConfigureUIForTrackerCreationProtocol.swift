//
//  ConfigureUIForTrackerCreationProtocol.swift
//  Tracker
//
//  Created by Aliaksandr Charnyshou on 05.10.2024.
//

import Foundation

protocol ConfigureUIForTrackerCreationProtocol: AnyObject {
    func configureButtonsCell(cell: ButtonsCell)
    func setupBackground()
    func calculateTableViewHeight(width: CGFloat) -> CGSize
    func checkIfSaveButtonCanBePressed()
}
