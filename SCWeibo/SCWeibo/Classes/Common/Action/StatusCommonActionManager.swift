//
//  StatusCommonActionManager.swift
//  SCWeibo
//
//  Created by 王书超 on 2021/5/17.
//

import Alamofire
import Foundation

class StatusCommonActionManager {
}

extension StatusCommonActionManager {
    class func sendFavoriteAction(statusId: Int, favorited: Bool, completion: ((_ success: Bool) -> Void)?) {
        ApiConfigService.getApiConfig { _, st, _ in
            self.postFavorite(favorited: favorited, statusId: statusId, st: st, completion: completion)
        }
    }

    private class func postFavorite(favorited: Bool, statusId: Int, st: String, completion: ((_ success: Bool) -> Void)?) {
        let URLString = favorited ? URLSettings.favoriteCreate : URLSettings.favoriteDestroy

        var params = [String: Any]()
        params["id"] = statusId
        params["st"] = st

        var headers = HTTPHeaders()
        headers.add(HTTPHeader(name: "referer", value: "https://m.weibo.cn/"))
        AF.request(URLString, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: headers).responseJSON { response in
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

    class func sendDeleteAction(statusId: Int, userId: Int, completion: ((_ success: Bool) -> Void)?) {
        guard userId == AccountManager.shared.user?.id else {
            return
        }
        ApiConfigService.getApiConfig { _, st, _ in
            self.postDeleteAction(statusId: statusId, userId: userId, st: st, completion: completion)
        }
    }

    class func postDeleteAction(statusId: Int, userId: Int, st: String, completion: ((_ success: Bool) -> Void)?) {
        let URLString = URLSettings.deleteStatus

        var params = [String: Any]()
        params["mid"] = statusId
        params["st"] = st

        var headers = HTTPHeaders()
        headers.add(HTTPHeader(name: "referer", value: "https://m.weibo.cn/profile/" + String(userId)))
        AF.request(URLString, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers: headers).responseJSON { response in
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
