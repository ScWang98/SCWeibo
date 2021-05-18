//
//  WriteReferenceView.swift
//  SCWeibo
//
//  Created by 王书超 on 2021/5/16.
//

import UIKit

class WriteReferenceView: UIView {
    var avatarImageView = UIImageView()
    var nameLabel = UILabel()
    var timeLabel = UILabel()
    var contentLabel = ContentLabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }

    func reload(model: WriteReferenceModel, type: WriteType) {
        let text: String
        let urlString: String?
        let screenName: String?
        switch type {
        case .writeStatus:
            timeLabel.text = model.comment?.createdAt?.semanticDateDescription
            text = model.comment?.text ?? ""
            urlString = model.comment?.user?.avatar
            screenName = model.comment?.user?.screenName
        case .repostStatus:
            var repostStatus: StatusResponse?
            if let status = model.status?.retweetedStatus {
                repostStatus = status
            } else if let status = model.status {
                repostStatus = status
            }
            timeLabel.text = repostStatus?.createdAt?.semanticDateDescription
            text = repostStatus?.text ?? ""
            urlString = repostStatus?.user?.avatar
            screenName = repostStatus?.user?.screenName
        case .commentStatus:
            timeLabel.text = model.status?.createdAt?.semanticDateDescription
            text = model.status?.text ?? ""
            urlString = model.status?.user?.avatar
            screenName = model.status?.user?.screenName
        case .commentComment:
            timeLabel.text = model.comment?.createdAt?.semanticDateDescription
            text = model.comment?.text ?? ""
            urlString = model.comment?.user?.avatar
            screenName = model.comment?.user?.screenName
        }
        
        contentLabel.textModel = ContentHTMLParser.parseContentText(string: text, font: UIFont.systemFont(ofSize: 16))
        nameLabel.text = screenName
        let placeholder = UIImage(named: "avatar_default_big")
        if let urlString = urlString,
           let url = URL(string: urlString) {
            avatarImageView.kf.setImage(with: url, placeholder: placeholder, options: nil, completionHandler: nil)
        } else {
            avatarImageView.image = placeholder
        }
    }
}

private extension WriteReferenceView {
    func setupSubviews() {
        backgroundColor = UIColor.sc.color(RGB: 0xEFEFF4)

        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.sc.color(RGBA: 0x7F7F7F4D).cgColor
        avatarImageView.isUserInteractionEnabled = true

        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textAlignment = .left

        timeLabel.textColor = UIColor.lightGray
        timeLabel.textAlignment = .left
        timeLabel.font = UIFont.systemFont(ofSize: 14)

        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(timeLabel)
        addSubview(contentLabel)
    }

    func setupLayout() {
        avatarImageView.anchorInCorner(.topLeft, xPad: 15, yPad: 15, width: 50, height: 50)
        let contentWidth = width - 15 - 50 - 8 - 15
        nameLabel.align(.toTheRightMatchingTop, relativeTo: avatarImageView, padding: 8, width: contentWidth, height: 21)
        timeLabel.align(.toTheRightMatchingBottom, relativeTo: avatarImageView, padding: 8, width: contentWidth, height: 21)
        let textHeight = contentLabel.textModel?.text.sc.height(labelWidth: width - 15 * 2) ?? 0
        contentLabel.align(.underMatchingLeft, relativeTo: avatarImageView, padding: 8, width: width - 15 * 2, height: textHeight)
        
        self.height = contentLabel.bottom + 8
    }
}
