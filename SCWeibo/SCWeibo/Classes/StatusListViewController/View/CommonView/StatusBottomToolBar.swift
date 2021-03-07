//
//  StatusBottomToolBar.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/7.
//

import UIKit

class StatusBottomToolBar: UIStackView {
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
        line.anchorToEdge(.top, padding: 0, width: self.width - 12 * 2, height: 1)
    }

    func reload(viewModel: StatusCellViewModel) {
        self.viewModel = viewModel
        repostButton.setTitle(viewModel.repostTitle, for: .normal)
        commentsButton.setTitle(viewModel.commentTitle, for: .normal)
        likeButton.setTitle(viewModel.likeTitle, for: .normal)
    }

    static func height(for viewModel: StatusCellViewModel) -> CGFloat {
        return 40.0
    }
    
    func setupSubviews() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.alignment = .fill
        self.distribution = .fillEqually
        self.spacing = 0
        self.axis = .horizontal

        repostButton.mn_toolButton(type: .repost)
        addArrangedSubview(repostButton)

        commentsButton.mn_toolButton(type: .comments)
        addArrangedSubview(commentsButton)

        likeButton.mn_toolButton(type: .like)
        addArrangedSubview(likeButton)

        
        line.backgroundColor = UIColor(rgb: 0xF2F2F2)
        addSubview(line)
    }
}
