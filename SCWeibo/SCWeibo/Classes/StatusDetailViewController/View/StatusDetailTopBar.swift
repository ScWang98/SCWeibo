//
//  StatusDetailTopBar.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/23.
//

import UIKit

protocol StatusDetailTopBarDelegate: class {
    func topBarDidClickBack(_ topBar: StatusDetailTopBar)
    func topBarDidClickMore(_ topBar: StatusDetailTopBar)
}

class StatusDetailTopBar: UIView {
    weak var delegate: StatusDetailTopBarDelegate?

    let backButton = UIButton()
    let moreButton = UIButton()
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Methods
extension StatusDetailTopBar {
    func reload(with title: String) {
        titleLabel.text = title
    }
}


// MARK: - UI

private extension StatusDetailTopBar {
    func setupSubviews() {
        backButton.setTitle("back", for: .normal)
        backButton.setTitleColor(UIColor.blue, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(backButtonClickedAction(button:)), for: .touchUpInside)

        moreButton.setTitle("more", for: .normal)
        moreButton.setTitleColor(UIColor.blue, for: .normal)
        moreButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        moreButton.sizeToFit()
        moreButton.addTarget(self, action: #selector(moreButtonClickedAction(button:)), for: .touchUpInside)
        
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)

        addSubview(backButton)
        addSubview(moreButton)

        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
        moreButton.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview().offset(-12)
        }
    }
}

// MARK: - Action

@objc private extension StatusDetailTopBar {
    func backButtonClickedAction(button: UIButton) {
        delegate?.topBarDidClickBack(self)
    }

    func moreButtonClickedAction(button: UIButton) {
        delegate?.topBarDidClickMore(self)
    }
}
