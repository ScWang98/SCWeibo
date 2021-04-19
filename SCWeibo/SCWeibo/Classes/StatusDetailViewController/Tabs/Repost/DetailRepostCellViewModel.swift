//
//  DetailRepostCellViewModel.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/11.
//

import Foundation

class DetailRepostCellViewModel {
    var model: RepostModel
    var avatarUrl: String?
    var screenName: String?
    var commentLabelModel: ContentLabelTextModel?
    var createdAt: String?

    init(with model: RepostModel) {
        self.model = model
        parseProperties()
    }
}

// MARK: - Public Methods

extension DetailRepostCellViewModel {
    func cellHeight(cellWidth: CGFloat) -> CGFloat {
        var totalHeight: CGFloat = 0

        totalHeight += 32 // 到nameLabel底部的距离
        totalHeight += 10 // gap

        let contentWidth = cellWidth - 16 - 32 - 15 - 16
        let contentHeight = commentLabelModel?.text.sc.height(labelWidth: contentWidth) ?? 0
        totalHeight += contentHeight
        totalHeight += 10 // gap

        totalHeight += 25 // 底部gap + nameLabel

        return totalHeight
    }
}

private extension DetailRepostCellViewModel {
    func parseProperties() {
        avatarUrl = model.user?.avatar
        screenName = model.user?.screenName
        commentLabelModel = ContentHTMLParser.parseTextWithHTML(string: model.text ?? "", font: UIFont.systemFont(ofSize: 16))
        createdAt = model.createdAt?.semanticDateDescription
    }
}
