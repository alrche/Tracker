//
//  ButtonTableViewCell.swift
//  Tracker
//
//  Created by Aliaksandr Charnyshou on 05.10.2024.
//

import UIKit

final class ButtonTableViewCell: UITableViewCell, ViewConfigurable {

    static let identifier = "ButtonTableViewCell"

    let titleLabel = UILabel()

    private let subtitleLabel = UILabel()
    private let stackView = UIStackView()

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureView()
        configureCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ViewConfigurable Methods
    func addSubviews() {
        contentView.addSubview(stackView)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -41),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    // MARK: - Public Methods
    func setupSubtitleLabel(text: String) {
        if text.count > 0 {
            subtitleLabel.text = text
            subtitleLabel.textColor = .trackerGray
            stackView.addArrangedSubview(subtitleLabel)
        } else {
            subtitleLabel.text = ""
            stackView.removeArrangedSubview(subtitleLabel)
        }
    }

    func configureView() {
        addSubviews()
        addConstraints()
    }

    // MARK: - Private Methods
    private func configureCell() {
        backgroundColor = .trackerBackground
        accessoryType = .disclosureIndicator
        layer.masksToBounds = true
        layer.cornerRadius = 16

        setupStackView()
        setupTitleLabel()
//        setupSubtitleLabel(text: "pupa")
    }

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
}
