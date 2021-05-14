//
//  AttitudeModel.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/13.
//

import Foundation

/// 因此model使用了H5版的接口，参数层级较复杂，因此手动解析数据
class AttitudeModel: Codable {
    var id: String?
    var source: String?
    var createdAt: String?
    var user: UserResponse?

    init(dict: [AnyHashable: Any]) {
        id = dict.sc.string(for: "id")
        source = dict.sc.string(for: "source")
        createdAt = dict.sc.string(for: "created_at")
        if let userDict: [AnyHashable: Any] = dict.sc.dictionary(for: "user") {
            user = UserResponse(withH5dict: userDict)
        }
    }
}
