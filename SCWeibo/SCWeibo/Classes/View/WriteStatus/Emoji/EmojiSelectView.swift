//
//  EmojiSelectView.swift
//  SCWeibo
//
//  Created by 王书超 on 2021/5/25.
//

import UIKit

protocol EmojiSelectViewDelegate: class {
    func emojiSelectView(view: EmojiSelectView, didSelectEmoji emoji: Emoji)
}

class EmojiSelectView: UIView {
    weak var delegate: EmojiSelectViewDelegate?
    
    private let emojiCategory: EmojiListCategory
    private let flowLayout = UICollectionViewFlowLayout()
    private let collectionView: UICollectionView

    init(category: EmojiListCategory) {
        emojiCategory = category
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        super.init(frame: CGRect.zero)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        flowLayout.headerReferenceSize = CGSize(width: width, height: 36)
        let gap = floor((self.width - 12 * 2 - 44 * 7) / 6.0)
        flowLayout.minimumInteritemSpacing = gap
        flowLayout.minimumLineSpacing = gap
        collectionView.frame = bounds
    }
}

// MARK: Private Methods

private extension EmojiSelectView {
    func setupSubviews() {
        flowLayout.itemSize = CGSize(width: 44, height: 44)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 5, right: 12)
        flowLayout.scrollDirection = .vertical
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: String(describing: EmojiCell.self))
        collectionView.register(EmojiSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: EmojiSectionHeader.self))
        addSubview(collectionView)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension EmojiSelectView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return emojiCategory.sections.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiCategory.sections[section].emojis.count
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: EmojiSectionHeader.self), for: indexPath)
        if let header = header as? EmojiSectionHeader {
            let title = emojiCategory.sections[indexPath.section].title
            header.reload(withTitle: title)
        }
        return header
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: EmojiCell.self), for: indexPath)

        if let cell = cell as? EmojiCell {
            let emoji = emojiCategory.sections[indexPath.section].emojis[indexPath.row]
            cell.reload(withEmoji: emoji)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoji = emojiCategory.sections[indexPath.section].emojis[indexPath.row]
        delegate?.emojiSelectView(view: self, didSelectEmoji: emoji)
    }
}

// MARK: - EmojiCell

private class EmojiCell: UICollectionViewCell {
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.anchorInCenter(width: 32, height: 32)
    }

    func reload(withEmoji emoji: Emoji) {
        imageView.image = emoji.image
        setNeedsLayout()
    }
}

private class EmojiSectionHeader: UICollectionReusableView {
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.textColor = UIColor.lightGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        addSubview(label)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        label.anchorToEdge(.left, padding: 15, width: width - 15, height: height)
    }

    func reload(withTitle title: String) {
        label.text = title
        setNeedsLayout()
    }
}
