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
    var createdAt: String?
    var statusAttrText: NSAttributedString?
    var picUrls: [StatusPicturesModel]?
    var repostTitle: String?
    var commentTitle: String?
    var likeTitle: String?
    var repostAttrText: NSAttributedString?

    init(with model: StatusResponse) {
        status = model
        parseProperties()
    }
}

private extension StatusRepostCellViewModel {
    func parseProperties() {
        statusAttrText = MNEmojiManager.shared.getEmojiString(string: status.text ?? "", font: UIFont.systemFont(ofSize: MNLayout.Layout(15)))
        picUrls = StatusPicturesModel.generateModels(with: status.retweetedStatus?.picUrls ?? [])
        screenName = status.user?.screenName
        avatarUrl = status.user?.profileImageUrl
        source = "来自" + (status.source?.mn_href()?.text ?? "")
        createdAt = Date.mn_sinaDate(string: status.createdAt)?.mn_dateDescription
        repostTitle = countSting(count: status.repostsCount, defaultStr: " 转发")
        commentTitle = countSting(count: status.commentsCount, defaultStr: " 评论")
        likeTitle = countSting(count: status.attitudesCount, defaultStr: " 点赞")
        let repostStr = "@\(status.retweetedStatus?.user?.screenName ?? ""):\(status.retweetedStatus?.text ?? "")"
        let repostFontSize = UIFont.systemFont(ofSize: 14)
        repostAttrText = MNEmojiManager.shared.getEmojiString(string: repostStr, font: repostFontSize)
    }

    private func countSting(count: Int, defaultStr: String) -> String {
        if count <= 0 {
            return defaultStr
        }
        if count < 10000 {
            return count.description
        }
        return String(format: "%.02f万", Double(count) / 10000)
    }
}

extension StatusRepostCellViewModel: StatusCellViewModel {
    var cellHeight: CGFloat {
        let gap: CGFloat = 10

        let topSepHeight: CGFloat = 12
        let topBarHeight = StatusTopToolBar.height(for: self)

        let width = UIScreen.sc.screenWidth - 2 * 12
        let textSize = CGSize(width: width, height: 0)
        let rect = statusAttrText?.boundingRect(with: textSize, options: [.usesLineFragmentOrigin], context: nil)
        let textHeight = rect?.height ?? 0

        let repostHeight = StatusRepostView.height(for: self)
        let bottomHeight = StatusBottomToolBar.height(for: self)
        return topSepHeight + topBarHeight + textHeight + gap + repostHeight + bottomHeight
    }

    var cellIdentifier: String {
        return String(describing: StatusRepostCell.self)
    }
}
