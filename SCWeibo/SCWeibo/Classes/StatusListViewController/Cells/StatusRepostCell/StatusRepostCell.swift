//
//  StatusRepostCell.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/7.
//

import UIKit

class StatusRepostCell: UITableViewCell {
    var viewModel: StatusRepostCellViewModel?

    let topToolBar = StatusTopToolBar()
    let contentLabel = ContentLabel()
    let repostView = StatusRepostView()
    let picturesView = StatusPicturesView()
    let videoCoverView = VideoCoverImageView()
    let separatorLine = UIView()

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

extension StatusRepostCell {
    func reload(with viewModel: StatusRepostCellViewModel) {
        self.viewModel = viewModel

        topToolBar.reload(with: viewModel)
        contentLabel.textModel = viewModel.statusLabelModel

        if viewModel.repostLabelModel != nil {
            repostView.isHidden = false
            picturesView.isHidden = true
            videoCoverView.isHidden = true

            repostView.reload(with: viewModel)
        } else if let picUrls = viewModel.picUrls,
                  picUrls.count > 0 {
            repostView.isHidden = true
            picturesView.isHidden = false
            videoCoverView.isHidden = true

            picturesView.reload(with: picUrls)
        } else if let videoModel = viewModel.videoModel {
            repostView.isHidden = true
            picturesView.isHidden = true
            videoCoverView.isHidden = false
            
            videoCoverView.reload(model: videoModel)
        } else {
            repostView.isHidden = true
            picturesView.isHidden = true
            videoCoverView.isHidden = true
        }

        setNeedsLayout()
    }
}

private extension StatusRepostCell {
    func setupSubviews() {
        contentLabel.delegate = self
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .left
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        contentLabel.textColor = UIColor.darkGray

        separatorLine.backgroundColor = UIColor.sc.color(RGBA: 0xC7C7CCFF)

        contentView.addSubview(topToolBar)
        contentView.addSubview(contentLabel)
        contentView.addSubview(repostView)
        contentView.addSubview(picturesView)
        contentView.addSubview(videoCoverView)
        contentView.addSubview(separatorLine)
    }

    func setupLayout() {
        guard let viewModel = self.viewModel else {
            return
        }
        var height: CGFloat = 0.0
        let contentWidth = contentView.width - 15 * 2

        height = StatusTopToolBar.height(for: viewModel)
        topToolBar.anchorToEdge(.top, padding: 0, width: width, height: height)

        height = viewModel.statusLabelModel?.text.sc.height(labelWidth: contentWidth) ?? 0
        contentLabel.align(.underCentered, relativeTo: topToolBar, padding: 10, width: contentWidth, height: height)

        height = StatusRepostView.height(viewModel: viewModel, width: contentWidth)
        repostView.align(.underCentered, relativeTo: contentLabel, padding: 10, width: contentWidth, height: height)

        height = StatusPicturesView.height(for: viewModel.picUrls, width: contentWidth)
        picturesView.align(.underCentered, relativeTo: contentLabel, padding: 10, width: contentWidth, height: height)
        
        height = VideoCoverImageView.height(width: contentWidth)
        videoCoverView.align(.underCentered, relativeTo: contentLabel, padding: 10, width: contentWidth, height: height)

        separatorLine.anchorInCorner(.bottomRight, xPad: 0, yPad: 0, width: width - 15, height: 1.0 / UIScreen.main.scale)
    }
}

extension StatusRepostCell: ContentLabelDelegate {
    func contentLabel(label: ContentLabel, didTap schema: String) {
        Router.open(url: schema)
    }
}
