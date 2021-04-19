//
//  StatusDetailAuthorBar.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/23.
//

import UIKit

class StatusDetailAuthorInfoBar: UIView {
    var avatarImageView = UIImageView()
    var nameLabel = UILabel()
    var timeLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }

    func reload(with viewModel: StatusDetailViewModel) {
        nameLabel.text = viewModel.screenName

        let placeholder = UIImage(named: "avatar_default_big")
        if let urlString = viewModel.avatarUrl,
            let url = URL(string: urlString) {
            avatarImageView.kf.setImage(with: url, placeholder: placeholder, options: nil, completionHandler: nil)
        } else {
            avatarImageView.image = placeholder
        }

        timeLabel.attributedText = viewModel.timeAttrString
    }

    static func height(for viewModel: StatusDetailViewModel) -> CGFloat {
        return 70.0
    }
}

private extension StatusDetailAuthorInfoBar {
    func setupSubviews() {
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 20
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.sc.color(RGBA: 0x7F7F7F4D).cgColor
        avatarImageView.isUserInteractionEnabled = true

        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textAlignment = .left

        timeLabel.textColor = UIColor.lightGray
        timeLabel.textAlignment = .left
        
        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(timeLabel)
    }
    
    func setupLayout() {
        avatarImageView.anchorInCorner(.topLeft, xPad: 15, yPad: 15, width: 40, height: 40)
        let contentWidth = self.width - 15 - 40 - 10 - 15
        nameLabel.align(.toTheRightMatchingTop, relativeTo: avatarImageView, padding: 10, width: contentWidth, height: 21)
        timeLabel.align(.toTheRightMatchingBottom, relativeTo: avatarImageView, padding: 10, width: contentWidth, height: 15)
    }
}

