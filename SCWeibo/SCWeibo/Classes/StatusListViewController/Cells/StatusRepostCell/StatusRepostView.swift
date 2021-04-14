//
//  StatusRepostView.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/9.
//

import UIKit

class StatusRepostView: UIView {
    var viewModel: StatusRepostCellViewModel?

    let contentLabel = ContentLabel()
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

    func reload(with viewModel: StatusRepostCellViewModel) {
        self.viewModel = viewModel

        contentLabel.textModel = viewModel.repostLabelModel
        picturesView.reload(with: viewModel.picUrls ?? [])

        setNeedsLayout()
    }

    static func height(for viewModel: StatusRepostCellViewModel) -> CGFloat {
        let width = UIScreen.sc.screenWidth - 2 * 12
        let textSize = CGSize(width: width, height: 0)
        let rect = viewModel.repostLabelModel?.text.boundingRect(with: textSize, options: [.usesLineFragmentOrigin], context: nil)
        let textHeight = rect?.height ?? 0

        let picHeight = StatusPicturesView.height(for: viewModel.picUrls ?? [])

        let gap: CGFloat = 12.0
        return gap + textHeight + gap + picHeight + gap
    }
}

private extension StatusRepostView {
    func setupSubviews() {
        backgroundColor = UIColor.sc.color(RGBA: 0xF7F7F7FF)

        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .left
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.textColor = UIColor.darkGray
        contentLabel.delegate = self

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

extension StatusRepostView: ContentLabelDelegate {
    func contentLabel(label: ContentLabel, didTapSchema: String) {
    }
}
