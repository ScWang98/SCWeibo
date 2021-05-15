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
        var totalHeight: CGFloat = 0

        totalHeight += 35 // 到nameLabel底部的距离
        totalHeight += 10 // gap

        let contentWidth = cellWidth - 15 - 40 - 10 - 15

        if let commentLabelModel = commentLabelModel {
            let contentHeight = commentLabelModel.text.sc.height(labelWidth: contentWidth)
            totalHeight += contentHeight
            totalHeight += 8 // gap
        }

        if let statusLabelModel = statusLabelModel {
            let statusHeight = statusLabelModel.text.sc.height(labelWidth: contentWidth - 16)
            totalHeight += statusHeight
            totalHeight += 8 // gap
        }

        totalHeight += 25 // 底部gap + nameLabel

        return totalHeight
    }
}

private extension MessageCommentCellViewModel {
    func parseProperties() {
        avatarUrl = model.user?.avatar
        screenName = model.user?.screenName
        commentLabelModel = ContentHTMLParser.parseContentText(string: model.text ?? "", font: UIFont.systemFont(ofSize: 16))
        var attributes = [NSAttributedString.Key: Any]()
        attributes[.font] = UIFont.systemFont(ofSize: 16)
        attributes[.foregroundColor] = UIColor.black
        statusLabelModel = ContentHTMLParser.parseContentText(string: model.status?.text ?? "", font: UIFont.systemFont(ofSize: 16), baseAttributes: attributes)
        if let screenName = model.status?.user?.screenName,
           let statusLabelModel = statusLabelModel {
            let nameAttrStr = NSAttributedString(string: screenName + "：", attributes: attributes)
            statusLabelModel.text.insert(nameAttrStr, at: 0)
            for schema in statusLabelModel.schemas {
                schema.range.location += nameAttrStr.length
            }
            let schema = String(format: "pillar://userProfile?user_name=%@", screenName.sc.stringByURLEncode)
            statusLabelModel.schemas.append(ContentLabelTextModel.SchemaModel(range: NSRange(location: 0, length: screenName.count), schema: schema))
        }

        createdAt = model.createdAt?.semanticDateDescription
    }
}
