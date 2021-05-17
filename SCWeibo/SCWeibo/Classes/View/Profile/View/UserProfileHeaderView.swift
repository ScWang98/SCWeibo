//
//  UserProfileHeaderView.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/1.
//

import UIKit

protocol UserProfileHeaderViewDelegate: class {
    func followingDidClicked(headerView: UserProfileHeaderView)
    func followerDidClicked(headerView: UserProfileHeaderView)
}

class UserProfileHeaderView: UIView {
    weak var delegate: UserProfileHeaderViewDelegate?
    
    let avatarImage = UIImageView()
    let nickNameLabel = UILabel()
    let descriptionLabel = UILabel()
    let locationLabel = UILabel()
    let weiboLabel = UILabel()
    let followLabel = UILabel()
    let fansLabel = UILabel()
    let followButton = UIButton()

    weak var viewModel: UserProfileViewModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        configConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func reload(with viewModel: UserProfileViewModel) {
        self.viewModel = viewModel
        avatarImage.kf.setImage(with: viewModel.avatar, placeholder: avatarImage.image)
        nickNameLabel.attributedText = viewModel.screenName
        descriptionLabel.text = viewModel.description
        locationLabel.attributedText = viewModel.location
        followLabel.attributedText = viewModel.followCountAttrStr
        weiboLabel.attributedText = viewModel.statusesCountAttrStr
        fansLabel.attributedText = viewModel.followersCountAttrStr
        
        refreshFollowButton()
    }
    
    func refreshFollowButton() {
        if let viewModel = viewModel {
            followButton.isHidden = viewModel.isSelf
            followButton.isSelected = viewModel.following
        }
    }
}

// MARK: - UI

private extension UserProfileHeaderView {
    func setupSubviews() {
        backgroundColor = UIColor.white

        avatarImage.layer.cornerRadius = 40
        avatarImage.isUserInteractionEnabled = true
        avatarImage.clipsToBounds = true
        avatarImage.layer.borderWidth = 1
        avatarImage.layer.borderColor = UIColor.sc.color(RGBA: 0xD8D8D8FF).cgColor
        avatarImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(avatarClickedAction(sender:))))

        nickNameLabel.textAlignment = .center
        nickNameLabel.font = UIFont.boldSystemFont(ofSize: 16)

        descriptionLabel.textAlignment = .center
        descriptionLabel.font = UIFont.systemFont(ofSize: 15)

        locationLabel.textAlignment = .center

        followLabel.isUserInteractionEnabled = true
        followLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(followLabelClickedAction(sender:))))

        fansLabel.isUserInteractionEnabled = true
        fansLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fansLabelClickedAction(sender:))))

        let color = UIColor.sc.color(RGB: 0x0099FF)
        followButton.setTitle("关注", for: .normal)
        followButton.setTitleColor(color, for: .normal)
        followButton.setBackgroundImage(nil, for: .normal)
        followButton.setTitle("已关注", for: .selected)
        followButton.setTitleColor(UIColor.white, for: .selected)
        followButton.setBackgroundImage(UIImage.sc.image(color: color), for: .selected)
        followButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = color.cgColor
        followButton.layer.cornerRadius = 4
        followButton.clipsToBounds = true
        followButton.addTarget(self, action: #selector(followButtonClickedAction(button:)), for: .touchUpInside)

        addSubview(avatarImage)
        addSubview(nickNameLabel)
        addSubview(descriptionLabel)
        addSubview(locationLabel)
        addSubview(weiboLabel)
        addSubview(followLabel)
        addSubview(fansLabel)
        addSubview(followButton)
    }

    func configConstraints() {
        avatarImage.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.centerX.equalTo(self)
            make.top.equalToSuperview().offset(10)
        }
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImage.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(25)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(25)
        }
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(25)
        }
        followLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
        weiboLabel.snp.makeConstraints { make in
            make.right.equalTo(followLabel.snp.left).offset(-10)
            make.centerY.equalTo(followLabel)
        }
        fansLabel.snp.makeConstraints { make in
            make.left.equalTo(followLabel.snp.right).offset(10)
            make.centerY.equalTo(followLabel)
        }
        followButton.snp.makeConstraints { make in
            make.left.equalTo(avatarImage.snp.right).offset(12)
            make.centerY.equalTo(avatarImage).offset(10)
            make.width.equalTo(80)
            make.height.equalTo(26)
        }
    }
}

// MARK: - Action

@objc private extension UserProfileHeaderView {
    func avatarClickedAction(sender: UIImageView) {
    }

    func followLabelClickedAction(sender: UILabel) {
        delegate?.followingDidClicked(headerView: self)
    }

    func fansLabelClickedAction(sender: UILabel) {
        delegate?.followerDidClicked(headerView: self)
    }

    func followButtonClickedAction(button: UIButton) {
        viewModel?.sendFollowAction(follow: !button.isSelected) {
            self.refreshFollowButton()
        }
        viewModel?.user?.following = !button.isSelected

//        Router.open(url: "pillar://h5login")
    }
}
