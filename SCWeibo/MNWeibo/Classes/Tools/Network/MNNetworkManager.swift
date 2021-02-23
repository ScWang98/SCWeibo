//
//  MNNetworkManager.swift
//  MNWeibo
//
//  Created by miniLV on 2020/3/15.
//  Copyright © 2020 miniLV. All rights reserved.
//

import Alamofire
import UIKit

enum RequestMethod {
    case GET
    case POST
}

class MNNetworkManager {
    static let shared: MNNetworkManager = {
        let instance = MNNetworkManager()
        return instance
    }()

    // user account info
    lazy var userAccount = MNUserAccount()

    var isLogin: Bool {
        return userAccount.access_token != nil
    }

    func request(method: RequestMethod = .GET, URLString: String, parameters: [String: AnyObject]?, completion: @escaping (_ isSuccess: Bool, _ json: Any?) -> Void) {
        var httpMethod: HTTPMethod
        switch method {
        case .GET:
            httpMethod = .get

        case .POST:
            httpMethod = .post
        }

        AF.request(URLString, method: httpMethod, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case let .success(json):
                completion(true, json)

            case let .failure(error):
                print("Request error ==> \(error)")
                completion(false, nil)
            }
        }
    }

    func tokenRequest(method: RequestMethod = .GET, URLString: String, parameters: [String: AnyObject]?, completion: @escaping (_ isSuccess: Bool, _ json: Any?) -> Void) {
        guard let token = userAccount.access_token else {
            print("token is nil, need to login")
            NotificationCenter.default.post(name: Notification.Name(MNUserShouldLoginNotification), object: nil)
            completion(false, nil)
            return
        }

        var parameters = parameters
        if parameters == nil {
            parameters = [String: AnyObject]()
        }
        // at this time, parameters must be valuable
        parameters!["access_token"] = token as AnyObject
        request(method: method, URLString: URLString, parameters: parameters, completion: completion)
    }
}
