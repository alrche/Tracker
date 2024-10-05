//
//  ScheduleTableCell.swift
//  Tracker
//
//  Created by Aliaksandr Charnyshou on 05.10.2024.
//

import UIKit

final class ScheduleTableCell: UITableViewCell {

    static let identifier = "ScheduleTableCell"

    private let switchButton = UISwitch(frame: .zero)

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .trackerBackground
        setupSwitch()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    func configButton(with tag: Int, action: Selector, controller: UIViewController) {
        switchButton.tag = tag
        switchButton.addTarget(controller, action: action, for: .valueChanged)
    }

    func setOn() {
        switchButton.setOn(true, animated: true)
    }

    // MARK: - Private Methods
    private func setupSwitch() {
        switchButton.setOn(false, animated: true)
        switchButton.onTintColor = .trackerBlue
        self.accessoryView = switchButton
    }
}
