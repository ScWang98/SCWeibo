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
    var contentAttrString: NSAttributedString?
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
        return 134
    }
}

private extension MessageAttitudeCellViewModel {
    func parseProperties() {
        avatarUrl = model.user?.avatar
        screenName = model.user?.screenName
        
        var attributes = [NSAttributedString.Key: Any]()
        attributes[.font] = UIFont.systemFont(ofSize: 15)
        attributes[.foregroundColor] = UIColor.lightGray
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.baseWritingDirection = .natural
        attributes[.paragraphStyle] = paragraphStyle
        contentAttrString = ContentHTMLParser.parseContentText(string: model.status?.text ?? "", font: UIFont.systemFont(ofSize: 15), baseAttributes: attributes).text

        if (model.status?.picUrls?.count ?? 0) > 0 {
            imageUrl = model.status?.picUrls?.first?.thumbnailPic
        } else {
            imageUrl = model.status?.user?.avatar
        }

        createdAt = model.createdAt?.semanticDateDescription
    }
}
