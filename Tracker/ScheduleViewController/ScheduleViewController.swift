//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Aliaksandr Charnyshou on 05.10.2024.
//

import UIKit
import SwiftUI

// MARK: - Preview
struct ScheduleViewControllerPreview: PreviewProvider {
    static var previews: some View {
        ScheduleViewController().showPreview()
    }
}

// MARK: - Constants
private enum Constants {
    static let numberOfRowsInSection: Int = 7
}

final class ScheduleViewController: UIViewController {

    weak var sheduleDelegate: ScheduleProtocol?
    var selectedDays: Set<WeekDays> = []

    private var tableView = UITableView()
    private let saveButton = UIButton()

    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Расписание"
        navigationItem.hidesBackButton = true
        view.backgroundColor = .trackerWhite

        setupSaveButton()
        setupTableView()
    }

    // MARK: - IBAction
    @objc
    private func didTapSaveButton() {
        navigationController?.popViewController(animated: true)
        sheduleDelegate?.saveSelectedDays(selectedDays: selectedDays)

    }

    @objc
    private func switchChanged(_ sender: UISwitch) {
        guard let weekDay = WeekDays(rawValue: sender.tag + 1) else { return }
        if sender.isOn {
            selectedDays.insert(weekDay)
        } else {
            selectedDays.remove(weekDay)
        }
    }

    // MARK: - Private Methods
    private func setupSaveButton() {
        saveButton.setTitle("Готово", for: .normal)
        saveButton.backgroundColor = .trackerBlack
        saveButton.layer.cornerRadius = 16
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)

        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(ScheduleTableCell.self, forCellReuseIdentifier: ScheduleTableCell.identifier)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.tableHeaderView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.heightAnchor.constraint(equalToConstant: 525),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func configureCell(cell: ScheduleTableCell, cellForRowAt indexPath: IndexPath) {
        guard let weekDay = WeekDays(rawValue: indexPath.row + 1) else { return }
        cell.textLabel?.text = weekDay.name
        cell.prepareForReuse()
        cell.configButton(with: indexPath.row, action: #selector(switchChanged(_:)), controller: self)

        let lastCell = indexPath.row == Constants.numberOfRowsInSection - 1
        let firstCell = indexPath.row == Constants.numberOfRowsInSection - 7

        if lastCell {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.layer.cornerRadius = 16
        } else if firstCell {
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.layer.cornerRadius = 16
        }

        if selectedDays.contains(weekDay) {
            cell.setOn()
        }
    }
}

//MARK: - DataSource
extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.numberOfRowsInSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableCell.identifier, for: indexPath) as? ScheduleTableCell else {
            return UITableViewCell()
        }
        configureCell(cell: cell, cellForRowAt: indexPath)
        return cell
    }
}

//MARK: - Delegate
extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
