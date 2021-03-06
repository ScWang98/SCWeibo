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
    var videoModel: StatusVideoModel?

    init(with model: VideoResponse) {
        video = model
        parseProperties()
    }
}

private extension VideoCellViewModel {
    func parseProperties() {
        text = video.text
        createdAt = video.createdAt?.semanticDateDescription
        videoModel = video.videoModel
    }
}
