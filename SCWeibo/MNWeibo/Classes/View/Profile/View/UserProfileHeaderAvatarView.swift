//
//  UserProfileHeaderAvatarView.swift
//  MNWeibo
//
//  Created by scwang on 2021/3/1.
//  Copyright © 2021 miniLV. All rights reserved.
//

import UIKit

class UserProfileHeaderAvatarView: UIView {
    let avatarImage = UIImageView()
    let nickNameLabel = UILabel()
    let descriptionLabel = UILabel()
    let locationLabel = UILabel()
    let weiboLabel = UILabel()
    let followLabel = UILabel()
    let fansLabel = UILabel()
    let followButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        configConstraints()
        reload()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reload() {
        avatarImage.sd_setImage(with: URL.init(string: "https://img2018.cnblogs.com/blog/1115121/201905/1115121-20190514102301527-2098166339.png"))
        nickNameLabel.text = "王铁柱啦啦啦"
        descriptionLabel.text = "你还没有描述"
        locationLabel.text = "陕西 西安"
        followLabel.text = "116 正在关注"
        weiboLabel.text = "675 微博"
        fansLabel.text = "35 粉丝"
    }
}

// MARK: UI

private extension UserProfileHeaderAvatarView {
    func setupSubviews() {
        backgroundColor = UIColor.white
        
        avatarImage.layer.cornerRadius = 30
        avatarImage.isUserInteractionEnabled = true

        followLabel.isUserInteractionEnabled = true

        fansLabel.isUserInteractionEnabled = true

        followButton.setTitle("关注", for: .normal)
        followButton.setTitleColor(UIColor.red, for: .normal)
        followButton.setTitle("已关注", for: .selected)
        followButton.setTitleColor(UIColor.black, for: .selected)
        followButton.layer.borderWidth = 2
        followButton.layer.borderColor = UIColor.blue.cgColor
        followButton.layer.cornerRadius = 4

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
            make.width.height.equalTo(60)
            make.centerX.equalTo(self)
            make.top.equalToSuperview().offset(-15)
        }
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImage.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
        }
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
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
            make.left.equalTo(followLabel.snp.right).offset(-10)
            make.centerY.equalTo(followLabel)
        }
        followButton.snp.makeConstraints { make in
            make.left.equalTo(avatarImage.snp.right).offset(12)
            make.centerY.equalTo(avatarImage).offset(10)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
    }
}

// MARK: Action

@objc private extension UserProfileHeaderAvatarView {
    func avatarClickedAction(button: UIButton) {
    }

    func followLabelClickedAction(button: UIButton) {
    }

    func fansLabelClickedAction(button: UIButton) {
    }
    
    func followButtonClickedAction(button: UIButton) {
        button.isSelected = !button.isSelected
        
    }
}
