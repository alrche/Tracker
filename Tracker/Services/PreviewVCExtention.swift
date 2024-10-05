//
//  PreviewVCExtention.swift
//  Tracker
//
//  Created by Aliaksandr Charnyshou on 05.10.2024.
//

import SwiftUI

extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> some UIViewController {
            viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }

    func showPreview() -> some View {
        Preview(viewController: self).edgesIgnoringSafeArea(.all)
    }
}
