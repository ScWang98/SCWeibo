//
//  MessageAttitudeModel.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/24.
//


import Foundation

class MessageAttitudeModel: Codable {
    var id: String?
    var createdAt: String?
    var user: UserResponse?
    var status: StatusResponse?

    init(dict: [AnyHashable: Any]) {
        id = dict.sc.string(for: "idStr")
        createdAt = dict.sc.string(for: "created_at")
        if let userDict: [AnyHashable: Any] = dict.sc.dictionary(for: "user") {
            user = UserResponse(withH5dict: userDict)
        }
        if let statusDict: [AnyHashable: Any] = dict.sc.dictionary(for: "status") {
            status = StatusResponse(withH5dict: statusDict)
        }
    }
}
