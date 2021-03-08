//
//  Status.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/6.
//

import Foundation

class StatusResponse: Codable, CustomStringConvertible {
    var id: Int = 0

    var text: String?

    var user: UserResponse?

    var repostsCount: Int = 0

    var commentsCount: Int = 0

    var attitudesCount: Int = 0

    var picUrls: [StatusPicture]?

    var createAt: String?

    var source: String?

    var retweetedStatus: StatusResponse?

    private enum CodingKeys: String, CodingKey {
        case id
        case text
        case user
        case repostsCount = "reposts_count"
        case commentsCount = "comments_count"
        case attitudesCount = "attitudes_count"
        case picUrls = "pic_urls"
        case createAt = "create_at"
        case source
        case retweetedStatus = "retweeted_status"
    }

    var description: String {
        return "..."
    }
}

class StatusPicture: Codable {
    var thumbnailPic: String?

    var bmiddlePic: String?

    var originalPic: String?

    private enum CodingKeys: String, CodingKey {
        case thumbnailPic = "thumbnail_pic"
    }
}
