//
//  ResponderHelper.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/3.
//

import UIKit

class ResponderHelper {
    static func topViewController(for responder: UIResponder) -> UIViewController? {
        var topResponder: UIResponder? = responder
        while topResponder != nil && !(topResponder is UIViewController) {
            topResponder = topResponder?.next
        }

        if topResponder == nil {
            topResponder = UIApplication.shared.delegate?.window??.rootViewController
        }

        if let result = topResponder as? UIViewController {
            return result
        }
        return nil
    }

    static func correctTopViewController(for responder: UIResponder) -> UIViewController? {
        var topResponder: UIResponder? = responder
        while topResponder != nil {
            if var viewController = topResponder as? UIViewController? {
                while viewController?.parent != nil &&
                      viewController?.parent != viewController?.navigationController &&
                      viewController?.parent != viewController?.tabBarController {
                    viewController = viewController?.parent
                }
                return viewController
            }
            topResponder = topResponder?.next
        }
        if topResponder == nil {
            topResponder = UIApplication.shared.delegate?.window??.rootViewController
        }

        if let result = topResponder as? UIViewController {
            return result
        }
        return nil
    }

    static func visibleTopViewController() -> UIViewController? {
        var viewController = _visibleTopViewController(viewController: UIApplication.shared.sc.keyWindow?.rootViewController)
        while viewController?.presentationController != nil {
            viewController = _visibleTopViewController(viewController: viewController?.presentedViewController)
        }

        return viewController
    }

    static func baseNavigationController() -> UINavigationController? {
        let viewController = UIApplication.shared.sc.keyWindow?.rootViewController
        if let navController = viewController as? UINavigationController {
            return navController
        }
        if let tabBarController = viewController as? UITabBarController {
            if let navController = tabBarController.selectedViewController as? UINavigationController {
                return navController
            }
        }

        assert(false, "Can't find navigationController from rootVC")
        return nil
    }
}

private extension ResponderHelper {
    static func _visibleTopViewController(viewController: UIViewController?) -> UIViewController? {
        if let navigationController = viewController as? UINavigationController {
            return _visibleTopViewController(viewController: navigationController.topViewController)
        } else if let tabBarController = viewController as? UITabBarController {
            return _visibleTopViewController(viewController: tabBarController.selectedViewController)
        }

        return viewController
    }
}
