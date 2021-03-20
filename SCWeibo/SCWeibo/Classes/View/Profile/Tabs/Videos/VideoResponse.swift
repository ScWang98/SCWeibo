//
//  VideoResponse.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/17.
//

import UIKit

/// 因此model使用了PC版的接口，参数层级较复杂，因此手动解析数据
class VideoResponse: Codable {
    var id: String?
    var text: String?
    var createdAt: String?
    var coverUrl: String?
    var videoUrl: String?

    init(dict: [AnyHashable: Any]) {
        guard let mblog: Dictionary<AnyHashable, Any> = dict.sc.dictionary(for: "mblog") else { return }

        id = mblog.sc.string(for: "id")
        createdAt = mblog.sc.string(for: "created_at")

        guard let pageInfo: Dictionary<AnyHashable, Any> = mblog.sc.dictionary(for: "page_info") else { return }

        text = pageInfo.sc.string(for: "content2")

        if let pagePic: Dictionary<AnyHashable, Any> = pageInfo.sc.dictionary(for: "page_pic") {
            coverUrl = pagePic.sc.string(for: "url")
        }

        if let videoUrls: Dictionary<AnyHashable, Any> = pageInfo.sc.dictionary(for: "urls") {
            videoUrl = videoUrls.sc.string(for: "mp4_720p_mp4")
        }
    }
}
