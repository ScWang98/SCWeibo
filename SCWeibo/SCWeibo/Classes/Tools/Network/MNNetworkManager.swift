//
//  MNNetworkManager.swift
//  SCWeibo
//
//  Created by scwang on 2020/3/15.
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
        
        var httpMethod : HTTPMethod
        
        switch method {
        case .GET:
            httpMethod = .get
        case .POST:
            httpMethod = .post
        }
        
        AF.request(URLString, method: httpMethod, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            var isSuccess = false
            var jsonResult : Any?
            switch response.result {
            case .success(let json):
                jsonResult = json
                isSuccess = true
            case .failure( _):
                jsonResult = nil
                isSuccess = false
            }
            
            completion(isSuccess, jsonResult)
        }
    }
}
