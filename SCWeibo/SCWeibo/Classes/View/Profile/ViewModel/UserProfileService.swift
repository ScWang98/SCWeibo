//
//  UserProfileService.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/3/28.
//

import Alamofire
import Foundation

class UserProfileService {
    func fetchUserInfo(with userId: Int, completion: @escaping (_ list: UserResponse?) -> Void) {
        let URLString = URLSettings.userInfoURL

        var params = [String: Any]()
        params["uid"] = userId
        params["access_token"] = AccountManager.shared.accessToken
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
            completion(userResult)
        }
    }
}

class UserProfileStatusService: StatusListService {
    var userId: String = ""
    
    func loadStatus(max_id: Int?, page: Int?, completion: @escaping (Bool, [StatusResponse]?) -> Void) {
        let containerIdPre = "230413"

        let URLString = URLSettings.getIndexURL

        var params = [String: Any]()
        params["containerid"] = containerIdPre + userId + "_-_WEIBO_SECOND_PROFILE_WEIBO"
        params["page"] = page
        params["type"] = "03"
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

            if let data: Dictionary<AnyHashable, Any> = jsonResult?.sc.dictionary(for: "data"),
               let cards: Array<Dictionary<AnyHashable, Any>> = data.sc.array(for: "cards") {
                var results = [StatusResponse]()
                for card in cards {
                    results.append(StatusResponse(withH5dict: card))
                }
                completion(true, results)
            }
            completion(false, nil)
        }
    }
}

fileprivate extension StatusResponse {
    convenience init(withH5dict dict: [AnyHashable: Any]) {
        self.init()
    }
}
