//
//  RepostModel.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/11.
//

import Foundation

/// 因此model使用了H5版的接口，参数层级较复杂，因此手动解析数据
class RepostModel: Codable {
    var id: String?
    var text: String?
    var createdAt: String?
    var user: UserResponse?

    init(dict: [AnyHashable: Any]) {
        id = dict.sc.string(for: "id")
        text = dict.sc.string(for: "text")
        createdAt = dict.sc.string(for: "created_at")
        if let userDict: [AnyHashable: Any] = dict.sc.dictionary(for: "user") {
            user = UserResponse(withH5dict: userDict)
        }
    }
}
