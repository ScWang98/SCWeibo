//
//  WeiboSDKTask.swift
//  SCWeibo
//
//  Created by scwang on 2021/1/27.
//

import Foundation

class WeiboSDKTask: StartupTaskProtocol {
    func startTask(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // setup WeiboSDK
        WeiboSDK.enableDebugMode(true)
        WeiboSDK.registerApp(MNAppKey, universalLink: "https://myappapi.fun/")

    }
}
