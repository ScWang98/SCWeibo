//
//  StatusRepostCellViewModel.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/7.
//

import Foundation

class StatusRepostCellViewModel {
    var status: StatusResponse
    var screenName: String?
    var avatarUrl: String?
    var source: String?
    var statusAttrText: NSAttributedString?
    var picUrls: [StatusPicture]?
    var repostTitle: String?
    var commentTitle: String?
    var likeTitle: String?

    init(with model: StatusResponse) {
        status = model
        parseProperties()
    }
}

private extension StatusRepostCellViewModel {
    func parseProperties() {
//        statusAttrText = MNEmojiManager.shared.getEmojiString(string: status.text ?? "", font: UIFont.systemFont(ofSize: MNLayout.Layout(15)))
//        picUrls = status.picUrls
//        screenName = status.user?.screenName
//        avatarUrl = status.user?.profileImageUrl
//        source = "来自" + (source?.mn_href()?.text ?? "")
    }
}

extension StatusRepostCellViewModel: StatusCellViewModel {
    var cellHeight: CGFloat {
        return 0
    }

    var cellIdentifier: String {
        return String(describing: StatusRepostCell.self)
    }
}
