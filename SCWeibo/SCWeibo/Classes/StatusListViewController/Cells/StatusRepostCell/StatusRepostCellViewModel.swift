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
    var timeAttrString: NSAttributedString?
    var statusLabelModel: ContentLabelTextModel?
    var picUrls: [StatusPicturesModel]?
    var repostTitle: String?
    var commentTitle: String?
    var likeTitle: String?
    var interactiveAttrStr: NSAttributedString?
    var repostLabelModel: ContentLabelTextModel?
    var videoModel: StatusVideoModel?

    init(with model: StatusResponse) {
        status = model
        parseProperties()
    }
}

private extension StatusRepostCellViewModel {
    func parseProperties() {
        statusLabelModel = ContentHTMLParser.parseContentText(string: status.text ?? "", font: UIFont.systemFont(ofSize: 16))
        picUrls = StatusPicturesModel.generateModels(with: status.picUrls)
        screenName = status.user?.screenName
        avatarUrl = status.user?.avatar
        if let time = status.createdAt?.semanticDateDescription {
            var string = time
            if let source = status.source?.mn_href(), source.count > 0 {
                string = string + " · 来自 " + source
            }
            timeAttrString = NSAttributedString(string: string, attributes: [.font: UIFont.systemFont(ofSize: 13),
                                                                             .foregroundColor: UIColor.lightGray])
        }

        interactiveAttrStr = generateInteractiveAttrString(status: status)
        videoModel = status.videoModel

        if status.retweetedStatus != nil {
            let repostStr = "<a href=xx>@\(status.retweetedStatus?.user?.screenName ?? "")</a>:\(status.retweetedStatus?.text ?? "")"
            let repostFontSize = UIFont.systemFont(ofSize: 14)
            repostLabelModel = ContentHTMLParser.parseContentText(string: repostStr, font: repostFontSize)
            picUrls = StatusPicturesModel.generateModels(with: status.retweetedStatus?.picUrls)
            videoModel = status.retweetedStatus?.videoModel
        }
    }

    func generateInteractiveAttrString(status: StatusResponse) -> NSAttributedString? {
        if status.repostsCount <= 0 && status.commentsCount <= 0 && status.attitudesCount <= 0 {
            return nil
        }

        let interAttrString = NSMutableAttributedString()
        if let attrString = genarageAttrString(imageName: "RepostBarButton_Normal", number: status.repostsCount) {
            interAttrString.append(attrString)
        }
        if let attrString = genarageAttrString(imageName: "CommentBarButton_Normal", number: status.commentsCount) {
            interAttrString.append(attrString)
        }
        if let attrString = genarageAttrString(imageName: "LikeBarButton_Normal", number: status.attitudesCount) {
            interAttrString.append(attrString)
        }

        return interAttrString
    }

    func genarageAttrString(imageName: String, number: Int) -> NSAttributedString? {
        let color = UIColor.sc.color(RGB: 0x3C3C43, alpha: 0.6)
        guard let image = UIImage(named: imageName)?.sc.image(tintColor: color),
              number > 0 else {
            return nil
        }

        let attachment = NSTextAttachment(image: image)
        attachment.bounds = CGRect(x: 0, y: -1, width: 11, height: 11)
        let imageAttr = NSAttributedString(attachment: attachment)

        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 13),
                                                         .foregroundColor: color]
        let attrString = NSMutableAttributedString(string: "   \(number)", attributes: attributes)
        attrString.insert(imageAttr, at: 2)

        return attrString
    }
}

extension StatusRepostCellViewModel {
    func cellHeight(width: CGFloat) -> CGFloat {
        let contentWidth = width - 15 * 2
        var totalHeight: CGFloat = 0

        let topBarHeight = StatusTopToolBar.height(for: self)
        totalHeight += topBarHeight
        totalHeight += 10 // Gap

        let textHeight = statusLabelModel?.text.sc.height(labelWidth: contentWidth) ?? 0
        totalHeight += textHeight
        totalHeight += 10 // Gap

        if repostLabelModel != nil {
            let repostHeight = StatusRepostView.height(viewModel: self, width: contentWidth)
            totalHeight += repostHeight
            totalHeight += 10 // Gap
        } else if let picUrls = self.picUrls,
                  picUrls.count > 0 {
            let picsHeight = StatusPicturesView.height(for: picUrls)
            totalHeight += picsHeight
            totalHeight += 10 // Gap
        } else if self.videoModel != nil {
            let height = VideoCoverImageView.height(width: contentWidth)
            totalHeight += height
            totalHeight += 10 // Gap
        }

        return totalHeight
    }
}
