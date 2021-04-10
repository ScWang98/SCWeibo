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
    var userId: String?

    func loadStatus(max_id: Int?, page: Int?, completion: @escaping (Bool, [StatusResponse]?) -> Void) {
        guard let userId = userId else {
            return
        }

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
                    if card.sc.int(for: "card_type") != 9 {
                        continue
                    }
                    guard let dict: [AnyHashable: Any] = card.sc.dictionary(for: "mblog") else {
                        continue
                    }
                    results.append(StatusResponse(withH5dict: dict))
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

        id = Int(dict.sc.string(for: "id") ?? "") ?? 0
        text = dict.sc.string(for: "text")
        user = UserResponse(withH5dict: dict.sc.dictionary(for: "user") ?? [AnyHashable: Any]())
        repostsCount = dict.sc.int(for: "reposts_count")
        commentsCount = dict.sc.int(for: "comments_count")
        attitudesCount = dict.sc.int(for: "attitudes_count")
        createdAt = dict.sc.string(for: "created_at")
        source = dict.sc.string(for: "source")
        picUrls = StatusPicture.generateStatusPictures(withH5Array: dict.sc.array(for: "pics"))
        if dict["retweeted_status"] != nil {
            retweetedStatus = StatusResponse(withH5dict: dict.sc.dictionary(for: "retweeted_status") ?? [AnyHashable: Any]())
        }
    }
}

fileprivate extension UserResponse {
    convenience init(withH5dict dict: [AnyHashable: Any]) {
        self.init()
        
        id = Int(dict.sc.string(for: "id") ?? "")
        screenName = dict.sc.string(for: "screen_name")
        avatar = dict.sc.string(for: "profile_image_url")
        avatarHD = dict.sc.string(for: "avatar_hd")
        description = dict.sc.string(for: "description")
        gender = dict.sc.string(for: "gender")
        bgImage = dict.sc.string(for: "cover_image_phone")
        statusesCount = dict.sc.int(for: "statuses_count")
        followersCount = dict.sc.int(for: "followers_count")
        followCount = dict.sc.int(for: "follow_count")
        following = dict.sc.bool(for: "following")
        followMe = dict.sc.bool(for: "follow_me")
        verifiedType = dict.sc.int(for: "verified_type")
        mbrank = dict.sc.int(for: "mbrank")
    }
}

fileprivate extension StatusPicture {
    convenience init(withH5dict dict: [AnyHashable: Any]) {
        self.init()

        if let url = dict.sc.string(for: "url") {
            thumbnailPic = url.replacingOccurrences(of: "/wap360/", with: "/thumbnail/")
        }
    }

    class func generateStatusPictures(withH5Array array: [[AnyHashable: Any]]?) -> [StatusPicture] {
        var results = [StatusPicture]()
        for dict in array ?? [[AnyHashable: Any]]() {
            results.append(StatusPicture(withH5dict: dict))
        }
        return results
    }
}
