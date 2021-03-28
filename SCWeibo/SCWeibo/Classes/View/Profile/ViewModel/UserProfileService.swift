//
//  UserProfileService.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/3/28.
//

import Foundation
import Alamofire

class UserProfileService {
        
    class func fetchUserInfo(completion: @escaping (_ list: UserResponse?) -> Void) {
        let userId = "5236464641"

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

            var userResult: UserResponse? = nil
            if let user = jsonResult {
                userResult = UserResponse.decode(user)
            }
            completion(userResult)
        }
    }
    
}
