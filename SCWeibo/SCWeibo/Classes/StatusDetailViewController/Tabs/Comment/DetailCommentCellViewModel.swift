//
//  DetailCommentCellViewModel.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/13.
//

import Foundation

class DetailCommentCellViewModel {
    var model: CommentModel
    var avatarUrl: String?
    var screenName: String?
    var commentLabelModel: ContentLabelTextModel?
    var subCommentLabelModels: [ContentLabelTextModel]?
    var totalNumber = 0
    var createdAt: String?
    var likeCount = 0

    init(with model: CommentModel) {
        self.model = model
        parseProperties()
    }
}

// MARK: - Public Methods

extension DetailCommentCellViewModel {
    func cellHeight(cellWidth: CGFloat) -> CGFloat {
        var totalHeight: CGFloat = 0

        totalHeight += 35 // 到nameLabel底部的距离
        totalHeight += 10 // gap

        let contentWidth = cellWidth - 15 - 32 - 15 - 15
        let contentHeight = commentLabelModel?.text.sc.height(labelWidth: contentWidth) ?? 0
        totalHeight += contentHeight
        totalHeight += 10 // gap

        let commentsHeight = DetailCommentsView.height(for: subCommentLabelModels ?? [ContentLabelTextModel](), totalNumber: totalNumber, commentsWidth: contentWidth)
        totalHeight += commentsHeight

        totalHeight += 32 // 底部gap + nameLabel

        return totalHeight
    }
}

private extension DetailCommentCellViewModel {
    func parseProperties() {
        avatarUrl = model.user?.avatar
        screenName = model.user?.screenName
        commentLabelModel = ContentHTMLParser.parseTextWithHTML(string: model.text ?? "", font: UIFont.systemFont(ofSize: 16))

        if let comments = model.comments {
            var subCommentLabelModels = [ContentLabelTextModel]()
            for comment in comments {
                if let text = comment.text {
                    let model = ContentLabelTextModel(text: NSMutableAttributedString(string: text))
                    subCommentLabelModels.append(model)
                }
            }
            self.subCommentLabelModels = subCommentLabelModels
        }

        totalNumber = model.totalNumber
        createdAt = Date.mn_sinaDate(string: model.createdAt)?.mn_dateDescription
        likeCount = model.likeCount
    }
}
