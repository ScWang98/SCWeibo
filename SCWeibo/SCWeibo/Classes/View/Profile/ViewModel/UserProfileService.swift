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
    var currentPage: Int = 1

    func loadStatus(max_id: Int?, completion: @escaping (Bool, [StatusResponse]?) -> Void) {
        let containerIdPre = "230413"
        let userId = "5236464641"

        let URLString = URLSettings.getIndexURL
//        let page: Int
//        if max_id == nil {
//            currentPage = 1
//        }

        var params = [String: Any]()
        params["containerid"] = containerIdPre + userId + "_-_WEIBO_SECOND_PROFILE_WEIBO"
//        params["page"] = page
        params["type"] = "03"
        AF.request(URLString, method: .get, parameters: params, encoding: URLEncoding.default).responseJSON { response in
            var isSuccess = false
            var jsonResult: Dictionary<AnyHashable, Any>?
            switch response.result {
            case let .success(json):
                if let dict = json as? Dictionary<AnyHashable, Any> {
                    jsonResult = dict
                    isSuccess = true
                }
            case .failure:
                jsonResult = nil
                isSuccess = false
            }

            if let data: Dictionary<AnyHashable, Any> = jsonResult?.sc.dictionary(for: "data") {
                jsonResult = data
            }
//            completion(isSuccess, jsonResult)
        }
    }
}
