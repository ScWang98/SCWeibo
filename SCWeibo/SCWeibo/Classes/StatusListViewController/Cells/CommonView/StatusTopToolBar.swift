//
//  StatusTopToolBar.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/7.
//

import Kingfisher
import UIKit

class StatusTopToolBar: UIView {
    let avatarImageView = UIImageView()
    let nameLabel = UILabel()
    let timeLabel = UILabel()
    let interactiveLabel = UILabel()

    var viewModel: StatusRepostCellViewModel?

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

    func reload(with viewModel: StatusRepostCellViewModel) {
        self.viewModel = viewModel

        nameLabel.text = viewModel.screenName

        let placeholder = UIImage(named: "avatar_default_big")
        if let urlString = viewModel.avatarUrl,
           let url = URL(string: urlString) {
            avatarImageView.kf.setImage(with: url, placeholder: placeholder, options: nil, completionHandler: nil)
        } else {
            avatarImageView.image = placeholder
        }

        timeLabel.attributedText = viewModel.timeAttrString
        
        interactiveLabel.attributedText = viewModel.interactiveAttrStr
    }

    static func height(for viewModel: StatusRepostCellViewModel) -> CGFloat {
        return 52.0
    }
}

private extension StatusTopToolBar {
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
        
        interactiveLabel.textAlignment = .right

        addSubview(avatarImageView)
        addSubview(interactiveLabel)
        addSubview(nameLabel)
        addSubview(timeLabel)
    }

    func setupLayout() {
        avatarImageView.anchorInCorner(.topLeft, xPad: 15, yPad: 12, width: 40, height: 40)
        let contentWidth = width - 15 - 40 - 10 - 15
        nameLabel.align(.toTheRightMatchingTop, relativeTo: avatarImageView, padding: 10, width: contentWidth, height: 21)
        timeLabel.align(.toTheRightMatchingBottom, relativeTo: avatarImageView, padding: 10, width: contentWidth, height: 15)
        interactiveLabel.frame = nameLabel.frame
    }
}
