//
//  RouteRegisterTask.swift
//  MNWeibo
//
//  Created by scwang on 2021/1/27.
//  Copyright © 2021 miniLV. All rights reserved.
//

import Foundation

class RouteRegisterTask: StartupTaskProtocol {
    func startTask(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        RouteManager.shared.register(pageClass: MNWriteController.self, for: "test")
    }
}
