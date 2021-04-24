//
//  MessageCommentModel.swift
//  SCWeibo
//
//  Created by 王书超 on 2021/4/24.
//

import Foundation

class MessageCommentModel: Codable {
    var id: String?
    var text: String?
    var user: UserResponse?
    var status: StatusResponse?
    var createdAt: String?

    init(dict: [AnyHashable: Any]) {
        id = dict.sc.string(for: "idStr")
        text = dict.sc.string(for: "text")
        if let userDict: [AnyHashable: Any] = dict.sc.dictionary(for: "user") {
            user = UserResponse(withH5dict: userDict)
        }
        if let statusDict: [AnyHashable: Any] = dict.sc.dictionary(for: "status") {
            status = StatusResponse(withH5dict: statusDict)
        }
        createdAt = dict.sc.string(for: "created_at")
    }
}
