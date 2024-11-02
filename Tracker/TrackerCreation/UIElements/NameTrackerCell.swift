//
//  NameTrackerCell.swift
//  Tracker
//
//  Created by Aliaksandr Charnyshou on 05.10.2024.
//

import UIKit

protocol SaveNameTrackerDelegate: AnyObject {
    func textFieldWasChanged(text: String)
}

final class NameTrackerCell: UICollectionViewCell, ViewConfigurable {

    static let identifier = "TrackerNameTextFieldCell"

    weak var delegate: SaveNameTrackerDelegate?

    private lazy var trackerNameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 16
        textField.backgroundColor = .trackerBackground
        textField.placeholder = "Введите название трекера"
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.setLeftPaddingPoints(12)
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let xButton = UIButton(type: .custom)

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureView()
        setupHideKeyboardGesture()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - IBAction
    @objc
    func textFieldEditingChanged(_ textField: UITextField) {
        guard let text = trackerNameTextField.text else { return }
        delegate?.textFieldWasChanged(text: text)
    }

    // MARK: - ViewConfigurable Methods
    func addSubviews() {
        contentView.addSubview(trackerNameTextField)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            trackerNameTextField.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            trackerNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trackerNameTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func configureView() {
        addSubviews()
        addConstraints()
    }

    // MARK: - Private Methods
    private func setupHideKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        contentView.addGestureRecognizer(tapGesture)
    }

    @objc private func hideKeyboard() {
        contentView.endEditing(true)
    }
}
