//
//  MessageAttitudeCell.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/24.
//

import UIKit

class MessageAttitudeCell: UITableViewCell {
    var viewModel: MessageAttitudeCellViewModel?

    let avatarImageView = UIImageView()
    let nameLabel = UILabel()
    
    let backShadowView = UIView()
    let pictureView = UIImageView()
    let contentLabel = UILabel()
    
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

extension MessageAttitudeCell {
    func reload(with viewModel: MessageAttitudeCellViewModel) {
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
        
        contentLabel.attributedText = viewModel.contentAttrString
        if let urlString = viewModel.imageUrl,
           let url = URL(string: urlString) {
            pictureView.kf.setImage(with: url)
        }
        
        setNeedsLayout()
    }
}

// MARK: - Private Methods

private extension MessageAttitudeCell {
    func setupSubviews() {
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.layer.cornerRadius = 20
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.sc.color(RGB: 0xD8D8D8).cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(avatarDidClicked(sender:)))
        avatarImageView.addGestureRecognizer(tap)

        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        pictureView.clipsToBounds = true
        
        contentLabel.numberOfLines = 2
        
        backShadowView.backgroundColor = UIColor.sc.color(RGB: 0xEFEFF4)
        backShadowView.layer.cornerRadius = 5
        backShadowView.addSubview(contentLabel)
        backShadowView.addSubview(pictureView)

        timeLabel.textColor = UIColor.sc.color(RGBA: 0xAAAAAAFF)
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        
        separatorLine.backgroundColor = UIColor.sc.color(RGBA: 0xC7C7CCFF)

        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(backShadowView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(separatorLine)
    }

    func setupLayout() {
        let contentWidth = self.width - 16 - 40 - 9 - 16

        avatarImageView.anchorInCorner(.topLeft, xPad: 16, yPad: 12, width: 40, height: 40)
        nameLabel.align(.toTheRightMatchingTop, relativeTo: avatarImageView, padding: 9, width: contentWidth, height: 20)
        backShadowView.align(.underMatchingLeft, relativeTo: nameLabel, padding: 10, width: contentWidth, height: 56)
        timeLabel.anchorInCorner(.bottomLeft, xPad: backShadowView.left, yPad: 8, width: contentWidth, height: 17)
        separatorLine.anchorInCorner(.bottomRight, xPad: 0, yPad: 0, width: self.width - 15, height: 1 / UIScreen.main.scale)
        
        pictureView.anchorToEdge(.left, padding: 8, width: 40, height: 40)
        contentLabel.anchorToEdge(.right, padding: 8, width: backShadowView.width - 8 - 40 - 8 - 8, height: 40)
    }
}

@objc private extension MessageAttitudeCell {
    func avatarDidClicked(sender: Any) {
        guard let user = viewModel?.model.user else {
            return
        }
        
        let userInfo = ["user": user]
        Router.open(url: "pillar://userProfile", userInfo: userInfo)
    }
}
