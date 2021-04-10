//
//  MNEmojiManager.swift
//  SCWeibo
//
//  Created by scwang on 2020/4/12.
//

import UIKit

class MNEmojiManager {
    static let shared = MNEmojiManager()

    lazy var packages = [MNEmojiPackageModel]()

    let pageCells = 20

    lazy var bundle: Bundle = {
        let path = Bundle.main.path(forResource: "MNEmoji.bundle", ofType: nil)
        return Bundle(path: path ?? "") ?? Bundle()
    }()

    private init() {
        loadPackageDatas()
    }

    // 添加最近使用的表情
    func recentEmoji(model: MNEmojiModel) {
        // 1.表情使用次数+1
        model.times += 1

        // 2.添加表情
        if !packages[0].emotions.contains(model) {
            packages[0].emotions.append(model)
        }

        // 3.排序(降序)
        packages[0].emotions.sort { $0.times > $1.times }

        // 4.表情数组长度处理
        if packages[0].emotions.count > pageCells {
            let subRange = pageCells ..< packages[0].emotions.count
            packages[0].emotions.removeSubrange(subRange)
        }
    }
}

private extension MNEmojiManager {
    func loadPackageDatas() {
        guard let plistPath = bundle.path(forResource: "emoticons.plist", ofType: nil),
              let array = NSArray(contentsOfFile: plistPath) as? [[String: String]],
              let models = NSArray.yy_modelArray(with: MNEmojiPackageModel.self, json: array) as? [MNEmojiPackageModel]
        else {
            print("loadPackageDatas failure.")
            return
        }
        packages += models
    }
}

// MARK: - 表情符号处理

extension MNEmojiManager {
    /// 根据传入的字符串[abc]，查找对应的表情模型
    /// - Parameter string : 查询字符串
    func findEmoji(string: String) -> MNEmojiModel? {
        for pModel in packages {
            // 传入的参数和model对比，过滤出一致字符串对应的模型.
            let result = pModel.emotions.filter { $0.chs == string }
            if result.count > 0 {
                return result.first
            }
        }
        return nil
    }

    func replaceHTMLString(withString string: String) -> NSMutableAttributedString {
        let attrString = NSMutableAttributedString(string: string)

        // 替换emoji
        let emojiPatternFrom = "<span.*?img.*?\\[.*?\\].*?</span>"
        let emojiPatternTo = "\\[.*?\\]"
        replace(string: attrString, with: emojiPatternFrom, patternTo: emojiPatternTo)

        // 替换换行符
        let wrapPatternFrom = "<br.*?/>"
        let wrapStringTo = "\n"
        replace(string: attrString, with: wrapPatternFrom, stringTo: wrapStringTo)

        // 替换转发链接
        let linkPatternFrom = "<a href=.*?>@.*?</a>"
        let linkPatternTo = "@.*?(?=</a>)"
        replace(string: attrString, with: linkPatternFrom, patternTo: linkPatternTo)

        return attrString
    }

    func replace(string: NSMutableAttributedString, with patternFrom: String, patternTo: String? = nil, stringTo: String? = nil) {
        guard let regx = try? NSRegularExpression(pattern: patternFrom, options: []) else {
            return
        }

        let matchs = regx.matches(in: string.string, options: [], range: NSRange(location: 0, length: string.length))

        for result in matchs.reversed() {
            let range = result.range
            let subStr = string.attributedSubstring(from: range)

            let toStr: NSAttributedString

            if let patternTo = patternTo {
                // 在子串中找替换的串
                guard let regx = try? NSRegularExpression(pattern: patternTo, options: []) else {
                    continue
                }

                guard let toRange = regx.firstMatch(in: subStr.string, options: [], range: NSRange(location: 0, length: subStr.length))?.range else {
                    continue
                }

                toStr = subStr.attributedSubstring(from: toRange)
            } else if let stringTo = stringTo {
                // 将子串替换为传入的串
                toStr = NSAttributedString(string: stringTo)
            } else {
                // 删除子串
                toStr = NSAttributedString(string: "")
            }

            string.replaceCharacters(in: range, with: toStr)
        }

        return
    }

    func getEmojiString(string: String, font: UIFont) -> NSAttributedString {
        let attrStr = replaceHTMLString(withString: string)
        let pattern = "\\[.*?\\]"

        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return attrStr
        }

        let matchs = regx.matches(in: attrStr.string, options: [], range: NSRange(location: 0, length: attrStr.length))

        for result in matchs.reversed() {
            let range = result.range(at: 0)
            let subStr = (attrStr.string as NSString).substring(with: range)

            if let model = findEmoji(string: subStr) {
                attrStr.replaceCharacters(in: range, with: model.imageText(font: font))
            }
        }

        attrStr.addAttributes([NSAttributedString.Key.font: font,
                               NSAttributedString.Key.foregroundColor: UIColor.darkGray],
                              range: NSRange(location: 0, length: attrStr.length))
        return attrStr
    }
}
