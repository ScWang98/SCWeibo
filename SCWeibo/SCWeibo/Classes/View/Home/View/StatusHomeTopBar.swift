//
//  StatusHomeTopBar.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/14.
//

import UIKit

protocol StatusHomeTopBarDelegate: class {
    func topToolBarDidClickAvatar(_ topToolBar: StatusHomeTopBar)
    func topToolBarDidClickWrite(_ topToolBar: StatusHomeTopBar)
}

class StatusHomeTopBar: UIView {
    weak var delegate: StatusHomeTopBarDelegate?

    let avatarView = UIImageView()
    let writeButton = UIButton()
    let bottomLine = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - UI

private extension StatusHomeTopBar {
    func setupSubviews() {
        backgroundColor = UIColor.sc.color(RGBA: 0xF5F5F5FF)

        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 15
        avatarView.layer.borderWidth = 1
        avatarView.layer.borderColor = UIColor.sc.color(RGBA: 0xD9D9D9FF).cgColor
        let tap = UITapGestureRecognizer(target: self, action: #selector(avatarViewClickedAction(tap:)))
        avatarView.addGestureRecognizer(tap)

        writeButton.setTitle("发布", for: .normal)
        writeButton.setTitleColor(UIColor.blue, for: .normal)
        writeButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        writeButton.sizeToFit()
        writeButton.addTarget(self, action: #selector(writeButtonClickedAction(button:)), for: .touchUpInside)

        bottomLine.backgroundColor = UIColor.sc.color(RGBA: 0xB2B2B2FF)

        addSubview(avatarView)
        addSubview(writeButton)
        addSubview(bottomLine)

        avatarView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-7)
            make.width.height.equalTo(30)
        }
        writeButton.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview().offset(-12)
        }
        bottomLine.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}

// MARK: - Action

@objc private extension StatusHomeTopBar {
    func avatarViewClickedAction(tap: UITapGestureRecognizer) {
        delegate?.topToolBarDidClickAvatar(self)
    }

    func writeButtonClickedAction(button: UIButton) {
        Router.open(url: "pillar://test")

        delegate?.topToolBarDidClickWrite(self)
    }
}
