//
//  MessageAttitudeCell.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/24.
//

import Foundation

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
        contentLabel.attributedText = viewModel.cotentAttrString

        timeLabel.text = viewModel.createdAt
        
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
        avatarImageView.layer.cornerRadius = 16
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.sc.color(RGBA: 0xD8D8D8FF).cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(avatarDidClicked(tap:)))
        avatarImageView.addGestureRecognizer(tap)

        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        pictureView.clipsToBounds = true
        
        contentLabel.numberOfLines = 2
        
        backShadowView.backgroundColor = UIColor.sc.color(RGB: 0xEEEEEE)
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
        let contentWidth = width - 15 - 32 - 15 - 15

        avatarImageView.anchorInCorner(.topLeft, xPad: 15, yPad: 15, width: 32, height: 32)
        nameLabel.align(.toTheRightMatchingTop, relativeTo: avatarImageView, padding: 15, width: contentWidth, height: 20)
        timeLabel.anchorInCorner(.bottomLeft, xPad: 15 + 32 + 15, yPad: 8, width: contentWidth, height: 17)
        backShadowView.align(.underMatchingLeft, relativeTo: nameLabel, padding: 10, width: contentWidth, height: 50)
        separatorLine.anchorInCorner(.bottomRight, xPad: 0, yPad: 0, width: self.width - 15, height: 1 / UIScreen.main.scale)
        
        pictureView.anchorToEdge(.left, padding: 5, width: 40, height: 40)
        contentLabel.anchorToEdge(.right, padding: 5, width: backShadowView.width - 5 - 40 - 5 - 5, height: 40)
    }
}

@objc private extension MessageAttitudeCell {
    func avatarDidClicked(tap: UITapGestureRecognizer) {
    }
}
