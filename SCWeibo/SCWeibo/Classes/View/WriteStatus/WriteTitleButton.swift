//
//  WriteTitleButton.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/22.
//

import UIKit

class WriteTitleButton: UIView {
    private let topLabel = UILabel()
    private let userNameLabel = UILabel()
    
    var userName: String? {
        set (userName) {
            userNameLabel.text = userName
            userNameLabel.sizeToFit()
        }
        get {
            userNameLabel.text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        topLabel.text = "发微博"
        topLabel.font = UIFont.boldSystemFont(ofSize: 17)
        topLabel.textColor = UIColor.black
        topLabel.sizeToFit()
        addSubview(topLabel)
        topLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY)
        }

        userNameLabel.font = UIFont.systemFont(ofSize: 13)
        userNameLabel.textColor = UIColor.lightGray
        addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.snp.centerY)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
