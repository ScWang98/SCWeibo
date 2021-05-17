//
//  ProfileFollowUserCell.swift
//  SCWeibo
//
//  Created by 王书超 on 2021/5/17.
//

import UIKit

class ProfileFollowUserCell: UITableViewCell {
    var viewModel: ProfileFollowUserCellViewModel?

    let avatarImageView = UIImageView()
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
    let followButton = UIButton()
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

extension ProfileFollowUserCell {
    func reload(with viewModel: ProfileFollowUserCellViewModel) {
        self.viewModel = viewModel

        let placeholder = UIImage(named: "avatar_default_big")
        if let urlString = viewModel.avatarUrl,
           let url = URL(string: urlString) {
            avatarImageView.kf.setImage(with: url, placeholder: placeholder, options: nil, completionHandler: nil)
        } else {
            avatarImageView.image = placeholder
        }

        nameLabel.text = viewModel.screenName
        descriptionLabel.text = viewModel.description
        
        refreshFollowButton()

        setNeedsLayout()
    }
}

// MARK: - Private Methods

private extension ProfileFollowUserCell {
    func setupSubviews() {
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.sc.color(RGBA: 0xD8D8D8FF).cgColor

        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)

        nameLabel.textColor = UIColor.sc.color(RGB: 0x303030)
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        
        followButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        followButton.layer.cornerRadius = 3.5
        followButton.addTarget(self, action: #selector(followButtonDidClicked(button:)), for: .touchUpInside)

        separatorLine.backgroundColor = UIColor.sc.color(RGBA: 0xC7C7CCFF)

        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(followButton)
        contentView.addSubview(separatorLine)
    }

    func setupLayout() {

        avatarImageView.anchorToEdge(.left, padding: 23, width: 50, height: 50)
        var buttonWidth: CGFloat = 0
        switch viewModel?.followState {
        case .unFollowing:
            buttonWidth = 47
        case .following:
            buttonWidth = 60
        case .mutualFollowing:
            buttonWidth = 74
        case .none:
            buttonWidth = 0
        }
        followButton.anchorToEdge(.right, padding: 23, width: buttonWidth, height: 26)
        let contentWidth = followButton.left - avatarImageView.right - 15 - 8
        nameLabel.align(.toTheRightMatchingTop, relativeTo: avatarImageView, padding: 15, width: contentWidth, height: 20)
        descriptionLabel.align(.toTheRightMatchingBottom, relativeTo: avatarImageView, padding: 15, width: contentWidth, height: 20)
        separatorLine.anchorInCorner(.bottomRight, xPad: 0, yPad: 0, width: width - 15, height: 1 / UIScreen.main.scale)
    }
    
    func refreshFollowButton() {
        guard let followState = viewModel?.followState else {
            return
        }
        switch followState {
        case .unFollowing:
            followButton.setTitle("关注", for: .normal)
            followButton.setTitleColor(UIColor.sc.color(RGB: 0x0099FF), for: .normal)
            followButton.layer.borderWidth = 1
            followButton.layer.borderColor = UIColor.sc.color(RGB: 0x0099FF).cgColor
            followButton.backgroundColor = nil
        case .following:
            followButton.setTitle("已关注", for: .normal)
            followButton.setTitleColor(UIColor.white, for: .normal)
            followButton.layer.borderWidth = 0
            followButton.layer.borderColor = nil
            followButton.backgroundColor = UIColor.sc.color(RGB: 0x0099FF)
        case .mutualFollowing:
            followButton.setTitle("互相关注", for: .normal)
            followButton.setTitleColor(UIColor.white, for: .normal)
            followButton.layer.borderWidth = 0
            followButton.layer.borderColor = nil
            followButton.backgroundColor = UIColor.sc.color(RGB: 0x0099FF)
        }
        setNeedsLayout()
    }
    
    @objc func followButtonDidClicked(button: UIButton) {
        guard let viewModel = viewModel else {
            return
        }
        switch viewModel.followState {
        case .unFollowing:
            viewModel.sendFollowAction(follow: true) {
                self.refreshFollowButton()
            }
            viewModel.user.following = true
            refreshFollowButton()
        case .following:
            fallthrough
        case .mutualFollowing:
            viewModel.sendFollowAction(follow: false) {
                self.refreshFollowButton()
            }
            viewModel.user.following = false
        }
    }
}
