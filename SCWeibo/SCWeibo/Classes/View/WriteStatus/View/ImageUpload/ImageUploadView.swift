//
//  ImageUploadView.swift
//  SCWeibo
//
//  Created by 王书超 on 2021/5/16.
//

import UIKit

protocol ImageUploadViewDelegate: class {
    func addImageDidClicked(uploadView: ImageUploadView)
}

class ImageUploadView: UIView {
    weak var delegate: ImageUploadViewDelegate?
    var photos = [UIImage]()

    private let flowLayout = UICollectionViewFlowLayout()
    private var collectionView: UICollectionView

    init() {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        super.init(frame: CGRect.zero)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        superview?.layoutSubviews()
        setupLayout()
    }
}

// MARK: - Public Methods

extension ImageUploadView {
    func refreshData() {
        collectionView.reloadData()
    }
}

// MARK: - Private Methods

private extension ImageUploadView {
    func setupSubviews() {
        let width = (self.width - 15 * 2 - 10.0 * 3) / 4.0
        flowLayout.itemSize = CGSize(width: width, height: width)
        flowLayout.minimumInteritemSpacing = 2
        flowLayout.minimumLineSpacing = 2
        flowLayout.sectionInset = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        flowLayout.scrollDirection = .vertical
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.register(ImageUploadCell.self, forCellWithReuseIdentifier: String(describing: ImageUploadCell.self))
        collectionView.register(ImageSelectedCell.self, forCellWithReuseIdentifier: String(describing: ImageSelectedCell.self))
        collectionView.frame = bounds
        addSubview(collectionView)
    }

    func setupLayout() {
        collectionView.frame = bounds
        let width = (self.width - 15 * 2 - 10.0 * 3) / 4.0
        flowLayout.itemSize = CGSize(width: width, height: width)
    }
}

// MARK: - Private Methods

private extension ImageUploadView {
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension ImageUploadView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row >= photos.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageUploadCell.self), for: indexPath)
            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ImageSelectedCell.self), for: indexPath)

        if let cell = cell as? ImageSelectedCell {
            let photo = photos[indexPath.row]
            cell.reload(image: photo)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row >= photos.count {
            delegate?.addImageDidClicked(uploadView: self)
        }
    }
}

// MARK: - Action

@objc private extension ImageUploadView {
}
