//
//  WeiboSDKTask.swift
//  MNWeibo
//
//  Created by scwang on 2021/1/27.
//  Copyright © 2021 miniLV. All rights reserved.
//

import UIKit

class WeiboSDKTask: StartupTaskProtocol {
    func startTask(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // setup WeiboSDK
        WeiboSDK.enableDebugMode(true)
        WeiboSDK.registerApp(MNAppKey, universalLink: "https://myappapi.fun/")

//        AFNetworkActivityIndicatorManager.shared().isEnabled = true

        // Authorization allowed(.alert, .sound, .badge)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge, .carPlay]) { _, _ in
            // print("授权" + (success ? "成功" : "失败"))
        }
    }
}
