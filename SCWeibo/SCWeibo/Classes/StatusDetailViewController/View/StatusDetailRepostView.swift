//
//  StatusDetailRepostView.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/10.
//

import UIKit

class StatusDetailRepostView: UIView {
    var viewModel: StatusDetailViewModel?

    let contentLabel = MNLabel()
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

    func reload(with viewModel: StatusDetailViewModel) {
        self.viewModel = viewModel

        contentLabel.attributedText = viewModel.repostAttrText
        picturesView.reload(with: viewModel.picUrls ?? [])

        setNeedsLayout()
    }

    static func height(for viewModel: StatusDetailViewModel) -> CGFloat {
        let width = UIScreen.sc.screenWidth - 2 * 12
        let textSize = CGSize(width: width, height: 0)
        let rect = viewModel.repostAttrText?.boundingRect(with: textSize, options: [.usesLineFragmentOrigin], context: nil)
        let textHeight = rect?.height ?? 0

        let picHeight = StatusPicturesView.height(for: viewModel.picUrls ?? [])

        let gap: CGFloat = 12.0
        return gap + textHeight + gap + picHeight + gap
    }
}

private extension StatusDetailRepostView {
    func setupSubviews() {
        backgroundColor = UIColor.sc.color(with: 0xF7F7F7FF)

        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .left
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.textColor = UIColor.darkGray

        addSubview(contentLabel)
        addSubview(picturesView)
    }

    func setupLayout() {
        let gap: CGFloat = 12
        let picHeight = StatusPicturesView.height(for: viewModel?.picUrls ?? [])
        picturesView.anchorToEdge(.bottom, padding: gap, width: width - gap * 2, height: picHeight)
        contentLabel.anchorToEdge(.top, padding: gap, width: width - gap * 2, height: picturesView.top - gap * 2)
    }
}
