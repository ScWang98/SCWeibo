//
//  DetailRespostCellViewModel.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/11.
//

import UIKit

class DetailRespostCellViewModel {
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

extension DetailRespostCellViewModel {
    var cellHeight: CGFloat {
        let avatarHeight: CGFloat = 44
        let timeLabelHeight: CGFloat = 24
        
        let width = UIScreen.sc.screenWidth - 26 - 67
        let textSize = CGSize(width: width, height: 0)
        let rect = commentLabelModel?.text.boundingRect(with: textSize, options: [.usesLineFragmentOrigin], context: nil)
        let textHeight = rect?.height ?? 0
        
        return avatarHeight + timeLabelHeight + textHeight
    }
}

private extension DetailRespostCellViewModel {
    func parseProperties() {
        avatarUrl = model.user?.avatar
        screenName = model.user?.screenName
        commentLabelModel = MNEmojiManager.shared.parseTextWithHTML(string: model.text ?? "", font: UIFont.systemFont(ofSize: 16))
        createdAt = Date.mn_sinaDate(string: model.createdAt)?.mn_dateDescription
    }
}
