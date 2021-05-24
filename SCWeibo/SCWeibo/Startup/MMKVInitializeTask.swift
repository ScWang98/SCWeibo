//
//  MMKVInitializeTask.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/5/25.
//

import Foundation
import MMKV

class MMKVInitializeTask: StartupTaskProtocol {
    func startTask(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        MMKV.initialize(rootDir: nil)
    }
}
