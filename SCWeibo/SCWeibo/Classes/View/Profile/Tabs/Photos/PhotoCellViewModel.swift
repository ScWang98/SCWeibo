//
//  PhotoCellViewModel.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/23.
//

import Foundation

class PhotoCellViewModel {
    var photo: PhotoResponse

    var picThumbnail: String?
    var picOriginal: String?
    var text: String?
    var statusId: String?

    init(with model: PhotoResponse) {
        photo = model
        parseProperties()
    }
}

private extension PhotoCellViewModel {
    func parseProperties() {
        picThumbnail = photo.picThumbnail
        picOriginal = photo.picOriginal
        text = photo.text
        statusId = photo.statusId
    }
}
