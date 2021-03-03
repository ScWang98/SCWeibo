//
//  MNHomeBaseCell.swift
//  SCWeibo
//
//  Created by scwang on 2020/3/29.
//

import UIKit

@objc protocol MNHomeCellDelegate {
    @objc optional func homeCellDidClickUrlString(cell: MNHomeBaseCell, urlStr: String)
}

class MNHomeBaseCell: UITableViewCell {
    weak var delegate: MNHomeCellDelegate?
    var viewModel: MNStatusViewModel?

    var topActionBar = HomeCellTopActionBar()
    var contentLabel = MNLabel()
    var repostLabel = MNLabel()
    //toolButton
    var bottomView: MNStatusToolView = MNStatusToolView(parentView: nil)

    var contentPictureView = MNStatusPictureView(parentView: nil, topView: nil, bottomView: nil)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()


    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reload(viewModel: MNStatusViewModel?) {
        self.viewModel = viewModel

        contentLabel.attributedText = viewModel?.statusAttrText

        bottomView.viewModel = viewModel
        contentPictureView.viewModel = viewModel

        topActionBar.reload(viewModel: viewModel)
    }

    func setupSubviews() {
        let topLineView = UIView()
        topLineView.backgroundColor = UIColor(rgb: 0xF2F2F2)
        contentView.addSubview(topLineView)
        topLineView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(MNLayout.Layout(MNStatusPictureOutterMargin))
        }
        repostLabel.delegate = self

        contentView.addSubview(topActionBar)
        topActionBar.snp.makeConstraints { make in
            make.left.right.equalTo(self)
            make.top.equalTo(topLineView.snp.bottom)
            make.height.equalTo(50)
        }

        bottomView = MNStatusToolView(parentView: self)
        
        contentLabel.delegate = self
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .left
        contentLabel.font = UIFont.systemFont(ofSize: MNLayout.Layout(15))
        contentLabel.textColor = UIColor.darkGray
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.top.equalTo(topActionBar.snp.bottom).offset(MNLayout.Layout(MNStatusPictureOutterMargin))
        }
    }
}

extension MNHomeBaseCell: MNLabelDelegate {
    func labelDidSelectedLinkText(label: MNLabel, text: String) {
        if !text.hasPrefix("http") {
            return
        }
        delegate?.homeCellDidClickUrlString?(cell: self, urlStr: text)
    }
}
