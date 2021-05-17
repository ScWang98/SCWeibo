//
//  UserCommonActionManager.swift
//  SCWeibo
//
//  Created by 王书超 on 2021/5/17.
//

import Alamofire
import Foundation

class UserCommonActionManager {
}

extension UserCommonActionManager {
    class func sendFollowAction(follow: Bool, userId: Int, completion: ((_ success: Bool) -> Void)?) {
        ApiConfigService.getApiConfig { _, st, _ in
            self.postFollow(follow: follow, userId: userId, st: st, completion: completion)
        }
    }

    private class func postFollow(follow: Bool, userId: Int, st: String, completion: ((_ success: Bool) -> Void)?) {
        let URLString = follow ? URLSettings.followUser : URLSettings.unFollowUser

        var params = [String: Any]()
        params["uid"] = userId
        params["st"] = st

        AF.request(URLString, method: .post, parameters: params, encoding: URLEncoding.httpBody).responseJSON { response in
            var jsonResult: Dictionary<AnyHashable, Any>?
            switch response.result {
            case let .success(json):
                if let dict = json as? Dictionary<AnyHashable, Any> {
                    jsonResult = dict
                }
            case .failure:
                jsonResult = nil
            }

            if jsonResult?.sc.string(for: "ok") != "1" {
                completion?(false)
            }
            completion?(true)
        }
    }
}
