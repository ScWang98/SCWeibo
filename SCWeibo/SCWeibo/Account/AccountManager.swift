//
//  AccountManager.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/21.
//

import Alamofire
import Foundation

class AccountManager: NSObject {
    static let shared = AccountManager()

    var accessToken: String?
    var userId: String?
    var expirationDate: Date?
    var user: UserResponse?

    var isLogin: Bool {
        return accessToken != nil
    }

    override private init() {
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
            assert(false, "dict无效")
            return
        }

        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
              let url = accountFilePathURL(with: "userInfo.json") else {
            return
        }

        DispatchQueue.global().async {
            try? data.write(to: url)
        }
    }

    func loadAccountInfo() {
        guard let pathURL = accountFilePathURL(with: "userInfo.json"),
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

        accessToken = dict.sc.string(for: "accessToken")
        userId = dict.sc.string(for: "userId")
        self.expirationDate = expirationDate

        if let userPathURL = accountFilePathURL(with: "userInfoResponse.json"),
           let userData = try? Data(contentsOf: userPathURL) {
            user = try? JSONDecoder().decode(UserResponse.self, from: userData)
        }
        
        fetchUserInfo()
    }

    func fetchUserInfo() {
        let URLString = URLSettings.userInfoURL

        var params = [String: Any]()
        params["uid"] = userId
        params["access_token"] = self.accessToken
        AF.request(URLString, method: .get, parameters: params, encoding: URLEncoding.default).responseJSON { response in
            var jsonResult: Dictionary<AnyHashable, Any>?
            switch response.result {
            case let .success(json):
                if let dict = json as? Dictionary<AnyHashable, Any> {
                    jsonResult = dict
                }
            case .failure:
                jsonResult = nil
            }

            var userResult: UserResponse?
            if let user = jsonResult {
                userResult = UserResponse.decode(user)
            }
            
            guard let user = userResult else {
                return
            }
            guard let userId = user.id, String(userId) == self.userId else {
                return
            }

            self.user = user
            
            // 以下的 try? JSONEncoder().encode(user) 若放在guard内，则会encode失败，原因未知，非常迷惑
            let userData = try? JSONEncoder().encode(user)
            guard let data = userData,
                  let url = self.accountFilePathURL(with: "userInfoResponse.json") else {
                return
            }

            DispatchQueue.global().async {
                do {
                    try data.write(to: url)
                } catch {
                    print(error)
                }
                
            }
        }
    }

    func accountFilePathURL(with component: String) -> URL? {
        guard let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            return nil
        }
        var url = URL(fileURLWithPath: dir)
        url.appendPathComponent(component)
        return url
    }
    
    func ttttq() -> Data? {
        return nil
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
            accessToken = authResponse.accessToken
            userId = authResponse.userID
            expirationDate = authResponse.expirationDate
            saveAccountInfo()
            fetchUserInfo()

            // post noti dismiss authView
            NotificationCenter.default.post(name: NSNotification.Name(MNUserLoginSuccessNotification), object: nil)
        }
    }
}
