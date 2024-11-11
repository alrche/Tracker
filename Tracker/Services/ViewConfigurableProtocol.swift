//
//  ViewConfigurableProtocol.swift
//  Tracker
//
//  Created by Aliaksandr Charnyshou on 02.11.2024.
//

import UIKit

protocol ViewConfigurable {
    func addSubviews()
    func addConstraints()
    func configureView()
}


extension ViewConfigurable where Self: UIViewController {
    func configureView() {
        addSubviews()
        addConstraints()
    }
}
