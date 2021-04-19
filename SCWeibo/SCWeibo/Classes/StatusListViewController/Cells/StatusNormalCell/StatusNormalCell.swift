//
//  StatusNormalCell.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/7.
//

import UIKit

class StatusNormalCell: UITableViewCell {
    var viewModel: StatusNormalCellViewModel?

    let topSeperatorView = UIView()
    let topToolBar = StatusTopToolBar()
    let contentLabel = ContentLabel()
    let picturesView = StatusPicturesView()
    let bottomToolBar = StatusBottomToolBar()

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

extension StatusNormalCell: StatusCell {
    func reload(with viewModel: StatusCellViewModel) {
        guard let viewModel = viewModel as? StatusNormalCellViewModel else {
            return
        }
        self.viewModel = viewModel
//        topToolBar.reload(with: viewModel)
        contentLabel.textModel = viewModel.statusLabelModel
        picturesView.reload(with: viewModel.picUrls ?? [])
        bottomToolBar.reload(with: viewModel)

        setNeedsLayout()
    }
}

private extension StatusNormalCell {
    func setupSubviews() {
        topSeperatorView.backgroundColor = UIColor.sc.color(RGBA: 0xF2F2F2FF)

        contentLabel.delegate = self
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .left
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.textColor = UIColor.darkGray

        contentView.addSubview(topSeperatorView)
        contentView.addSubview(topToolBar)
        contentView.addSubview(contentLabel)
        contentView.addSubview(picturesView)
        contentView.addSubview(bottomToolBar)
    }

    func setupLayout() {
        topSeperatorView.anchorToEdge(.top, padding: 0, width: contentView.width, height: 12)

        guard let viewModel = self.viewModel else {
            return
        }
        var height: CGFloat = 0.0

//        height = StatusTopToolBar.height(for: viewModel)
        topToolBar.align(.underCentered, relativeTo: topSeperatorView, padding: 0, width: contentView.width, height: height)

        height = StatusBottomToolBar.height(for: viewModel)
        bottomToolBar.anchorToEdge(.bottom, padding: 0, width: contentView.width, height: height)

        height = StatusPicturesView.height(for: viewModel.picUrls ?? [])
        picturesView.align(.aboveCentered, relativeTo: bottomToolBar, padding: 8, width: contentView.width - 12 * 2, height: height)

        contentLabel.frame = CGRect(x: 12, y: topToolBar.bottom, width: contentView.width - 12 * 2, height: picturesView.top - topToolBar.bottom - 8)
    }
}

extension StatusNormalCell: ContentLabelDelegate {
    func contentLabel(label: ContentLabel, didTapSchema: String) {
    }
}
