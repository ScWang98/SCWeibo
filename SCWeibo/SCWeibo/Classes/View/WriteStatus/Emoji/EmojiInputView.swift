//
//  EmojiInputView.swift
//  SCWeibo
//
//  Created by 王书超 on 2021/5/25.
//

import UIKit

protocol EmojiInputViewDelegate: class {
    func emojiInputView(view: EmojiInputView, didSelectEmoji emoji: Emoji)
}

class EmojiInputView: UIView {
    weak var delegate: EmojiInputViewDelegate?
    
    private var categoryBar = EmojiCategoryBar()
    private var selectViews = [EmojiSelectView]()
    private var listCategorys = [EmojiListCategory]()

    init() {
        var safeBottom: CGFloat = 0
        if let bottom = UIApplication.shared.sc.keyWindow?.safeAreaInsets.bottom {
            safeBottom = bottom
        }
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 254 + safeBottom))

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        categoryBar.anchorToEdge(.bottom, padding: safeAreaInsets.bottom, width: width, height: 40)

        for selectView in selectViews {
            selectView.anchorToEdge(.top, padding: 0, width: width, height: categoryBar.top)
        }
    }

    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        setNeedsLayout()
    }
}

private extension EmojiInputView {
    func setupUI() {
        backgroundColor = UIColor.sc.color(RGB: 0xEFEFF4)
        for (index, category) in EmojiManager.shared.categorys.enumerated() {
            var sections = [EmojiListSection]()
            if index == 0 {
                let recent = EmojiManager.shared.getRecentEmojis()
                if recent.count > 0 {
                    let section = EmojiListSection(title: "最近使用", emojis: recent)
                    sections.append(section)
                }
            }

            let section = EmojiListSection(title: category.categoryName, emojis: category.generateEmojis())
            sections.append(section)

            var listCategory = EmojiListCategory(sections: sections)
            listCategory.image = EmojiManager.shared.getEmoji(byName: category.coverName)?.image
            listCategorys.append(listCategory)
        }

        for (index, category) in listCategorys.enumerated() {
            let selectView = EmojiSelectView(category: category)
            selectView.isHidden = index != 0
            selectView.delegate = self
            addSubview(selectView)
            selectViews.append(selectView)
        }

        categoryBar.reload(withCategorys: listCategorys)
        categoryBar.delegate = self
        addSubview(categoryBar)
    }
}

// MARK: - EmojiSelectViewDelegate

extension EmojiInputView: EmojiSelectViewDelegate {
    func emojiSelectView(view: EmojiSelectView, didSelectEmoji emoji: Emoji) {
        delegate?.emojiInputView(view: self, didSelectEmoji: emoji)
    }
}


// MARK: - EmojiCategoryBarDelegate

extension EmojiInputView: EmojiCategoryBarDelegate {
    func emojiCategoryBar(categoryBar: EmojiCategoryBar, didSelectCategoryAt index: Int) {
        guard index < selectViews.count else {
            return
        }
        
        for (idx, view) in selectViews.enumerated() {
            view.isHidden = idx != index
        }
    }
}

struct EmojiListCategory {
    var sections: [EmojiListSection]
    var image: UIImage?

    init(sections: [EmojiListSection]) {
        self.sections = sections
    }
}

struct EmojiListSection {
    var title: String
    var emojis: [Emoji]

    init(title: String, emojis: [Emoji]) {
        self.title = title
        self.emojis = emojis
    }
}
