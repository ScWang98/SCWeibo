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

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let width = self.width / 3.0
        repostButton.frame = CGRect(x: width * 0, y: 0, width: width, height: self.height)
        commentsButton.frame = CGRect(x: width * 1, y: 0, width: width, height: self.height)
        likeButton.frame = CGRect(x: width * 2, y: 0, width: width, height: self.height)
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
        repostButton.mn_toolButton(type: .repost)
        commentsButton.mn_toolButton(type: .comments)
        likeButton.mn_toolButton(type: .like)
        line.backgroundColor = UIColor.sc.color(with: 0xF2F2F2FF)

        addSubview(repostButton)
        addSubview(commentsButton)
        addSubview(likeButton)
        addSubview(line)
    }
}
