//
//  StatusModel.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/6.
//

import Foundation

class StatusModel: Codable {
    var id: Int = 0

    var text: String?

    var user: UserModel?

    var repostsCount: Int = 0

    var commentsCount: Int = 0

    var attitudesCount: Int = 0

    var picUrls: [StatusPicture]?

    var createAt: String?

    var source: String?

    var retweetedStatus: StatusModel?

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
}

class StatusPicture: Codable {
    var thumbnailPic: String? {
        didSet {
            bmiddlePic = thumbnailPic?.replacingOccurrences(of: "/thumbnail/", with: "/bmiddle/")
            originalPic = thumbnailPic?.replacingOccurrences(of: "/thumbnail/", with: "/large/")
            thumbnailPic = thumbnailPic?.replacingOccurrences(of: "/thumbnail/", with: "/wap360/")
        }
    }

    var bmiddlePic: String?

    var originalPic: String?

    private enum CodingKeys: String, CodingKey {
        case thumbnailPic = "thumbnail_pic"
    }
}
