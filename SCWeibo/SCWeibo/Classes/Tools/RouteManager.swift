//
//  RouteManager.swift
//  SCWeibo
//
//  Created by scwang on 2021/1/27.
//

import UIKit

protocol RouteAble {
    init(routeParams: Dictionary<AnyHashable, Any>);
}

class RouteManager {
    static let shared = RouteManager()

    var pages = [String: RouteAble.Type]()

    func register(pageClass: RouteAble.Type, for scheme: String) {
        pages[scheme] = pageClass
    }

    func canOpen(url: URL) -> Bool {
        let scheme = url.host
        guard let schemeStr = scheme else {
            return false
        }
        
        return pages[schemeStr] != nil
    }

    func open(url: URL) {
        open(url: url, params: nil)
    }

    func open(url: URL, params: Dictionary<AnyHashable, Any>?) {
        if !canOpen(url: url) {
            return
        }
        
        var routeParams = Dictionary<AnyHashable, Any>()
        
        if let params = params {
            for item in params {
                routeParams[item.key] = item.value
            }
        }
        
        let urlComp = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        if let queryItems = urlComp?.queryItems {
            for item in queryItems {
                routeParams[item.name] = item.value
            }
        }
        
        guard let host = urlComp?.host, let cls = pages[host] else {
            return
        }
        
        let vc = cls.init(routeParams: routeParams)
        
        guard let viewController = vc as? UIViewController else {
            return
        }
        
        let rootVC = getCurrentViewController()
        
        rootVC?.present(viewController, animated: true, completion: nil)
    }
    
    private func getCurrentViewController(base: UIViewController? = UIApplication.shared.sc.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getCurrentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return getCurrentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return getCurrentViewController(base: presented)
        }
        return base
    }
}
