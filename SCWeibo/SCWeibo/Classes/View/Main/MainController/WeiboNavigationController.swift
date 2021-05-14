//
//  MNNavigationController.swift
//  SCWeibo
//
//  Created by scwang on 2020/3/10.
//

import UIKit

class WeiboNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

//        navigationBar.isHidden = true
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        let fromViewController = viewControllers.last
        let hasTabBar = hasTabBarArchitecture(viewController: fromViewController)

        if hasTabBar {
            fromViewController?.hidesBottomBarWhenPushed = true
            super.pushViewController(viewController, animated: animated)
            fromViewController?.hidesBottomBarWhenPushed = false
        } else {
            super.pushViewController(viewController, animated: animated)
        }
    }
}

private extension WeiboNavigationController {
    func hasTabBarArchitecture(viewController: UIViewController?) -> Bool {
        guard let viewController = viewController,
              let index = viewControllers.firstIndex(of: viewController),
              let contain = tabBarController?.viewControllers?.contains(self) else {
            return false
        }

        return index == 0 && contain
    }
}
