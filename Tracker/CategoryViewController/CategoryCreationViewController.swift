//
//  CategoryCreationViewController.swift
//  Tracker
//
//  Created by Aliaksandr Charnyshou on 02.11.2024.
//

import UIKit

final class CategoryCreationViewController: UIViewController, ViewConfigurable {

    var saveButtonCanBePressed: Bool? {
        didSet {
            let isEnabled = saveButtonCanBePressed ?? false
            saveButton.backgroundColor = isEnabled ? .trackerBlack : .trackerGray
            saveButton.setTitleColor(isEnabled ? .trackerWhite : .white, for: .normal)
            saveButton.isEnabled = isEnabled
        }
    }

    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("done", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .trackerGray
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var categoryNameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 16
        textField.backgroundColor = .trackerBackground
        textField.placeholder = NSLocalizedString("category.enterTitle", comment: "")
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.setLeftPaddingPoints(12)
        textField.clearButtonMode = .whileEditing
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingDidEnd)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let trackerCategoryStore = TrackerCategoryStore()

    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("category.new", comment: "")
        navigationItem.hidesBackButton = true
        view.backgroundColor = .trackerWhite

        configureView()
        setupHideKeyboardGesture()
    }

    // MARK: - ViewConfigurable Methods
    func addSubviews() {
        let subViews = [saveButton, categoryNameTextField]
        subViews.forEach { view.addSubview($0) }
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            saveButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

            categoryNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoryNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryNameTextField.heightAnchor.constraint(equalToConstant: 75)
        ])
    }

    // MARK: - Private Methods
    @objc
    private func saveButtonTapped() {
        guard let text = categoryNameTextField.text else { return }
        createNewCategory(categoryName: text)
        navigationController?.popViewController(animated: true)
    }

    private func setupHideKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }

    @objc
    private func textFieldEditingChanged(_ textField: UITextField) {
        guard let text = categoryNameTextField.text else { return }
        if text.isEmpty {
            saveButtonCanBePressed = false
        } else {
            saveButtonCanBePressed = true
        }
    }

    private func createNewCategory(categoryName: String) {
        try? trackerCategoryStore.addNewCategory(name: categoryName)
    }
}
