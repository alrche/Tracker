//
//  PlaceHolderView.swift
//  Tracker
//
//  Created by Aliaksandr Charnyshou on 05.10.2024.
//

import UIKit

final class PlaceHolderView: UIView {

    private let imageView = UIImageView()
    private var label = UILabel()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    func setupNoTrackersState() {
        imageView.image = UIImage(named: "tracker_placeholder")
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
    }

    func setupNoSearchResultsState() {
        imageView.image = UIImage(named: "tracker_not_found")
        label.text = "Ничего не найдено"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
    }

    func setupNoStatisticState() {
        imageView.image = UIImage(named: "statistic_placeholder")
        label.text = "Анализировать пока нечего"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
    }

    // MARK: - Private Methods
    private func setupView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 223),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])

        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 18),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
