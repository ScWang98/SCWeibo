//
//  MessageAttitudeCellViewModel.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/24.
//

import Foundation

class MessageAttitudeCellViewModel {
    var model: MessageAttitudeModel
    var avatarUrl: String?
    var screenName: String?
    var cotentAttrString: NSAttributedString?
    var imageUrl: String?
    var createdAt: String?

    init(with model: MessageAttitudeModel) {
        self.model = model
        parseProperties()
    }
}

// MARK: - Public Methods

extension MessageAttitudeCellViewModel {
    func cellHeight(cellWidth: CGFloat) -> CGFloat {
//        var totalHeight: CGFloat = 0
//
//        totalHeight += 35 // 到nameLabel底部的距离
//        totalHeight += 10 // gap
//
//        let contentWidth = cellWidth - 15 - 32 - 15 - 15
//        let contentHeight = commentLabelModel?.text.sc.height(labelWidth: contentWidth) ?? 0
//        totalHeight += contentHeight
//        totalHeight += 10 // gap
//
//        if let commentLabelModels = subCommentLabelModels, commentLabelModels.count > 0 {
//            let commentsHeight = DetailCommentsView.height(for: subCommentLabelModels ?? [], totalNumber: totalNumber, commentsWidth: contentWidth)
//            totalHeight += commentsHeight
//            totalHeight += 8 // gap
//        }
//
//        totalHeight += 25 // 底部gap + nameLabel
//
//        return totalHeight
        return 180
    }
}

private extension MessageAttitudeCellViewModel {
    func parseProperties() {
        avatarUrl = model.user?.avatar
        screenName = model.user?.screenName
        cotentAttrString = ContentHTMLParser.parseContentText(string: model.status?.text ?? "", font: UIFont.systemFont(ofSize: 16)).text

        if (model.status?.picUrls?.count ?? 0) > 0 {
            imageUrl = model.status?.picUrls?.first?.thumbnailPic
        } else {
            imageUrl = model.status?.user?.avatar
        }

        createdAt = model.createdAt?.semanticDateDescription
    }
}
