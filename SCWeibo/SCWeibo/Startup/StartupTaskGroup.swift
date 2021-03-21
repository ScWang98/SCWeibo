//
//  StartupTaskGroup.swift
//  SCWeibo
//
//  Created by scwang on 2021/1/27.
//

import UIKit

protocol StartupTaskProtocol {
    func startTask(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
}

class StartupTaskGroup {
    class var tasks: Array<StartupTaskProtocol> {
        var allTasks = [StartupTaskProtocol]()
        
        allTasks.append(FetchAppInfoTask())
        allTasks.append(WeiboSDKTask())
        allTasks.append(RouteRegisterTask())

        return allTasks
    }

    class func startAllTasks(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        for task in tasks {
            task.startTask(application, didFinishLaunchingWithOptions: launchOptions)
        }
    }
}
