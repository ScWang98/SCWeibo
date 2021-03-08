//
//  StatusPicturesModel.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/7.
//

import UIKit

class StatusPicturesModel {
    var thumbnailPic: String

    var bmiddlePic: String

    var originalPic: String

    init(with statusPicture: StatusPicture) {
        thumbnailPic = statusPicture.thumbnailPic?.replacingOccurrences(of: "/thumbnail/", with: "/wap360/") ?? ""
        bmiddlePic = statusPicture.thumbnailPic?.replacingOccurrences(of: "/thumbnail/", with: "/bmiddle/") ?? ""
        originalPic = statusPicture.thumbnailPic?.replacingOccurrences(of: "/thumbnail/", with: "/large/") ?? ""
    }

    static func generateModels(with pictures: [StatusPicture]) -> [StatusPicturesModel] {
        var array = [StatusPicturesModel]()
        for picture in pictures {
            array.append(StatusPicturesModel(with: picture))
        }
        return array
    }
}
