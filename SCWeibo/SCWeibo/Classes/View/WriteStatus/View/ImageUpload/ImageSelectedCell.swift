//
//  ImageSelectedCell.swift
//  SCWeibo
//
//  Created by 王书超 on 2021/5/16.
//

import UIKit

protocol ImageSelectedCellDelegate: class {
    func deleteImageDidClicked(cell: ImageSelectedCell)
}

class ImageSelectedCell: UICollectionViewCell {
    weak var delegate: ImageSelectedCellDelegate?
    
    var viewModel: VideoCellViewModel?
    
    let deleteButteon = UIButton()
    let imageView = UIImageView()
    
    var index: Int = 0

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

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}

// MARK: - Public Methods

extension ImageSelectedCell {
    func reload(image: UIImage) {
        imageView.image = image
    }
}

// MARK: - Private Methods

private extension ImageSelectedCell {
    func setupSubviews() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        deleteButteon.setImage(UIImage.init(named: "DeleteImageButton_Normal"), for: .normal)

        contentView.addSubview(imageView)
        contentView.addSubview(deleteButteon)
    }

    func setupLayout() {
        imageView.frame = self.bounds
        deleteButteon.anchorInCorner(.topRight, xPad: -5, yPad: -5, width: 22, height: 22)
    }
    
    @objc func deleteImageDidClicked(button: UIButton) {
        delegate?.deleteImageDidClicked(cell: self)
    }
}
