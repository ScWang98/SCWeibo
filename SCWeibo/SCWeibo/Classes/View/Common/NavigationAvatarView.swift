//
//  NavigationAvatarView.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/24.
//

import UIKit
import Kingfisher

class NavigationAvatarView: UIImageView {
    var clickAction: (() -> Void)?
    
    private lazy var defaultImage = UIImage(named: "avatar_default_big")?.sc.compressImage(to: CGSize(width: 30, height: 30))

    var avatarURL: String? {
        didSet {
            if let urlString = avatarURL,
               let url = URL(string: urlString) {
                // 如果直接把image给imageView，view会自动根据image大小而变化，原因未知，所以这里把image缩放为指定大小
                ImageDownloader.default.downloadImage(with: url) { result in
                    switch result {
                    case let .success(imageResult):
                        self.image = imageResult.image.sc.compressImage(to: CGSize(width: 30, height: 30))
                    default:
                        self.image = self.defaultImage
                    }
                }
            } else {
                self.image = defaultImage
            }
        }
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 1
        layer.borderColor = UIColor.sc.color(RGBA: 0x7F7F7F4D).cgColor
        clipsToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(avatarDidClicked))
        addGestureRecognizer(tap)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        layer.cornerRadius = width / 2
    }
    
    @objc private func avatarDidClicked() {
        clickAction?()
    }
}
