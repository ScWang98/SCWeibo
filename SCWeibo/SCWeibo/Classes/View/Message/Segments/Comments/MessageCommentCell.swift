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
        avatarImageView.layer.cornerRadius = 16
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.sc.color(RGBA: 0xD8D8D8FF).cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(avatarDidClicked(tap:)))
        avatarImageView.addGestureRecognizer(tap)

        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.boldSystemFont(ofSize: 15)

        timeLabel.textColor = UIColor.sc.color(RGBA: 0xAAAAAAFF)
        timeLabel.font = UIFont.systemFont(ofSize: 14)

        separatorLine.backgroundColor = UIColor.sc.color(RGBA: 0xC7C7CCFF)

        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(commentLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(separatorLine)
    }

    func setupLayout() {
        let contentWidth = width - 15 - 32 - 15 - 15

        avatarImageView.anchorInCorner(.topLeft, xPad: 15, yPad: 15, width: 32, height: 32)
        nameLabel.align(.toTheRightMatchingTop, relativeTo: avatarImageView, padding: 15, width: contentWidth, height: 20)
        timeLabel.anchorInCorner(.bottomLeft, xPad: 15 + 32 + 15, yPad: 8, width: contentWidth, height: 17)
        commentLabel.align(.underMatchingLeft, relativeTo: nameLabel, padding: 10, width: contentWidth, height: 50)
        separatorLine.anchorInCorner(.bottomRight, xPad: 0, yPad: 0, width: width - 15, height: 1 / UIScreen.main.scale)
        statusLabel.align(.underMatchingRight, relativeTo: commentLabel, padding: 20, width: contentWidth - 20, height: 100)
    }
}

@objc private extension MessageCommentCell {
    func avatarDidClicked(tap: UITapGestureRecognizer) {
    }
}
