//
//  MessageCommentCell.swift
//  SCWeibo
//
//  Created by 王书超 on 2021/4/24.
//

import UIKit

class MessageCommentCell: UITableViewCell {
    var viewModel: MessageCommentCellViewModel?

    let avatarImageView = UIImageView()
    let nameLabel = UILabel()

    let leftSeparator = UIView()
    let commentLabel = ContentLabel()
    let statusLabel = ContentLabel()

    let timeLabel = UILabel()
    let separatorLine = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
}

// MARK: - Public Methods

extension MessageCommentCell {
    func reload(with viewModel: MessageCommentCellViewModel) {
        self.viewModel = viewModel

        let placeholder = UIImage(named: "avatar_default_big")
        if let urlString = viewModel.avatarUrl,
           let url = URL(string: urlString) {
            avatarImageView.kf.setImage(with: url, placeholder: placeholder, options: nil, completionHandler: nil)
        } else {
            avatarImageView.image = placeholder
        }

        nameLabel.text = viewModel.screenName
        timeLabel.text = viewModel.createdAt

        commentLabel.textModel = viewModel.commentLabelModel
        statusLabel.textModel = viewModel.statusLabelModel

        setNeedsLayout()
    }
}

// MARK: - Private Methods

private extension MessageCommentCell {
    func setupSubviews() {
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.layer.cornerRadius = 20
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.sc.color(RGBA: 0xD8D8D8FF).cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(avatarDidClicked(sender:)))
        avatarImageView.addGestureRecognizer(tap)

        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.boldSystemFont(ofSize: 15)

        timeLabel.textColor = UIColor.sc.color(RGBA: 0xAAAAAAFF)
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        
        leftSeparator.backgroundColor = UIColor.sc.color(RGB: 0xEFEFF4)

        separatorLine.backgroundColor = UIColor.sc.color(RGBA: 0xC7C7CCFF)

        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(commentLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(leftSeparator)
        contentView.addSubview(timeLabel)
        contentView.addSubview(separatorLine)
    }

    func setupLayout() {
        let contentWidth = width - 15 - 40 - 10 - 15

        avatarImageView.anchorInCorner(.topLeft, xPad: 15, yPad: 15, width: 40, height: 40)

        nameLabel.align(.toTheRightMatchingTop, relativeTo: avatarImageView, padding: 10, width: contentWidth, height: 20)

        let commentHeight = viewModel?.commentLabelModel?.text.sc.height(labelWidth: contentWidth) ?? 0
        commentLabel.align(.underMatchingLeft, relativeTo: nameLabel, padding: 10, width: contentWidth, height: commentHeight)

        let statusHeight = viewModel?.statusLabelModel?.text.sc.height(labelWidth: contentWidth - 16) ?? 0
        statusLabel.align(.underMatchingRight, relativeTo: commentLabel, padding: 8, width: contentWidth - 16, height: statusHeight)
        leftSeparator.align(.toTheLeftCentered, relativeTo: statusLabel, padding: 10, width: 6, height: statusHeight)

        timeLabel.anchorInCorner(.bottomLeft, xPad: nameLabel.left, yPad: 8, width: contentWidth, height: 17)

        separatorLine.anchorInCorner(.bottomRight, xPad: 0, yPad: 0, width: width - 15, height: 1 / UIScreen.main.scale)
    }
}

@objc private extension MessageCommentCell {
    func avatarDidClicked(sender: Any) {
        guard let user = viewModel?.model.user else {
            return
        }
        
        let userInfo = ["user": user]
        Router.open(url: "pillar://userProfile", userInfo: userInfo)
    }
}
