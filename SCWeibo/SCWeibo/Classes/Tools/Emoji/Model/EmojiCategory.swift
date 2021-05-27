//
//  EmojiCategory.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/5/25.
//

import Foundation

struct EmojiCategory {
    var categoryName: String
    var coverName: String
    var emojiNames: [String]

    init(categoryName: String, coverName: String, emojiNames: [String]) {
        self.categoryName = categoryName
        self.coverName = coverName
        self.emojiNames = emojiNames
    }
    
    func generateEmojis() -> [Emoji] {
        return emojiNames.compactMap { (emojiName) -> Emoji? in
            return EmojiManager.shared.getEmoji(byName: emojiName)
        }
    }
}
