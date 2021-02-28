//
//  MineTopToolBar.swift
//  MNWeibo
//
//  Created by scwang on 2021/3/1.
//  Copyright © 2021 miniLV. All rights reserved.
//

import UIKit

class MineTopToolBar: UIView {
    let settingButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UI

private extension MineTopToolBar {
    func setupSubviews() {
        settingButton.setTitle("设置", for: .normal)
        settingButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        settingButton.sizeToFit()
        settingButton.addTarget(self, action: #selector(settingButtonClickedAction(button:)), for: .touchUpInside)
        addSubview(settingButton)

        settingButton.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview().offset(-12)
        }
    }
}

// MARK: Action

@objc private extension MineTopToolBar {
    func settingButtonClickedAction(button: UIButton) {
        print("设置页")
    }
}
