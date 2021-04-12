//
//  UserResponse.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/6.
//

import Foundation

class UserResponse: Codable {
    var id: Int?
    var screenName: String?
    var avatar: String?
    var avatarHD: String?
    var description: String?
    var gender: String?
    var bgImage: String?
    var location: String?
    var statusesCount: Int?
    var followersCount: Int?
    var followCount: Int?
    var following: Bool?
    var followMe: Bool?
    var verifiedType: Int = 0 // 认证类型（-1:没有认证, 0:认证用户, 2,3,5:企业认证, 220:达人）
    var mbrank: Int = 0 // 会员等级 0~6

    private enum CodingKeys: String, CodingKey {
        case id
        case screenName = "screen_name"
        case avatar = "avatar_large"
        case avatarHD = "avatar_hd"
        case description
        case gender
        case bgImage = "cover_image_phone"
        case location
        case statusesCount = "statuses_count"
        case followersCount = "followers_count"
        case followCount = "friends_count"
        case following
        case followMe = "follow_me"
        case verifiedType = "verified_type"
        case mbrank
    }
}

extension UserResponse {
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
