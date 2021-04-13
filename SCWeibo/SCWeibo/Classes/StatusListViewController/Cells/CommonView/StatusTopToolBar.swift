//
//  StatusTopToolBar.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/7.
//

import Kingfisher
import UIKit

class StatusTopToolBar: UIView {
    var avatarImageView = UIImageView()
    var nameLabel = UILabel()
    var timeLabel = UILabel()
    var sourceLabel = UILabel()
    var viewModel: StatusCellViewModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reload(with viewModel: StatusCellViewModel) {
        self.viewModel = viewModel
        nameLabel.text = viewModel.screenName

        let placeholder = UIImage(named: "avatar_default_big")
        if let urlString = viewModel.avatarUrl,
            let url = URL(string: urlString) {
            avatarImageView.kf.setImage(with: url, placeholder: placeholder, options: nil, completionHandler: nil)
        } else {
            avatarImageView.image = placeholder
        }

        sourceLabel.text = viewModel.source

        timeLabel.text = viewModel.createdAt
    }

    static func height(for viewModel: StatusCellViewModel) -> CGFloat {
        return 60.0
    }
}

private extension StatusTopToolBar {
    func setupSubviews() {
        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(timeLabel)
        addSubview(sourceLabel)

        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 19
        avatarImageView.snp.makeConstraints { make in
            make.left.top.equalTo(self).offset(12)
            make.height.width.equalTo(38)
        }

        nameLabel.textColor = UIColor.sc.color(RGBA: 0xFC3E00FF)
        nameLabel.font = UIFont.systemFont(ofSize: 13.5)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.top).offset(3)
            make.left.equalTo(avatarImageView.snp.right).offset(12)
        }

        timeLabel.textColor = UIColor.sc.color(RGBA: 0xFC6C00FF)
        timeLabel.font = UIFont.systemFont(ofSize: 10)
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(nameLabel)
            make.bottom.equalTo(avatarImageView.snp.bottom)
        }

        sourceLabel.textColor = UIColor.sc.color(RGBA: 0x828282FF)
        sourceLabel.font = UIFont.systemFont(ofSize: 10)
        sourceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(timeLabel)
            make.left.equalTo(timeLabel.snp.right).offset(8)
        }
    }
}
