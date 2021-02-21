//
//  StartupTaskGroup.swift
//  MNWeibo
//
//  Created by scwang on 2021/1/27.
//  Copyright © 2021 miniLV. All rights reserved.
//

import Foundation

protocol StartupTaskProtocol {
    func startTask(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
}

class StartupTaskGroup {
    static var tasks = registerTasks()

    private class func registerTasks() -> Array<StartupTaskProtocol> {
        let allTasks: Array<StartupTaskProtocol> = [
            FetchAppInfoTask(),
            WeiboSDKTask(),
            RouteRegisterTask()
        ]

        return allTasks
    }

    class func startAllTasks(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        for task in tasks {
            task.startTask(application, didFinishLaunchingWithOptions: launchOptions)
        }
    }
}
