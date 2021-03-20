//
//  VideoCellViewModel.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/19.
//

import Foundation

class VideoCellViewModel {
    var video: VideoResponse
    var text: String?
    var createdAt: String?
    var coverUrl: String?
    var videoUrl: String?

    init(with model: VideoResponse) {
        video = model
        parseProperties()
    }
}

private extension VideoCellViewModel {
    func parseProperties() {
        text = video.text
        createdAt = Date.mn_sinaDate(string: video.createdAt)?.mn_dateDescription
        coverUrl = video.coverUrl
        videoUrl = video.videoUrl
    }
}

extension VideoCellViewModel {
    var cellHeight: CGFloat {
        return 200
    }

    var cellIdentifier: String {
        return String(describing: VideoTableCell.self)
    }
}