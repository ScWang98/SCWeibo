//
//  StatusDetailRepostView.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/10.
//

import UIKit

class StatusDetailRepostView: UIView {
    var viewModel: StatusDetailViewModel?

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

    func reload(with viewModel: StatusDetailViewModel) {
        self.viewModel = viewModel

        contentLabel.textModel = viewModel.repostLabelModel
        picturesView.reload(with: viewModel.picUrls ?? [])

        setNeedsLayout()
    }

    static func height(for viewModel: StatusDetailViewModel, width: CGFloat) -> CGFloat {
        var totalHeight: CGFloat = 0

        totalHeight += 15

        let textHeight = viewModel.repostLabelModel?.text.sc.height(labelWidth: width - 30) ?? 0
        totalHeight += textHeight
        totalHeight += 15

        let picHeight = StatusPicturesView.height(for: viewModel.picUrls ?? [], width: width)
        totalHeight += picHeight

        return totalHeight
    }
}

private extension StatusDetailRepostView {
    func setupSubviews() {
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(viewDidTap(tap:)))
        self.addGestureRecognizer(tap)
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.sc.color(RGBA: 0xEFEFF4FF).cgColor

        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .left
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.textColor = UIColor.darkGray
        contentLabel.delegate = self

        addSubview(contentLabel)
        addSubview(picturesView)
    }

    func setupLayout() {
        let textHeight = viewModel?.repostLabelModel?.text.sc.height(labelWidth: width - 30) ?? 0
        contentLabel.anchorToEdge(.top, padding: 15, width: width - 15 * 2, height: textHeight)

        let picHeight = StatusPicturesView.height(for: viewModel?.picUrls ?? [], width: width)
        picturesView.anchorToEdge(.bottom, padding: 0, width: width, height: picHeight)
    }
    
    @objc func viewDidTap(tap: UITapGestureRecognizer) {
        guard let status = viewModel?.status?.retweetedStatus else {
            return
        }
        let userInfo = ["status": status]

        Router.open(url: "pillar://statusDetail", userInfo: userInfo)
    }
}

extension StatusDetailRepostView: ContentLabelDelegate {
    func contentLabel(label: ContentLabel, didTap schema: String) {
        Router.open(url: schema)
    }
}
