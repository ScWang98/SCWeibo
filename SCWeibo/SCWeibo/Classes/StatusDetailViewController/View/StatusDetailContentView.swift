//
//  StatusDetailContentView.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/10.
//

import UIKit

class StatusDetailContentView: UIView {
    var viewModel: StatusDetailViewModel?

    let authorInfoBar = StatusDetailAuthorInfoBar()
    let contentLabel = ContentLabel()
    let repostView = StatusDetailRepostView()
    let picturesView = StatusPicturesView()

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
}

// MARK: - Public Methods

extension StatusDetailContentView {
    func reload(with viewModel: StatusDetailViewModel) {
        self.viewModel = viewModel
        authorInfoBar.reload(with: viewModel)
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

    class func height(for viewModel: StatusDetailViewModel, width: CGFloat) -> CGFloat {
        var totalHeight: CGFloat = 0

        let authorInfoBarHeight = StatusDetailAuthorInfoBar.height(for: viewModel)
        totalHeight += authorInfoBarHeight

        let textHeight = viewModel.statusLabelModel?.text.sc.height(labelWidth: width - 15 * 2) ?? 0
        totalHeight += textHeight
        totalHeight += 10 // Gap

        if viewModel.repostLabelModel != nil {
            let repostHeight = StatusDetailRepostView.height(for: viewModel, width: width - 15 * 2)
            totalHeight += repostHeight
        } else if let picUrls = viewModel.picUrls,
                  picUrls.count > 0 {
            let picsHeight = StatusPicturesView.height(for: picUrls)
            totalHeight += picsHeight
        }
        return totalHeight + 35
    }
}

private extension StatusDetailContentView {
    func setupSubviews() {
        contentLabel.delegate = self
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .left
        contentLabel.font = UIFont.systemFont(ofSize: 16)
        contentLabel.textColor = UIColor.darkGray

        addSubview(authorInfoBar)
        addSubview(contentLabel)
        addSubview(repostView)
        addSubview(picturesView)
    }

    func setupLayout() {
        guard let viewModel = self.viewModel else {
            return
        }
        var height: CGFloat = 0.0

        height = StatusDetailAuthorInfoBar.height(for: viewModel)
        authorInfoBar.anchorToEdge(.top, padding: 0, width: width, height: height)

        height = viewModel.statusLabelModel?.text.sc.height(labelWidth: width - 15 * 2) ?? 0
        contentLabel.align(.underCentered, relativeTo: authorInfoBar, padding: 0, width: width - 15 * 2, height: height)

        height = StatusDetailRepostView.height(for: viewModel, width: width - 15 * 2)
        repostView.align(.underCentered, relativeTo: contentLabel, padding: 10, width: width - 15 * 2, height: height)

        height = StatusPicturesView.height(for: viewModel.picUrls ?? [], width: width - 15 * 2)
        picturesView.align(.underCentered, relativeTo: contentLabel, padding: 10, width: width - 15 * 2, height: height)

        self.height = StatusDetailContentView.height(for: viewModel, width: width)
    }
}

extension StatusDetailContentView: ContentLabelDelegate {
    func contentLabel(label: ContentLabel, didTapSchema: String) {
    }
}
