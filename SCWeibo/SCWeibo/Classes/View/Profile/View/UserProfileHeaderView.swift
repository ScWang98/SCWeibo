//
//  UserProfileHeaderView.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/1.
//

import UIKit

class UserProfileHeaderView: UIView {
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
        fatalError("init(coder:) has not been implemented")
    }

    func reload(with viewModel: UserProfileViewModel) {
        self.viewModel = viewModel
        avatarImage.kf.setImage(with: viewModel.avatar, placeholder: avatarImage.image)
        nickNameLabel.text = viewModel.screenName
        descriptionLabel.text = viewModel.description
        locationLabel.text = viewModel.location
        followLabel.text = viewModel.followCountStr
        weiboLabel.text = viewModel.statusesCountStr
        fansLabel.text = viewModel.followersCountStr
    }
}

// MARK: - UI

private extension UserProfileHeaderView {
    func setupSubviews() {
        backgroundColor = UIColor.white

        avatarImage.layer.cornerRadius = 40
        avatarImage.isUserInteractionEnabled = true
        avatarImage.clipsToBounds = true
        avatarImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(avatarClickedAction(sender:))))

        nickNameLabel.textAlignment = .center

        descriptionLabel.textAlignment = .center

        locationLabel.textAlignment = .center

        followLabel.isUserInteractionEnabled = true
        followLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(followLabelClickedAction(sender:))))

        fansLabel.isUserInteractionEnabled = true
        fansLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fansLabelClickedAction(sender:))))

        followButton.setTitle("关注", for: .normal)
        followButton.setTitleColor(UIColor.red, for: .normal)
        followButton.setTitle("已关注", for: .selected)
        followButton.setTitleColor(UIColor.black, for: .selected)
        followButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor.blue.cgColor
        followButton.layer.cornerRadius = 4
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
            make.top.equalToSuperview()
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
            make.width.equalTo(60)
            make.height.equalTo(25)
        }
    }
}

// MARK: - Action

@objc private extension UserProfileHeaderView {
    func avatarClickedAction(sender: UIImageView) {
    }

    func followLabelClickedAction(sender: UILabel) {
    }

    func fansLabelClickedAction(sender: UILabel) {
    }

    func followButtonClickedAction(button: UIButton) {
        button.isSelected = !button.isSelected
        if let url = URL(string: "tt://h5login") {
            RouteManager.shared.open(url: url)
        }
    }
}
