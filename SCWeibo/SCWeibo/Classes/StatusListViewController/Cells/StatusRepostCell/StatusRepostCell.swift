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

            repostView.reload(with: viewModel)
        } else if let picUrls = viewModel.picUrls,
                  picUrls.count > 0 {
            repostView.isHidden = true
            picturesView.isHidden = false

            picturesView.reload(with: picUrls)
        } else {
            repostView.isHidden = true
            picturesView.isHidden = true
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
        contentView.addSubview(separatorLine)
    }

    func setupLayout() {
        guard let viewModel = self.viewModel else {
            return
        }
        var height: CGFloat = 0.0

        height = StatusTopToolBar.height(for: viewModel)
        topToolBar.anchorToEdge(.top, padding: 0, width: width, height: height)

        height = viewModel.statusLabelModel?.text.sc.height(labelWidth: contentView.width - 15 * 2) ?? 0
        contentLabel.align(.underCentered, relativeTo: topToolBar, padding: 10, width: contentView.width - 15 * 2, height: height)

        height = StatusRepostView.height(viewModel: viewModel, width: contentView.width - 15 * 2)
        repostView.align(.underCentered, relativeTo: contentLabel, padding: 10, width: contentView.width - 15 * 2, height: height)

        height = StatusPicturesView.height(for: viewModel.picUrls, width: contentView.width - 15 * 2)
        picturesView.align(.underCentered, relativeTo: contentLabel, padding: 10, width: contentView.width - 15 * 2, height: height)

        separatorLine.anchorInCorner(.bottomRight, xPad: 0, yPad: 0, width: width - 15, height: 1.0 / UIScreen.main.scale)
    }
}

extension StatusRepostCell: ContentLabelDelegate {
    func contentLabel(label: ContentLabel, didTapSchema: String) {
    }
}
