//
//  StatusRepostCell.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/7.
//

import UIKit

class StatusRepostCell: UITableViewCell {
    var viewModel: StatusRepostCellViewModel?

    let topSeperatorView = UIView()
    let topToolBar = StatusTopToolBar()
    let contentLabel = MNLabel()
    let repostView = StatusRepostView()
    let bottomToolBar = StatusBottomToolBar()

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

extension StatusRepostCell: StatusCell {
    func reload(with viewModel: StatusCellViewModel) {
        guard let viewModel = viewModel as? StatusRepostCellViewModel else {
            return
        }
        self.viewModel = viewModel
        topToolBar.reload(with: viewModel)
        contentLabel.attributedText = viewModel.statusAttrText
        repostView.reload(with: viewModel)
        bottomToolBar.reload(with: viewModel)

        setNeedsLayout()
    }
}

private extension StatusRepostCell {
    func setupSubviews() {
        topSeperatorView.backgroundColor = UIColor(rgb: 0xF2F2F2)

        contentLabel.delegate = self
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .left
        contentLabel.font = UIFont.systemFont(ofSize: MNLayout.Layout(15))
        contentLabel.textColor = UIColor.darkGray

        contentView.addSubview(topSeperatorView)
        contentView.addSubview(topToolBar)
        contentView.addSubview(contentLabel)
        contentView.addSubview(repostView)
        contentView.addSubview(bottomToolBar)
    }

    func setupLayout() {
        topSeperatorView.anchorToEdge(.top, padding: 0, width: contentView.width, height: 12)

        guard let viewModel = self.viewModel else {
            return
        }
        var height: CGFloat = 0.0

        height = StatusTopToolBar.height(for: viewModel)
        topToolBar.align(.underCentered, relativeTo: topSeperatorView, padding: 0, width: contentView.width, height: height)

        height = StatusBottomToolBar.height(for: viewModel)
        bottomToolBar.anchorToEdge(.bottom, padding: 0, width: contentView.width, height: height)

        height = StatusRepostView.height(for: viewModel)
        repostView.align(.aboveCentered, relativeTo: bottomToolBar, padding: 0, width: contentView.width, height: height)

        contentLabel.frame = CGRect(x: 12, y: topToolBar.bottom, width: contentView.width - 12 * 2, height: repostView.top - topToolBar.bottom - 8)
    }
}

extension StatusRepostCell: MNLabelDelegate {
    func labelDidSelectedLinkText(label: MNLabel, text: String) {
        if !text.hasPrefix("http") {
            return
        }
//        delegate?.homeCellDidClickUrlString?(cell: self, urlStr: text)
        print("homeCellDidClickUrlString")
    }
}
