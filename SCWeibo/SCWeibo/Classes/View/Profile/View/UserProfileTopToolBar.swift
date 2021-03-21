//
//  UserProfileTopToolBar.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/1.
//

import UIKit

protocol UserProfileTopToolBarDelegate: class {
    func topToolBarDidClickBack(_ topToolBar: UserProfileTopToolBar)
    func topToolBarDidClickSetting(_ topToolBar: UserProfileTopToolBar)
}

class UserProfileTopToolBar: UIView {
    weak var delegate: UserProfileTopToolBarDelegate?

    let backButton = UIButton()
    let settingButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI

private extension UserProfileTopToolBar {
    func setupSubviews() {
        backButton.setTitle("返回", for: .normal)
        backButton.setTitleColor(UIColor.blue, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(backButtonClickedAction(button:)), for: .touchUpInside)

        settingButton.setTitle("设置", for: .normal)
        settingButton.setTitleColor(UIColor.blue, for: .normal)
        settingButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        settingButton.sizeToFit()
        settingButton.addTarget(self, action: #selector(settingButtonClickedAction(button:)), for: .touchUpInside)

        addSubview(backButton)
        addSubview(settingButton)

        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
        settingButton.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview().offset(-12)
        }
    }
}

// MARK: - Action

@objc private extension UserProfileTopToolBar {
    func backButtonClickedAction(button: UIButton) {
        delegate?.topToolBarDidClickBack(self)
    }

    func settingButtonClickedAction(button: UIButton) {
        delegate?.topToolBarDidClickSetting(self)
    }
}
