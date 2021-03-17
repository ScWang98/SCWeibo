//
//  VideoResponse.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/17.
//

import UIKit

class VideoResponse: Codable {
    var id: String?
    var text: String?
    var createAt: String?
    var coverUrl: String?
    var videoUrl: String?

    init(dict: [AnyHashable: Any]) {
        guard let mblog = dict["mblog"] as? [AnyHashable: Any] else { return }
        if let id = mblog["id"] as? String {
            self.id = id
        }

        guard let pageInfo = dict["page_info"] as? [AnyHashable: Any] else { return }
        
        
    }
}
