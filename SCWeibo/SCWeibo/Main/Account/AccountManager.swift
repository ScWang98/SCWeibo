//
//  AccountManager.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/21.
//

import Foundation

class AccountManager: NSObject {
    static let shared = AccountManager()

    var accessToken: String?
    var userId: String?
    var expirationDate: Date?

    var isLogin: Bool {
        return accessToken != nil
    }

    override init() {
        super.init()
        loadAccountInfo()
    }
}

// MARK: - Public Methods

extension AccountManager {
    func handle(url: URL) -> Bool {
        return WeiboSDK.handleOpen(url, delegate: self)
    }
}

// MARK: - Private Methods

private extension AccountManager {
    func saveAccountInfo() {
        var dict = [String: Any]()
        dict["accessToken"] = accessToken
        dict["userId"] = userId
        dict["expirationDate"] = expirationDate?.sc.dateString

        guard JSONSerialization.isValidJSONObject(dict) else {
            print("dict无效")
            return
        }

        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
            let url = accountFilePathURL() else {
            return
        }

        DispatchQueue.global().async {
            try? data.write(to: url)
        }
    }

    func loadAccountInfo() {
        guard let pathURL = accountFilePathURL(),
            let data = try? Data(contentsOf: pathURL),
            let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [AnyHashable: Any] else {
            return
        }

        guard let expirationDateString = dict.sc.string(for: "expirationDate"),
            let expirationDate = Date.sc.date(from: expirationDateString),
            expirationDate.compare(Date()) == .orderedDescending else {
            print("账户过期")
            try? FileManager.default.removeItem(at: pathURL)
            return
        }

        self.accessToken = dict.sc.string(for: "accessToken")
        self.userId = dict.sc.string(for: "userId")
        self.expirationDate = expirationDate
    }

    func accountFilePathURL() -> URL? {
        guard let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return nil
        }
        var url = URL(fileURLWithPath: dir)
        url.appendPathComponent("userInfo.json")
        return url
    }
}

// MARK: - WeiboSDKDelegate

extension AccountManager: WeiboSDKDelegate {
    func didReceiveWeiboRequest(_ request: WBBaseRequest!) {
        print("didReceiveWeiboRequest")
    }

    // 登录成功的回调
    func didReceiveWeiboResponse(_ response: WBBaseResponse!) {
        print("didReceiveWeiboResponse")
        if let authResponse = response as? WBAuthorizeResponse {
            self.accessToken = authResponse.accessToken
            self.userId = authResponse.userID
            self.expirationDate = authResponse.expirationDate
            self.saveAccountInfo()

            // post noti dismiss authView
            NotificationCenter.default.post(name: NSNotification.Name(MNUserLoginSuccessNotification), object: nil)
        }
    }
}
