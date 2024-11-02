//
//  EmojiCell.swift
//  Tracker
//
//  Created by Aliaksandr Charnyshou on 05.10.2024.
//

import UIKit

final class EmojiCell: UICollectionViewCell {

    static let identifier = "EmojiCell"

    lazy var emojiLabel: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()

    override var isSelected: Bool {
        didSet {
            updateBorder()
        }
    }

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)

        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - ViewConfigurable Methods
        func addSubviews() {
           contentView.addSubview(emojiLabel)
       }

        func addConstraints() {
           NSLayoutConstraint.activate([
               emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
               emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
           ])
       }

    func configureView() {
        addSubviews()
        addConstraints()
    }

    // MARK: - Private Methods
    private func updateBorder() {
        self.backgroundColor = self.isSelected ? .trackerLightGrey : .clear
        self.layer.cornerRadius = 16
    }
}
