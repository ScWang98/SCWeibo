//
//  MessageCommentCellViewModel.swift
//  SCWeibo
//
//  Created by 王书超 on 2021/4/24.
//

import Foundation

class MessageCommentCellViewModel {
    var model: MessageCommentModel
    var avatarUrl: String?
    var screenName: String?
    var commentLabelModel: ContentLabelTextModel?
    var statusLabelModel: ContentLabelTextModel?
    var createdAt: String?

    init(with model: MessageCommentModel) {
        self.model = model
        parseProperties()
    }
}

// MARK: - Public Methods

extension MessageCommentCellViewModel {
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
        return 300
    }
}

private extension MessageCommentCellViewModel {
    func parseProperties() {
        avatarUrl = model.user?.avatar
        screenName = model.user?.screenName
        commentLabelModel = ContentHTMLParser.parseContentText(string: model.text ?? "", font: UIFont.systemFont(ofSize: 16))
        statusLabelModel = ContentHTMLParser.parseContentText(string: model.status?.text ?? "", font: UIFont.systemFont(ofSize: 16))
        createdAt = model.createdAt?.semanticDateDescription
    }
}
