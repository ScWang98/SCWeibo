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
    let videoCoverView = VideoCoverImageView()

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

        if let picUrls = viewModel.picUrls,
           picUrls.count > 0 {
            picturesView.isHidden = false
            videoCoverView.isHidden = true

            picturesView.reload(with: viewModel.picUrls ?? [])
        } else if let videoModel = viewModel.videoModel {
            picturesView.isHidden = true
            videoCoverView.isHidden = false

            videoCoverView.reload(model: videoModel)
        } else {
            picturesView.isHidden = true
            videoCoverView.isHidden = true
        }

        setNeedsLayout()
    }

    class func height(viewModel: StatusRepostCellViewModel, width: CGFloat) -> CGFloat {
        var totalHeight: CGFloat = 0
        let contentWidth = width - 12 * 2

        totalHeight += 12

        let textHeight = viewModel.repostLabelModel?.text.sc.height(labelWidth: contentWidth) ?? 0
        totalHeight += textHeight
        totalHeight += 12

        if let picUrls = viewModel.picUrls,
           picUrls.count > 0 {
            let picHeight = StatusPicturesView.height(for: viewModel.picUrls, width: contentWidth)
            totalHeight += picHeight
            totalHeight += 12
        } else if viewModel.repostLabelModel != nil && viewModel.videoModel != nil {
            let height = VideoCoverImageView.height(width: contentWidth)
            totalHeight += height
            totalHeight += 12
        }

        return totalHeight
    }
}

private extension StatusRepostView {
    func setupSubviews() {
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(viewDidTap(tap:)))
        self.addGestureRecognizer(tap)
        backgroundColor = UIColor.sc.color(RGB: 0x767680, alpha: 0.12)
        layer.cornerRadius = 6

        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .left
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.textColor = UIColor.darkGray
        contentLabel.delegate = self

        addSubview(contentLabel)
        addSubview(picturesView)
        addSubview(videoCoverView)
    }

    func setupLayout() {
        let contentWidth = width - 12 * 2
        let textHeight = viewModel?.repostLabelModel?.text.sc.height(labelWidth: contentWidth) ?? 0
        contentLabel.anchorToEdge(.top, padding: 12, width: contentWidth, height: textHeight)

        let picHeight = StatusPicturesView.height(for: viewModel?.picUrls ?? [], width: contentWidth)
        picturesView.align(.underCentered, relativeTo: contentLabel, padding: 12, width: contentWidth, height: picHeight)

        let videoHeight = VideoCoverImageView.height(width: contentWidth)
        videoCoverView.align(.underCentered, relativeTo: contentLabel, padding: 12, width: contentWidth, height: videoHeight)
    }
    
    @objc func viewDidTap(tap: UITapGestureRecognizer) {
        guard let status = viewModel?.status.retweetedStatus else {
            return
        }
        let userInfo = ["status": status]

        Router.open(url: "pillar://statusDetail", userInfo: userInfo)
    }
}

extension StatusRepostView: ContentLabelDelegate {
    func contentLabel(label: ContentLabel, didTap schema: String) {
        Router.open(url: schema)
    }
}
