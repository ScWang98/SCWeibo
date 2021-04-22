//
//  RouteRegisterTask.swift
//  SCWeibo
//
//  Created by scwang on 2021/1/27.
//

import UIKit

class RouteRegisterTask: StartupTaskProtocol {
    func startTask(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        Router.register(urlPattern: "pillar://h5login", pageClass: H5LoginWebViewController.self)
        Router.register(urlPattern: "pillar://statusDetail", pageClass: StatusDetailViewController.self)
        Router.register(urlPattern: "pillar://webview", pageClass: WebViewController.self)
    }
}
