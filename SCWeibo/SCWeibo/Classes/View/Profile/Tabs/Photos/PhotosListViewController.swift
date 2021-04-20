//
//  PhotosListViewController.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/22.
//

import MJRefresh
import UIKit

class PhotosListViewController: UIViewController {
    let flowLayout = UICollectionViewFlowLayout()
    var collectionView: UICollectionView

    private var listViewModel = PhotosListViewModel()

    deinit {
        removeObservers()
    }

    init() {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)

        super.init(nibName: nil, bundle: nil)
        addObservers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
}

// MARK: - Public Methods

extension PhotosListViewController {
    func config(withUserId userId: String?) {
        listViewModel.config(withUserId: userId)
    }

    func refreshData(with loadingState: Bool) {
        loadDatas(with: false)
    }
}

// MARK: - UI

private extension PhotosListViewController {
    func setupSubviews() {
        let width = (view.width - 2.0 * 3) / 3.0
        flowLayout.itemSize = CGSize(width: width, height: width)
        flowLayout.minimumInteritemSpacing = 2
        flowLayout.minimumLineSpacing = 2
        flowLayout.sectionInset = UIEdgeInsets(top: 2, left: 1, bottom: 2, right: 1)
        flowLayout.scrollDirection = .vertical
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.register(PhotoCollectionCell.self, forCellWithReuseIdentifier: String(describing: PhotoCollectionCell.self))
        collectionView.frame = view.bounds
        collectionView.mj_footer = MJRefreshAutoFooter(refreshingBlock: {
            self.loadDatas(with: true)
        })
        view.addSubview(collectionView)
    }
}

// MARK: - Private Methods

private extension PhotosListViewController {
    func addObservers() {
    }

    func removeObservers() {
    }

    func loadDatas(with loadMore: Bool) {
        listViewModel.loadStatus(loadMore: loadMore) { _, needRefresh in
            self.collectionView.mj_footer?.endRefreshing()
            if needRefresh {
                self.collectionView.reloadData()
            }
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension PhotosListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listViewModel.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PhotoCollectionCell.self), for: indexPath)

        if let cell = cell as? PhotoCollectionCell {
            let photo = listViewModel.photos[indexPath.row]
            if let urlString = photo.picThumbnail {
                cell.reload(with: urlString)
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

// MARK: - Action

@objc private extension PhotosListViewController {
}
