//
//  DetailRepostTableCell.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/11.
//

import UIKit

class DetailRepostTableCell: UITableViewCell {
    var viewModel: DetailRespostCellViewModel?

    let avatarImageView = UIImageView()
    let nameLabel = UILabel()
    let contentLabel = ContentLabel()
    let timeLabel = UILabel()
    let bottomSeperator = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
}

// MARK: - Public Methods

extension DetailRepostTableCell {
    func reload(with viewModel: DetailRespostCellViewModel) {
        self.viewModel = viewModel

        let placeholder = UIImage(named: "avatar_default_big")
        if let urlString = viewModel.avatarUrl,
           let url = URL(string: urlString) {
            avatarImageView.kf.setImage(with: url, placeholder: placeholder, options: nil, completionHandler: nil)
        } else {
            avatarImageView.image = placeholder
        }

        nameLabel.text = viewModel.screenName
        contentLabel.textModel = viewModel.commentLabelModel
        
        timeLabel.text = viewModel.createdAt

        setNeedsLayout()
    }
}

// MARK: - Private Methods

private extension DetailRepostTableCell {
    func setupSubviews() {
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.layer.cornerRadius = 16
        let tap = UITapGestureRecognizer(target: self, action: #selector(avatarDidClicked(tap:)))
        avatarImageView.addGestureRecognizer(tap)
        
        nameLabel.textColor = UIColor.sc.color(with: 0xFC3E00FF)
        nameLabel.font = UIFont.boldSystemFont(ofSize: 15)

        contentLabel.textColor = UIColor.black
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.delegate = self

        timeLabel.textColor = UIColor.sc.color(with: 0xAAAAAAFF)
        timeLabel.font = UIFont.systemFont(ofSize: 14)

        bottomSeperator.backgroundColor = UIColor.sc.color(with: 0xF2F2F2FF)

        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(bottomSeperator)
    }

    func setupLayout() {
        avatarImageView.anchorInCorner(.topLeft, xPad: 20, yPad: 12, width: 32, height: 32)
        nameLabel.align(.toTheRightMatchingTop, relativeTo: avatarImageView, padding: 15, width: self.width - 70, height: 16)
        timeLabel.anchorInCorner(.bottomLeft, xPad: 66, yPad: 8, width: self.width - 66, height: 16)
        bottomSeperator.anchorInCorner(.bottomRight, xPad: 0, yPad: 0, width: self.width - 20, height: 1)
        contentLabel.frame = CGRect(x: nameLabel.left, y: avatarImageView.bottom, width: self.width - nameLabel.left - 26, height: timeLabel.top - nameLabel.bottom)
    }
}

@objc private extension DetailRepostTableCell {
    func avatarDidClicked(tap: UITapGestureRecognizer) {
    }
}

extension DetailRepostTableCell: ContentLabelDelegate {
    func contentLabel(label: ContentLabel, didTapSchema: String) {
        <#code#>
    }
    
    
}
