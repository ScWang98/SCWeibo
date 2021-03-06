//
//  UserModel.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/6.
//

import Foundation

class UserModel: Codable {
    
    var id: Int
    
    var screenName: String?
    
    var profileImageUrl: String?

    // 认证类型（-1:没有认证, 0:认证用户, 2,3,5:企业认证, 220:达人）
    var verifiedType: Int = 0
    
    // 会员等级 0~6
    var mbrank: Int = 0
    
    private enum CodingKeys: String, CodingKey {
        case id
        case screenName = "screen_name"
        case profileImageUrl = "profile_image_url"
        case verifiedType = "verified_type"
        case mbrank
    }
}
