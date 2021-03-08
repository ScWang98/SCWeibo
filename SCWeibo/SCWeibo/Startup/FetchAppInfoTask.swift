//
//  FetchAppInfoTask.swift
//  SCWeibo
//
//  Created by scwang on 2021/1/27.
//

import UIKit

class FetchAppInfoTask: StartupTaskProtocol {
    func startTask(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        // Simulate a network request
        DispatchQueue.global().async {
            guard let url = Bundle.main.url(forResource: "main.json", withExtension: nil) else {
                print("url is nil")
                return
            }

            let data = NSData(contentsOf: url)

            // write to disk
            let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let jsonPath = (documentDir as NSString).appendingPathComponent("main.json")

            // save to sanbox,next launch app will use it.
            data?.write(toFile: jsonPath, atomically: true)
        }
    }
}
