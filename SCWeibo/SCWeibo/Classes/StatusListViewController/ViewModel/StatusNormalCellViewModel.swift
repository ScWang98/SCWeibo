//
//  StatusNormalCellViewModel.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/7.
//

import Foundation

class StatusNormalCellViewModel {
    var status: StatusResponse
    var screenName: String?
    var avatarUrl: String?
    var source: String?
    var statusAttrText: NSAttributedString?
    var picUrls: [StatusPicturesModel]?
    var repostTitle: String?
    var commentTitle: String?
    var likeTitle: String?

    init(with model: StatusResponse) {
        status = model
        parseProperties()
    }
}

private extension StatusNormalCellViewModel {
    func parseProperties() {
        statusAttrText = MNEmojiManager.shared.getEmojiString(string: status.text ?? "", font: UIFont.systemFont(ofSize: MNLayout.Layout(15)))
        picUrls = StatusPicturesModel.generateModels(with: status.picUrls ?? [])
        screenName = status.user?.screenName
        avatarUrl = status.user?.profileImageUrl
        source = "来自" + (source?.mn_href()?.text ?? "")
        repostTitle = countSting(count: status.repostsCount, defaultStr: " 转发")
        commentTitle = countSting(count: status.commentsCount, defaultStr: " 评论")
        likeTitle = countSting(count: status.attitudesCount, defaultStr: " 点赞")
    }
    
    private func countSting(count:Int, defaultStr: String) -> String{
        if count <= 0{
            return defaultStr
        }
        if count < 10000{
            return count.description
        }
        return String(format: "%.02f万", Double(count) / 10000)
    }
}

extension StatusNormalCellViewModel: StatusCellViewModel {
    var cellHeight: CGFloat {
        let topHeight = StatusTopToolBar.height(for: self)
        
        let width = UIScreen.sc.screenWidth - 2 * 12
        let textSize = CGSize(width:width, height: CGFloat.greatestFiniteMagnitude)
        let textHeight = statusAttrText?.boundingRect(with: textSize, options: [.usesLineFragmentOrigin], context: nil).height ?? 0

        let imageHeight = StatusPicturesView.height(for: picUrls ?? [])
        let bottomHeight = StatusBottomToolBar.height(for: self)
        return topHeight + textHeight + imageHeight + bottomHeight
    }

    var cellIdentifier: String {
        return String(describing: StatusNormalCell.self)
    }
}
