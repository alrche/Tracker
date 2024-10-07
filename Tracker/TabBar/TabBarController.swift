//
//  TabBarController.swift
//  Tracker
//
//  Created by Aliaksandr Charnyshou on 05.10.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
    }

    private func generateTabBar() {
        let navigationViewController = UINavigationController(rootViewController: TrackerViewController())
        tabBar.tintColor = .trackerBlue
        tabBar.unselectedItemTintColor = .trackerGray
        viewControllers = [
            generateVC(viewController: navigationViewController,
                       title: "Трекеры",
                       image: UIImage(named: "tracker_icon")
                      ),
            generateVC(viewController: StatisticViewController(),
                       title: "Статистика",
                       image: UIImage(named: "statistic_icon")
                      )
        ]
    }

    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image

        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .medium)]
        viewController.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
        viewController.tabBarItem.setTitleTextAttributes(attributes, for: .selected)

        return viewController
    }
}
