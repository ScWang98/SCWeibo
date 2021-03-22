//
//  PhotoResponse.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/23.
//

import Foundation

/// 因此model使用了H5版的接口，参数层级较复杂，因此手动解析数据
class PhotoResponse: Codable {
    var picThumbnail: String?
    var picOriginal: String?
    var text: String?
    var statusId: String?

    init(dict: [AnyHashable: Any]) {
        picOriginal = dict.sc.string(for: "pic_big")
        picThumbnail = picOriginal?.replacingOccurrences(of: "/woriginal/", with: "/bmiddle/")

        guard let mblog: Dictionary<AnyHashable, Any> = dict.sc.dictionary(for: "mblog") else { return }

        statusId = mblog.sc.string(for: "id")
        text = mblog.sc.string(for: "text")
    }
}
