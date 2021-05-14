//
//  Router.swift
//  SCWeibo
//
//  Created by scwang on 2021/1/27.
//

import UIKit

public let RouterParameterURL = "RouterParameterURL"
public let RouterParameterUserInfo = "RouterParameterUserInfo"

public typealias RouterHandler = (_ routeParameters: [String: Any]?) -> Void

public protocol RouteAble {
    init(routeParams: Dictionary<AnyHashable, Any>)
}

public class Router {
    private static let shared = Router()

    private lazy var routes = [String: RouteModel]()

    public class func register(urlPattern: String,
                               pageClass: RouteAble.Type? = nil,
                               routeHandler: RouterHandler? = nil) {
        shared.add(urlPattern: urlPattern, pageClass: pageClass, routeHandler: routeHandler)
    }

    public class func deregister(_ urlPattern: String) {
        shared.remove(urlPattern)
    }

    public class func open(url: String,
                           userInfo: [String: Any]? = nil) {
        shared.open(url: url, userInfo: userInfo)
    }

    public class func canOpen(url: String) -> Bool {
        return shared.canOpen(url: url)
    }
}

private extension Router {
    func add(urlPattern: String,
             pageClass: RouteAble.Type?,
             routeHandler: RouterHandler?) {
        if pageClass == nil && routeHandler == nil {
            return
        }
        guard let urlHost = URL(string: urlPattern)?.host else {
            return
        }

        routes[urlHost] = RouteModel(pageClass: pageClass, routeHandler: routeHandler)
    }

    func remove(_ urlPattern: String) {
        guard let urlHost = URL(string: urlPattern)?.host else {
            return
        }
        routes.removeValue(forKey: urlHost)
    }

    func canOpen(url: String) -> Bool {
        guard let urlHost = URL(string: url)?.host else {
            return false
        }
        return routes[urlHost] != nil
    }

    func open(url: String,
              userInfo: [String: Any]? = nil) {
        guard let surl = URLComponents(string: url),
              let urlHost = surl.host,
              let routeModel = routes[urlHost] else {
            return
        }

        var routeUserInfo = userInfo ?? [String: Any]()
        if let queryItems = surl.queryItems {
            for item in queryItems {
                routeUserInfo[item.name] = item.value
            }
        }

        var routeParams = [String: Any]()
        routeParams[RouterParameterURL] = url
        routeParams[RouterParameterUserInfo] = routeUserInfo

        if let routeHandler = routeModel.routeHandler {
            routeHandler(routeParams)
        } else if let pageClass = routeModel.pageClass {
            let viewController = pageClass.init(routeParams: routeParams)

            if let viewController = viewController as? UIViewController,
               let nav = ResponderHelper.baseNavigationController() {
                nav.pushViewController(viewController, animated: true)
            }
        }
    }
}

private class RouteModel {
    var pageClass: RouteAble.Type?
    var routeHandler: RouterHandler?

    init(pageClass: RouteAble.Type? = nil, routeHandler: RouterHandler? = nil) {
        self.pageClass = pageClass
        self.routeHandler = routeHandler
    }
}
