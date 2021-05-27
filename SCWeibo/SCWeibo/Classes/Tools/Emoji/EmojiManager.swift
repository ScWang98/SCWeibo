//
//  EmojiManager.swift
//  SCWeibo
//
//  Created by 王书超 on 2021/5/25.
//

import Foundation
import MMKV

private let recentEmojisKey = "EmojiRecentEmojisKey"
private let recentMaxCount = 14

public class EmojiManager {
    static let shared = EmojiManager()

    lazy var categorys = [EmojiCategory]()
    
    private lazy var recentEmojis = [String]()
    private lazy var emojis = [String: Emoji]()

    private init() {
        loadEmojisData()
        
        addRecent(emojiName: "[微笑]")
        addRecent(emojiName: "[生病]")
        addRecent(emojiName: "[允悲]")
    }

    func addRecent(emoji: Emoji) {
        let emojiName = emoji.emojiName
        addRecent(emojiName: emojiName)
    }

    func addRecent(emojiName: String) {
        guard getEmoji(byName: emojiName) != nil else {
            assertionFailure("RecentEmoji查找有误")
            return
        }
        if let index = recentEmojis.firstIndex(of: emojiName) {
            recentEmojis.remove(at: index)
        }
        recentEmojis.insert(emojiName, at: 0)

        while recentEmojis.count > recentMaxCount {
            recentEmojis.removeLast()
        }

        if let emojisData = try? JSONEncoder().encode(recentEmojis) {
            MMKV.default()?.set(emojisData, forKey: recentEmojisKey)
        }
    }
    
    func getRecentEmojis() -> [Emoji] {
        return recentEmojis.compactMap { (emojiName) -> Emoji? in
            getEmoji(byName: emojiName)
        }
    }

    func getEmoji(byName name: String) -> Emoji? {
        return emojis[name]
    }
}

// MARK: - Private Methods

private extension EmojiManager {
    func loadEmojisData() {
        guard let bundlePath = Bundle.main.path(forResource: "Emoji", ofType: "bundle"),
              let emojisBundle = Bundle(path: bundlePath) else {
            assertionFailure("Bundle加载失败")
            return
        }

        if let data = MMKV.default()?.data(forKey: recentEmojisKey),
           let emojis = try? JSONDecoder().decode([String].self, from: data) {
            recentEmojis = emojis
        }

        loadEmojis(fromBundle: emojisBundle, categoryName: "全部表情", coverName: "[微笑]", plistName: "IconEmojis")
        loadEmojis(fromBundle: emojisBundle, categoryName: "浪小花", coverName: "[噢耶]", plistName: "LXHEmojis")
    }

    func loadEmojis(fromBundle bundle: Bundle,
                categoryName: String,
                coverName: String,
                    plistName: String) {
        guard let plistPath = bundle.path(forResource: plistName, ofType: "plist"),
              let xml = FileManager.default.contents(atPath: plistPath),
              let emojis = (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [[String: String]] else {
            assertionFailure("表情加载失败")
            return
        }

        let emojiNames = emojis.compactMap { (emoji) -> String? in
            emoji.keys.first
        }
        let category = EmojiCategory.init(categoryName: categoryName, coverName: coverName, emojiNames: emojiNames)
        categorys.append(category)

        for emoji in emojis {
            if let emojiName = emoji.keys.first,
               let fileName = emoji[emojiName] {
                let model = Emoji(emojiName: emojiName, fileName: fileName)
                self.emojis[emojiName] = model
            }
        }
    }
}
