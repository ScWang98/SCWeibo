//
//  DetailCommentTableCell.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/13.
//

import Foundation

class DetailCommentTableCell: UITableViewCell {
    var viewModel: DetailCommentCellViewModel?

    let avatarImageView = UIImageView()
    let nameLabel = UILabel()
    let contentLabel = ContentLabel()
    let commentsView = DetailCommentsView()
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

extension DetailCommentTableCell {
    func reload(with viewModel: DetailCommentCellViewModel) {
        self.viewModel = viewModel

        let placeholder = UIImage(named: "avatar_default_big")
        if let urlString = viewModel.avatarUrl,
           let url = URL(string: urlString) {
            avatarImageView.kf.setImage(with: url, placeholder: placeholder, options: nil, completionHandler: nil)
        } else {
            avatarImageView.image = placeholder
        }

        nameLabel.text = viewModel.screenName
        contentLabel.textModel = viewModel.commentLabelModel

        timeLabel.text = viewModel.createdAt

        if let commentLabelModels = viewModel.subCommentLabelModels, commentLabelModels.count > 0 {
            commentsView.isHidden = false
            commentsView.reload(labelModels: commentLabelModels, totalNumber: viewModel.totalNumber)
        } else {
            commentsView.isHidden = true
        }

        setNeedsLayout()
    }
}

// MARK: - Private Methods

private extension DetailCommentTableCell {
    func setupSubviews() {
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.layer.cornerRadius = 16
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.sc.color(RGBA: 0xD8D8D8FF).cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(avatarDidClicked(sender:)))
        avatarImageView.addGestureRecognizer(tap)

        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.boldSystemFont(ofSize: 15)

        contentLabel.textColor = UIColor.black
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.delegate = self

        timeLabel.textColor = UIColor.sc.color(RGBA: 0xAAAAAAFF)
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        
        separatorLine.backgroundColor = UIColor.sc.color(RGBA: 0xC7C7CCFF)

        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(commentsView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(separatorLine)
    }

    func setupLayout() {
        let contentWidth = width - 15 - 32 - 15 - 15

        avatarImageView.anchorInCorner(.topLeft, xPad: 15, yPad: 15, width: 32, height: 32)
        nameLabel.align(.toTheRightMatchingTop, relativeTo: avatarImageView, padding: 15, width: contentWidth, height: 20)
        timeLabel.anchorInCorner(.bottomLeft, xPad: 15 + 32 + 15, yPad: 8, width: contentWidth, height: 17)

        let contentHeight = viewModel?.commentLabelModel?.text.sc.height(labelWidth: contentWidth) ?? 0
        contentLabel.frame = CGRect(x: nameLabel.left, y: 45, width: contentWidth, height: contentHeight)

        if !commentsView.isHidden {
            let commentsHeight = DetailCommentsView.height(for: viewModel?.subCommentLabelModels ?? [], totalNumber: viewModel?.totalNumber ?? 0, commentsWidth: contentWidth)
            commentsView.frame = CGRect(x: nameLabel.left, y: contentLabel.bottom + 10, width: contentWidth, height: commentsHeight)
        }
        
        separatorLine.anchorInCorner(.bottomRight, xPad: 0, yPad: 0, width: self.width - 15, height: 1 / UIScreen.main.scale)
    }
}

@objc private extension DetailCommentTableCell {
    func avatarDidClicked(sender: Any) {
        guard let user = viewModel?.model.user else {
            return
        }
        
        let userInfo = ["user": user]
        Router.open(url: "pillar://userProfile", userInfo: userInfo)
    }
}

extension DetailCommentTableCell: ContentLabelDelegate {
    func contentLabel(label: ContentLabel, didTap schema: String) {
        Router.open(url: schema)
    }
}
