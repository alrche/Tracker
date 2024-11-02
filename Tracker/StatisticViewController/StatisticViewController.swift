//
//  StatisticViewController.swift
//  Tracker
//
//  Created by Aliaksandr Charnyshou on 05.10.2024.
//

import UIKit
import SwiftUI

// MARK: - Preview
struct StatisticViewControllerPreview: PreviewProvider {
    static var previews: some View {
        StatisticViewController().showPreview()
    }
}

final class StatisticViewController: UIViewController, ViewConfigurable {

    // MARK: - Subviews
    private let titleLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 34)
        label.textColor = .trackerBlack
        label.text = "Статистика"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let image: UIImageView = {
        let imageView = UIImageView()
        if let image = UIImage(named: "statistic_placeholder") {
            imageView.image = image
        }
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let questionLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .trackerBlack
        label.text = "Анализировать пока нечего"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - VC methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trackerWhite
        configureView()
    }

    // MARK: - ViewConfigurable Methods
    func addSubviews() {
        let subViews = [titleLable,image,questionLable]
        subViews.forEach { view.addSubview($0) }
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            titleLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLable.heightAnchor.constraint(equalToConstant: 41),
            titleLable.widthAnchor.constraint(equalToConstant: 254),

            image.topAnchor.constraint(equalTo: view.topAnchor, constant: 375),
            image.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            image.heightAnchor.constraint(equalToConstant: 80),
            image.widthAnchor.constraint(equalToConstant: 80),

            questionLable.topAnchor.constraint(equalTo: view.topAnchor, constant: 463),
            questionLable.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            questionLable.heightAnchor.constraint(equalToConstant: 18),
            questionLable.widthAnchor.constraint(equalToConstant: 343)
        ])
    }
}
