//
//  DetailAttitudeTableCell.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/13.
//

import UIKit

class DetailAttitudeTableCell: UITableViewCell {
    var viewModel: DetailAttitudeCellViewModel?

    let avatarImageView = UIImageView()
    let nameLabel = UILabel()
    let bottomSeperator = UIView()

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

extension DetailAttitudeTableCell {
    func reload(with viewModel: DetailAttitudeCellViewModel) {
        self.viewModel = viewModel

        let placeholder = UIImage(named: "avatar_default_big")
        if let urlString = viewModel.avatarUrl,
           let url = URL(string: urlString) {
            avatarImageView.kf.setImage(with: url, placeholder: placeholder, options: nil, completionHandler: nil)
        } else {
            avatarImageView.image = placeholder
        }

        nameLabel.text = viewModel.screenName

        setNeedsLayout()
    }
}

// MARK: - Private Methods

private extension DetailAttitudeTableCell {
    func setupSubviews() {
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.layer.cornerRadius = 18
        avatarImageView.layer.borderWidth = 1
        avatarImageView.layer.borderColor = UIColor.sc.color(RGBA: 0xD8D8D8FF).cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(avatarDidClicked(tap:)))
        avatarImageView.addGestureRecognizer(tap)

        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont.boldSystemFont(ofSize: 15)

        bottomSeperator.backgroundColor = UIColor.sc.color(RGBA: 0xC7C6CBFF)

        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(bottomSeperator)
    }

    func setupLayout() {
        avatarImageView.anchorToEdge(.left, padding: 27, width: 36, height: 36)
        nameLabel.align(.toTheRightCentered, relativeTo: avatarImageView, padding: 8, width: width - 71, height: 36)
        bottomSeperator.anchorInCorner(.bottomRight, xPad: 0, yPad: 0, width: width - 20, height: 1 / UIScreen.main.scale)
    }
}

@objc private extension DetailAttitudeTableCell {
    func avatarDidClicked(tap: UITapGestureRecognizer) {
    }
}

extension DetailAttitudeTableCell: ContentLabelDelegate {
    func contentLabel(label: ContentLabel, didTapSchema: String) {
    }
}
