//
//  StatusBottomToolBar.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/7.
//

import UIKit

class StatusBottomToolBar: UIView {
    let repostButton = UIButton()
    let commentsButton = UIButton()
    let likeButton = UIButton()
    let line = UIView()

    var viewModel: StatusCellViewModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let width = self.width / 3.0
        repostButton.frame = CGRect(x: width * 0, y: 0, width: width, height: height)
        commentsButton.frame = CGRect(x: width * 1, y: 0, width: width, height: height)
        likeButton.frame = CGRect(x: width * 2, y: 0, width: width, height: height)
        line.anchorToEdge(.top, padding: 0, width: self.width - 12 * 2, height: 1)
    }

    func reload(with viewModel: StatusCellViewModel) {
        self.viewModel = viewModel
        repostButton.setTitle(viewModel.repostTitle, for: .normal)
        commentsButton.setTitle(viewModel.commentTitle, for: .normal)
        likeButton.setTitle(viewModel.likeTitle, for: .normal)

        setNeedsLayout()
    }

    static func height(for viewModel: StatusCellViewModel) -> CGFloat {
        return 40.0
    }

    func setupSubviews() {
        repostButton.toolButton(type: .repost)
        commentsButton.toolButton(type: .comments)
        likeButton.toolButton(type: .like)
        line.backgroundColor = UIColor.sc.color(RGBA: 0xF2F2F2FF)

        addSubview(repostButton)
        addSubview(commentsButton)
        addSubview(likeButton)
        addSubview(line)
    }
}

private enum ToolButtonType {
    case repost
    case comments
    case like
}

private extension UIButton {
    func toolButton(type: ToolButtonType) {
        switch type {
        case .repost:
            setTitle(" 转发", for: .normal)
            setImage(UIImage(named: "timeline_icon_retweet"), for: .normal)
        case .comments:
            setTitle(" 评论", for: .normal)
            setImage(UIImage(named: "timeline_icon_comment"), for: .normal)
        case .like:
            setTitle(" 点赞", for: .normal)
            setImage(UIImage(named: "timeline_icon_unlike"), for: .normal)
            setImage(UIImage(named: "timeline_icon_like"), for: .selected)
        }
        setTitleColor(UIColor.darkGray, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }
}
