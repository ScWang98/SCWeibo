//
//  Status.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/6.
//

import Foundation

class StatusResponse: Codable {
    var id: Int = 0

    var text: String?

    var user: UserResponse?

    var repostsCount: Int = 0

    var commentsCount: Int = 0

    var attitudesCount: Int = 0

    var picUrls: [StatusPicture]?

    var createdAt: String?

    var source: String?

    var retweetedStatus: StatusResponse?

    var videoModel: StatusVideoModel?

    private enum CodingKeys: String, CodingKey {
        case id
        case text
        case user
        case repostsCount = "reposts_count"
        case commentsCount = "comments_count"
        case attitudesCount = "attitudes_count"
        case picUrls = "pic_urls"
        case createdAt = "created_at"
        case source
        case retweetedStatus = "retweeted_status"
    }

    init() {
    }

    convenience init(withH5dict dict: [AnyHashable: Any]) {
        self.init()

        id = Int(dict.sc.string(for: "id") ?? "") ?? 0
        text = dict.sc.string(for: "text")
        user = UserResponse(withH5dict: dict.sc.dictionary(for: "user") ?? [AnyHashable: Any]())
        repostsCount = dict.sc.int(for: "reposts_count")
        commentsCount = dict.sc.int(for: "comments_count")
        attitudesCount = dict.sc.int(for: "attitudes_count")
        createdAt = dict.sc.string(for: "created_at")
        source = dict.sc.string(for: "source")
        picUrls = StatusPicture.generateStatusPictures(withH5Array: dict.sc.array(for: "pics"))
        if dict["retweeted_status"] != nil {
            retweetedStatus = StatusResponse(withH5dict: dict.sc.dictionary(for: "retweeted_status") ?? [AnyHashable: Any]())
        }
        videoModel = StatusVideoModel(H5Dict: dict.sc.dictionary(for: "page_info"))
    }
}

class StatusVideoModel {
    var coverUrl: String?
    var playCount: Int = 0
    var videoUrl: String?

    init?(H5Dict: [AnyHashable: Any]?) {
        guard let type = H5Dict?.sc.string(for: "type"),
           type == "video" else {
            return nil
        }

        if let play_count = H5Dict?.sc.int(for: "play_count", defaultValue: 0) {
            playCount = play_count
        }
        if let pagePic: Dictionary<AnyHashable, Any> = H5Dict?.sc.dictionary(for: "page_pic") {
            coverUrl = pagePic.sc.string(for: "url")
        }
        if let videoUrls: Dictionary<AnyHashable, Any> = H5Dict?.sc.dictionary(for: "urls") {
            let keys = ["mp4_720p_mp4", "hevc_mp4_hd", "mp4_hd_mp4", "mp4_ld_mp4"]
            for key in keys {
                if videoUrls[key] != nil {
                    videoUrl = videoUrls.sc.string(for: key)
                    break
                }
            }
        }
    }
}

class StatusPicture: Codable {
    var thumbnailPic: String?

    var bmiddlePic: String?

    var originalPic: String?

    private enum CodingKeys: String, CodingKey {
        case thumbnailPic = "thumbnail_pic"
    }

    convenience init(withH5dict dict: [AnyHashable: Any]) {
        self.init()

        if let url = dict.sc.string(for: "url") {
            thumbnailPic = url.replacingOccurrences(of: "/wap360/", with: "/thumbnail/")
            bmiddlePic = url.replacingOccurrences(of: "/wap360/", with: "/bmiddle/")
            originalPic = url.replacingOccurrences(of: "/wap360/", with: "/large/")
        }
    }

    class func generateStatusPictures(withH5Array array: [[AnyHashable: Any]]?) -> [StatusPicture]? {
        guard let array = array,
              array.count > 0 else {
            return nil
        }
        var results = [StatusPicture]()
        for dict in array {
            results.append(StatusPicture(withH5dict: dict))
        }
        return results
    }
}
