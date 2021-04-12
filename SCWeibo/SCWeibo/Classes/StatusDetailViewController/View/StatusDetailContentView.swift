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
        fatalError("init(coder:) has not been implemented")
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
            repostView.reload(with: viewModel)
            picturesView.isHidden = true
        } else if let picUrls = viewModel.picUrls {
            picturesView.isHidden = false
            picturesView.reload(with: picUrls)
        }

        setNeedsLayout()
    }

    class func height(for viewModel: StatusDetailViewModel) -> CGFloat {
        var totalHeight: CGFloat = 0

        let authorInfoBarHeight = StatusDetailAuthorInfoBar.height(for: viewModel)
        totalHeight += authorInfoBarHeight

        let width = UIScreen.sc.screenWidth - 2 * 12
        let textSize = CGSize(width: width, height: 0)
        let rect = viewModel.statusLabelModel?.text.boundingRect(with: textSize, options: [.usesLineFragmentOrigin], context: nil)
        let textHeight = rect?.height ?? 0
        totalHeight += textHeight

        if viewModel.repostLabelModel != nil {
            let repostHeight = StatusDetailRepostView.height(for: viewModel)
            totalHeight += repostHeight
        } else if let picUrls = viewModel.picUrls {
            let picsHeight = StatusPicturesView.height(for: picUrls)
            totalHeight += picsHeight
        }
        return totalHeight + 50
    }
}

private extension StatusDetailContentView {
    func setupSubviews() {
        contentLabel.delegate = self
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .left
        contentLabel.font = UIFont.systemFont(ofSize: MNLayout.Layout(15))
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
        authorInfoBar.anchorToEdge(.top, padding: 0, width: self.width, height: height)

        let width = self.width - 2 * 12
        let textSize = CGSize(width: width, height: 0)
        let rect = viewModel.statusLabelModel?.text.boundingRect(with: textSize, options: [.usesLineFragmentOrigin], context: nil)
        let textHeight = rect?.height ?? 0
        contentLabel.align(.underCentered, relativeTo: authorInfoBar, padding: 0, width: self.width - 12 * 2, height: textHeight)

        height = StatusDetailRepostView.height(for: viewModel)
        repostView.align(.underCentered, relativeTo: contentLabel, padding: 0, width: self.width, height: height)

        height = StatusPicturesView.height(for: viewModel.picUrls ?? [StatusPicturesModel]())
        picturesView.align(.underCentered, relativeTo: contentLabel, padding: 0, width: self.width - 2 * 12, height: height)

        self.height = StatusDetailContentView.height(for: viewModel)
    }
}

extension StatusDetailContentView: ContentLabelDelegate {
    func contentLabel(label: ContentLabel, didTapSchema: String) {
    }
}
