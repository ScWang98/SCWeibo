//
//  EmojiCollectionFlowLayout.swift
//  SCWeibo
//
//  Created by scwang on 2020/4/15.
//

import UIKit

/// 表情键盘布局
class EmojiCollectionFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()

        guard let collectionView = collectionView else {
            return
        }
        collectionView.layoutIfNeeded()
        itemSize = collectionView.bounds.size
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        // 滚动方向
        scrollDirection = .horizontal
    }
}
