//
//  PhotoCollectionCell.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/22.
//

import UIKit

class PhotoCollectionCell: UICollectionViewCell {
    var viewModel: VideoCellViewModel?

    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}

// MARK: - Public Methods

extension PhotoCollectionCell {
    func reload(with urlString: String) {
        if let url = URL(string: urlString) {
            imageView.kf.setImage(with: url)
        }

        setNeedsLayout()
    }
}

// MARK: - Private Methods

private extension PhotoCollectionCell {
    func setupSubviews() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        contentView.addSubview(imageView)
    }

    func setupLayout() {
        imageView.frame = self.bounds
    }
}
