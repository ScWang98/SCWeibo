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
    var statusesCount: Int?
    var followersCount: Int?
    var followCount: Int?
    var following: Bool?
    var verifiedType: Int = 0   // 认证类型（-1:没有认证, 0:认证用户, 2,3,5:企业认证, 220:达人）
    var mbrank: Int = 0   // 会员等级 0~6
    
    private enum CodingKeys: String, CodingKey {
        case id
        case screenName = "screen_name"
        case avatar = "profile_image_url"
        case avatarHD = "avatar_hd"
        case description = "description"
        case gender = "gender"
        case bgImage = "cover_image_phone"
        case statusesCount = "statuses_count"
        case followersCount = "followers_count"
        case followCount = "follow_count"
        case following = "following"
        case verifiedType = "verified_type"
        case mbrank
    }
}
