//
//  VideoTableCell.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/17.
//

import AVKit
import UIKit

class VideoTableCell: UITableViewCell {
    var viewModel: VideoCellViewModel?

    let coverView = VideoCoverImageView()
    let titleLabel = UILabel()
    let timeLabel = UILabel()
    let bottomSeperator = UIView()

    var playerObservation: NSKeyValueObservation?

    deinit {
        playerObservation?.invalidate()
    }

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

extension VideoTableCell {
    func reload(with viewModel: VideoCellViewModel) {
        self.viewModel = viewModel

        coverView.reload(model: viewModel.videoModel)

        titleLabel.text = viewModel.text
        timeLabel.text = viewModel.createdAt

        setNeedsLayout()
    }
}

// MARK: - Private Methods

private extension VideoTableCell {
    func setupSubviews() {
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)

        timeLabel.textColor = UIColor.sc.color(RGBA: 0xAAAAAAFF)
        timeLabel.font = UIFont.systemFont(ofSize: 14)

        bottomSeperator.backgroundColor = UIColor.sc.color(RGBA: 0xF2F2F2FF)

        contentView.addSubview(coverView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(bottomSeperator)
    }

    func setupLayout() {
        let width = self.width - 12.0 * 2
        let coverHeight = self.width * 9.0 / 16.0
        coverView.anchorToEdge(.top, padding: 12.0, width: width, height: coverHeight)
        titleLabel.align(.underCentered, relativeTo: coverView, padding: 2, width: width, height: 23.0)
        timeLabel.align(.underCentered, relativeTo: titleLabel, padding: 0, width: width, height: 23.0)
        bottomSeperator.anchorToEdge(.bottom, padding: 0.0, width: self.width, height: 8.0)
    }
}
