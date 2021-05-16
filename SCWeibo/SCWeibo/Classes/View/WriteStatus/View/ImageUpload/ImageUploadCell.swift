//
//  ImageUploadCell.swift
//  SCWeibo
//
//  Created by 王书超 on 2021/5/16.
//

import UIKit

class ImageUploadCell: UICollectionViewCell {
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
}

// MARK: - Private Methods

private extension ImageUploadCell {
    func setupSubviews() {
        imageView.clipsToBounds = true
        imageView.image = UIImage.init(named: "UploadImage_Normal")

        contentView.addSubview(imageView)
    }

    func setupLayout() {
        imageView.anchorInCenter(width: 50, height: 50)
    }
}
