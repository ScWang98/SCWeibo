//
//  StatusDetailService.swift
//  SCWeibo
//
//  Created by 王书超 on 2021/5/14.
//

import Alamofire
import Foundation

class StatusDetailService {
}

// MARK: - Like

extension StatusDetailService {
    func sendLikeAction(liked: Bool, statusId: Int, completion: @escaping (_ success: Bool) -> Void) {
        ApiConfigService.getApiConfig { _, st, _ in
            self.postLike(liked: liked, statusId: statusId, st: st, completion: completion)
        }
    }

    private func postLike(liked: Bool, statusId: Int, st: String, completion: @escaping (_ success: Bool) -> Void) {
        let URLString = liked ? URLSettings.attitudesCreate : URLSettings.attitudesDestroy

        var params = [String: Any]()
        params["attitude"] = "heart"
        params["id"] = statusId
        params["st"] = st
        
        var headers = HTTPHeaders()
        headers.add(HTTPHeader(name: "referer", value: "https://m.weibo.cn/beta"))
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

            if jsonResult?["data"] == nil {
                completion(false)
            }
            completion(true)
        }
    }
}


// MARK: - Favorite

extension StatusDetailService {
    func sendFavoriteAction(favorited: Bool, statusId: Int, completion: @escaping (_ success: Bool) -> Void) {
        ApiConfigService.getApiConfig { _, st, _ in
            self.postFavorite(favorited: favorited, statusId: statusId, st: st, completion: completion)
        }
    }

    private func postFavorite(favorited: Bool, statusId: Int, st: String, completion: @escaping (_ success: Bool) -> Void) {
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
                completion(false)
            }
            completion(true)
        }
    }
}

