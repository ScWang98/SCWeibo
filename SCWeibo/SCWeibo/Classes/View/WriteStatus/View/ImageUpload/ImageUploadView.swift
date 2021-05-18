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

    var pagesObservation: NSKeyValueObservation?

    deinit {
        pagesObservation?.invalidate()
    }

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
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        flowLayout.scrollDirection = .vertical
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        collectionView.register(ImageUploadCell.self, forCellWithReuseIdentifier: String(describing: ImageUploadCell.self))
        collectionView.register(ImageSelectedCell.self, forCellWithReuseIdentifier: String(describing: ImageSelectedCell.self))
        collectionView.frame = bounds
        pagesObservation = collectionView.observe(\.contentSize, options: [.initial, .new, .old], changeHandler: { collectionView, _ in
            let contentInset = collectionView.contentInset
            self.height = collectionView.contentSize.height + contentInset.top + contentInset.bottom
            collectionView.frame = self.bounds
        })
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
            cell.index = indexPath.row
            cell.delegate = self
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row >= photos.count {
            delegate?.addImageDidClicked(uploadView: self)
        }
    }
}

// MARK: - ImageSelectedCellDelegate

extension ImageUploadView: ImageSelectedCellDelegate {
    func deleteImageDidClicked(cell: ImageSelectedCell) {
        collectionView.performBatchUpdates {
            self.photos.remove(at: cell.index)
            self.collectionView.deleteItems(at: [IndexPath(row: cell.index, section: 0)])
        } completion: { _ in
            self.collectionView.reloadData()
        }
    }
}

// MARK: - Action

@objc private extension ImageUploadView {
}
