//
//  HomeCellTopActionBar.swift
//  MNWeibo
//
//  Created by scwang on 2021/2/25.
//  Copyright © 2021 miniLV. All rights reserved.
//

import Neon
import Kingfisher

class HomeCellTopActionBar: UIView {
    var avatarImageView = UIImageView()
    var vipIconView = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
    var nameLabel = UILabel()
    var levelIconView = UIImageView(image: UIImage(named: "common_icon_membership"))
    var timeLabel = UILabel()
    var sourceLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reload(viewModel: MNStatusViewModel?) {
        nameLabel.text = viewModel?.status.user?.screen_name
        // 提前计算好
        vipIconView.image = viewModel?.vipIcon
        levelIconView.image = viewModel?.levelIcon
        
        let placeholder = UIImage(named: "avatar_default_big")
        if let urlString = viewModel?.status.user?.profile_image_url,
           let url = URL.init(string: urlString) {
            avatarImageView.kf.setImage(with: url, placeholder: placeholder, options: nil, completionHandler: nil)
        } else {
            avatarImageView.image = placeholder
        }
        

        sourceLabel.text = viewModel?.status.source

        // FIXME: 新浪API现在没有返回创建时间了,暂时用一个固定字符串代替
//        timeLabel.text = viewModel?.status.createDate?.mn_dateDescription
        timeLabel.text = "刚刚"
    }
}

private extension HomeCellTopActionBar {
    func setupSubviews() {
        addSubview(avatarImageView)
        addSubview(vipIconView)
        addSubview(nameLabel)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        addSubview(levelIconView)

        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 19
        avatarImageView.snp.makeConstraints { make in
            make.left.top.equalTo(self).offset(12)
            make.height.width.equalTo(38)
        }

        vipIconView.snp.makeConstraints { make in
            make.size.equalTo(MNLayout.Layout(14))
            make.centerX.equalTo(avatarImageView.snp.right).offset(-MNLayout.Layout(4))
            make.centerY.equalTo(avatarImageView.snp.bottom).offset(-MNLayout.Layout(4))
        }

        nameLabel.textColor = UIColor(rgb: 0xFC3E00)
        nameLabel.font = UIFont.systemFont(ofSize: MNLayout.Layout(13.5))
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.top).offset(MNLayout.Layout(3))
            make.left.equalTo(avatarImageView.snp.right).offset(MNLayout.Layout(MNStatusPictureOutterMargin))
        }

        timeLabel.textColor = UIColor(rgb: 0xFC6C00)
        timeLabel.font = UIFont.systemFont(ofSize: MNLayout.Layout(10))
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.bottom.equalTo(avatarImageView.snp.bottom)
        }

        sourceLabel.textColor = UIColor(rgb: 0x828282)
        sourceLabel.font = UIFont.systemFont(ofSize: MNLayout.Layout(10))
        sourceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(timeLabel)
            make.left.equalTo(timeLabel.snp.right).offset(MNLayout.Layout(8))
        }

        levelIconView.snp.makeConstraints { make in
            make.centerY.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right).offset(MNLayout.Layout(3))
            make.size.equalTo(MNLayout.Layout(14))
        }
    }
}
