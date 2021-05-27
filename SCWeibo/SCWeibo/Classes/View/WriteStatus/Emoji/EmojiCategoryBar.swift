//
//  EmojiCategoryBar.swift
//  SCWeibo
//
//  Created by 王书超 on 2021/5/25.
//

import UIKit

protocol EmojiCategoryBarDelegate: class {
    func emojiCategoryBar(categoryBar: EmojiCategoryBar, didSelectCategoryAt index: Int)
}

class EmojiCategoryBar: UIView {
    weak var delegate: EmojiCategoryBarDelegate?

    private var categoryButtons = [EmojiCategoryButton]()
    private let seperatorLine = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        seperatorLine.backgroundColor = UIColor.lightGray
        addSubview(seperatorLine)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        seperatorLine.anchorToEdge(.top, padding: 0, width: self.width, height: 1.0 / UIScreen.main.scale)
        var leftAnchor: CGFloat = 15
        for button in categoryButtons {
            button.frame = CGRect(x: leftAnchor, y: 5, width: 60, height: height - 10)
            leftAnchor = button.right + 8
        }
    }

    func reload(withCategorys categorys: [EmojiListCategory]) {
        while categoryButtons.count > categorys.count {
            categoryButtons.last?.removeFromSuperview()
            categoryButtons.removeLast()
        }
        while categoryButtons.count < categorys.count {
            let button = EmojiCategoryButton()
            button.tag = categoryButtons.count
            button.addTarget(self, action: #selector(categoryDidSelected(button:)), for: .touchUpInside)
            addSubview(button)
            categoryButtons.append(button)
        }

        for (index, button) in categoryButtons.enumerated() {
            let category = categorys[index]
            button.setImage(category.image, for: .normal)
        }

        setNeedsLayout()
    }

    @objc private func categoryDidSelected(button: UIButton) {
        let index = button.tag
        guard !button.isSelected else {
            return
        }
        
        for (idx, button) in categoryButtons.enumerated() {
            button.isSelected = idx == index
        }
        delegate?.emojiCategoryBar(categoryBar: self, didSelectCategoryAt: index)
    }
}

private class EmojiCategoryButton: UIButton {
    convenience init() {
        self.init(frame: CGRect.zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.clipsToBounds = true
        setBackgroundImage(UIImage.sc.image(color: UIColor.white), for: .selected)
        setBackgroundImage(nil, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(width, height) / 2
    }
}
