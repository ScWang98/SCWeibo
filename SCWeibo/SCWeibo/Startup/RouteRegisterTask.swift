//
//  RouteRegisterTask.swift
//  SCWeibo
//
//  Created by scwang on 2021/1/27.
//

import UIKit

class RouteRegisterTask: StartupTaskProtocol {
    func startTask(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        RouteManager.shared.register(pageClass: MNWriteController.self, for: "test")
        RouteManager.shared.register(pageClass: H5LoginWebViewController.self, for: "h5login")
        RouteManager.shared.register(pageClass: StatusDetailViewController.self, for: "statusDetail")
    }
}
