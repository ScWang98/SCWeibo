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
    let contentLabel = MNLabel()
    let picturesView = StatusPicturesView()
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

extension StatusNormalCell: StatusCell {
    func reload(with viewModel: StatusCellViewModel) {
        guard let viewModel = viewModel as? StatusNormalCellViewModel else {
            return
        }
        self.viewModel = viewModel
        topToolBar.reload(viewModel: viewModel)
        contentLabel.attributedText = viewModel.statusAttrText
        picturesView.reload(with: viewModel.picUrls ?? [])
        bottomToolBar.reload(viewModel: viewModel)
        
        setNeedsLayout()
    }
}

private extension StatusNormalCell {
    func setupSubviews() {
        topSeperatorView.backgroundColor = UIColor(rgb: 0xF2F2F2)
        contentView.addSubview(topSeperatorView)

        contentView.addSubview(topToolBar)

        contentLabel.delegate = self
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .left
        contentLabel.font = UIFont.systemFont(ofSize: MNLayout.Layout(15))
        contentLabel.textColor = UIColor.darkGray
        contentView.addSubview(contentLabel)

        contentView.addSubview(picturesView)
        
        contentView.addSubview(bottomToolBar)
    }

    func setupLayout() {
        topSeperatorView.anchorToEdge(.top, padding: 0, width: self.width, height: 12)

        guard let viewModel = self.viewModel else {
            return
        }
        var height: CGFloat = 0.0

        height = StatusTopToolBar.height(for: viewModel)
        topToolBar.align(.underCentered, relativeTo: topSeperatorView, padding: 0, width: self.width, height: height)

        height = StatusBottomToolBar.height(for: viewModel)
        bottomToolBar.anchorToEdge(.bottom, padding: 0, width: self.width, height: height)

        height = StatusPicturesView.height(for: viewModel.picUrls ?? [])
        picturesView.align(.aboveCentered, relativeTo: bottomToolBar, padding: 0, width: self.width - 12 * 2, height: height)

        contentLabel.alignBetweenVertical(align: .underCentered, primaryView: topToolBar, secondaryView: picturesView, padding: 0, width: 0)
//        contentLabel.alignBetweenHorizontal(align: <#T##Align#>, primaryView: <#T##Frameable#>, secondaryView: <#T##Frameable#>, padding: <#T##CGFloat#>, height: <#T##CGFloat#>)
    }
}

extension StatusNormalCell: MNLabelDelegate {
    func labelDidSelectedLinkText(label: MNLabel, text: String) {
        if !text.hasPrefix("http") {
            return
        }
//        delegate?.homeCellDidClickUrlString?(cell: self, urlStr: text)
        print("homeCellDidClickUrlString")
    }
}
