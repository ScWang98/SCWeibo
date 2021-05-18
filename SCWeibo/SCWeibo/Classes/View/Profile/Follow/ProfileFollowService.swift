//
//  ProfileFollowService.swift
//  SCWeibo
//
//  Created by 王书超 on 2021/5/17.
//

import Alamofire
import Foundation

class ProfileFollowService {
    var followType: ProfileFollowType

    init(type: ProfileFollowType) {
        followType = type
    }

    func requestFollowList(userId: Int, page: Int?, sinceId: Int?, completion: @escaping (_ success: Bool, _ sinceId: Int, _ list: [UserResponse]?) -> Void) {
        let requestURL = URLSettings.getIndexURL

        var params = [String: Any]()
        if userId == AccountManager.shared.user?.id {
            if followType == .following {
                params["containerid"] = "231093_-_selffollowed"
                params["page"] = page
            } else if followType == .follower {
                params["containerid"] = "231016_-_selffans"
                params["since_id"] = sinceId
            }
        } else {
            if followType == .following {
                params["containerid"] = "231051_-_followers_-_" + String(userId)
                params["page"] = page
            } else if followType == .follower {
                params["containerid"] = "231051_-_fans_-_" + String(userId)
                params["since_id"] = sinceId
            }
        }

        AF.request(requestURL, method: .get, parameters: params, encoding: URLEncoding.default).responseJSON { response in

            var jsonDict: Dictionary<AnyHashable, Any>?

            switch response.result {
            case let .success(json):
                jsonDict = json as? Dictionary<AnyHashable, Any>
            case .failure:
                jsonDict = nil
            }

            guard let dataDict: Dictionary<AnyHashable, Any> = jsonDict?.sc.dictionary(for: "data"),
                  let cardsArray: [[AnyHashable: Any]] = dataDict.sc.array(for: "cards"),
                  let cardListInfoDict: [AnyHashable: Any] = dataDict.sc.dictionary(for: "cardlistInfo") else {
                completion(false, 0, nil)
                return
            }

            var results = [UserResponse]()
            // 我吐了。。。实在是太乱了。。。对不起。。。。。
            if userId == AccountManager.shared.user?.id {
                for cardDict in cardsArray {
                    if cardDict.sc.int(for: "card_type") == 11,
                       let cardGroupArray: [[AnyHashable: Any]] = cardDict.sc.array(for: "card_group") {
                        for card in cardGroupArray {
                            if card.sc.int(for: "card_type") == 10,
                               var userDict: [AnyHashable: Any] = card.sc.dictionary(for: "user"),
                               self.followType == .following && userDict.sc.bool(for: "following") ||
                                self.followType == .follower && userDict.sc.bool(for: "follow_me") {
                                
                                if let desc = userDict.sc.string(for: "description"),
                                   desc.count > 0 {
                                } else {
                                    userDict["description"] = card["desc1"]
                                    if let desc = userDict.sc.string(for: "description"),
                                       desc.count > 0 {
                                    } else {
                                        userDict["description"] = card["desc2"]
                                    }
                                }
                                results.append(UserResponse(withH5dict: userDict))
                            }
                        }
                    }
                }
            } else {
                for cardDict in cardsArray {
                    if cardDict.sc.int(for: "card_type") == 11,
                       cardDict["card_style"] == nil,     // 很trick，用了 有card_type && 无card_style 的方式来判断是否是需要的
                       let cardGroupArray: [[AnyHashable: Any]] = cardDict.sc.array(for: "card_group") {
                        for card in cardGroupArray {
                            if card.sc.int(for: "card_type") == 10,
                               var userDict: [AnyHashable: Any] = card.sc.dictionary(for: "user") {
                                if let desc = userDict.sc.string(for: "description"),
                                   desc.count > 0 {
                                } else {
                                    userDict["description"] = card["desc1"]
                                    if let desc = userDict.sc.string(for: "description"),
                                       desc.count > 0 {
                                    } else {
                                        userDict["description"] = card["desc2"]
                                    }
                                }
                                results.append(UserResponse(withH5dict: userDict))
                            }
                        }
                    }
                }
            }
            let sinceId = cardListInfoDict.sc.int(for: "since_id")
            completion(true, sinceId, results)
        }
    }
}
