//
//  MNEmojiManager.swift
//  SCWeibo
//
//  Created by scwang on 2020/4/12.
//

import Kanna
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

    func replaceHTMLString(withString string: String, font: UIFont) -> NSMutableAttributedString {
        let attrString = NSMutableAttributedString(string: string)
        let labelModel = ContentLabelTextModel(text: attrString)

        // 替换emoji
//        replaceEmoji(labelModel: labelModel, font: font)

        // 替换换行符
        replaceWrap(labelModel: labelModel)

        // 替换如 <a href=xxxx>@xxxxxx</a> 为 @xxxxxx
        replaceUserHref(labelModel: labelModel)

        // 替换查看图片
        replacePhotoPreview(labelModel: labelModel)

        return attrString
    }

    func replaceEmojiHTML(labelModel: ContentLabelTextModel) {
        let string = labelModel.text
        let pattern = "<span.*?img.*?(\\[.*?\\]).*?</span>"
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return
        }

        let matchs = regx.matches(in: string.string, options: [], range: NSRange(location: 0, length: string.length))

        for result in matchs.reversed() {
            let range = result.range
            let toRange = result.range(at: 1)
            let toStr = string.attributedSubstring(from: toRange)
            string.replaceCharacters(in: range, with: toStr)
        }
    }

    func replaceEmojiToAttachment(labelModel: ContentLabelTextModel, font: UIFont) {
        let string = labelModel.text
        let pattern = "\\[.*?\\]"
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return
        }

        let matchs = regx.matches(in: string.string, options: [], range: NSRange(location: 0, length: string.length))

        for result in matchs.reversed() {
            let range = result.range
            let emoji = string.attributedSubstring(from: range).string

            guard let emojiAttr = findEmoji(string: emoji)?.imageText(font: font) else {
                continue
            }
            string.replaceCharacters(in: range, with: emojiAttr)

            let toLength = emojiAttr.length
            let offset = range.length - toLength
            for schemaModel in labelModel.schemas {
                if schemaModel.range.location > range.location {
                    schemaModel.range.location -= offset
                }
            }
        }
    }

    func replaceWrap(labelModel: ContentLabelTextModel) {
        let string = labelModel.text
        let pattern = "<br.*?/>"
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return
        }

        let matchs = regx.matches(in: string.string, options: [], range: NSRange(location: 0, length: string.length))

        for result in matchs.reversed() {
            let fromRange = result.range
            string.replaceCharacters(in: fromRange, with: "\n")
        }
    }

    func replaceUserHref(labelModel: ContentLabelTextModel) {
        let string = labelModel.text
        let pattern = "<a href=.*?>(@.*?)</a>"
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return
        }

        let matchs = regx.matches(in: string.string, options: [], range: NSRange(location: 0, length: string.length))

        for result in matchs.reversed() {
            let fromRange = result.range
            let toRange = result.range(at: 1)
            let toStr = string.attributedSubstring(from: toRange)

            string.replaceCharacters(in: fromRange, with: toStr)

            let newRange = NSRange(location: fromRange.location, length: toRange.length)
            let offset = fromRange.length - toRange.length
            for schemaModel in labelModel.schemas {
                if schemaModel.range.location > newRange.location {
                    schemaModel.range.location -= offset
                }
            }
            let schema = String(format: "pillar://userProfile?user_name=%@", toStr.string.sc.stringByURLEncode)
            let schemaModel = ContentLabelTextModel.SchemaModel(range: newRange, schema: schema)
            labelModel.schemas.append(schemaModel)
        }
    }

    func replacePhotoPreview(labelModel: ContentLabelTextModel) {
        let string = labelModel.text
        let patternFrom = "<a.*?href=\"(.*?)\">.*?(查看图片).*?</a>"
        guard let regx = try? NSRegularExpression(pattern: patternFrom, options: []) else {
            return
        }

        let matchs = regx.matches(in: string.string, options: [], range: NSRange(location: 0, length: string.length))

        for result in matchs.reversed() {
            let fromRange = result.range
            let toRange = result.range(at: 2)
            let toStr = string.attributedSubstring(from: toRange)
            let hrefStr = string.attributedSubstring(from: result.range(at: 1)).string

            string.replaceCharacters(in: fromRange, with: toStr)
            let newRange = NSRange(location: fromRange.location, length: toRange.length)
            let offset = fromRange.length - toRange.length
            for schemaModel in labelModel.schemas {
                if schemaModel.range.location > newRange.location {
                    schemaModel.range.location -= offset
                }
            }
            let schema = String(format: "pillar://photoPreview?url=%@", hrefStr.sc.stringByURLEncode)
            let schemaModel = ContentLabelTextModel.SchemaModel(range: newRange, schema: schema)
            labelModel.schemas.append(schemaModel)
        }
    }

    func getEmojiString(string: String, font: UIFont) -> NSAttributedString {
        let attrStr = replaceHTMLString(withString: string, font: font)

        attrStr.addAttributes([NSAttributedString.Key.font: font,
                               NSAttributedString.Key.foregroundColor: UIColor.darkGray],
                              range: NSRange(location: 0, length: attrStr.length))
        return attrStr
    }

    func parseTextWithHTML(string: String, font: UIFont) -> ContentLabelTextModel {
        let attrString = NSMutableAttributedString(string: string)
        let labelModel = ContentLabelTextModel(text: attrString)

        // 替换emoji的H5标签为 [xxx]
        replaceEmojiHTML(labelModel: labelModel)

        // 替换换行符
        replaceWrap(labelModel: labelModel)

        // 替换如 <a href=xxxx>@xxxxxx</a> 为 @xxxxxx
        replaceUserHref(labelModel: labelModel)

        // 替换查看图片
        replacePhotoPreview(labelModel: labelModel)

        // 替换 [xxx] 为NSAttachment
        replaceEmojiToAttachment(labelModel: labelModel, font: font)

        labelModel.text.addAttributes([NSAttributedString.Key.font: font,
                                       NSAttributedString.Key.foregroundColor: UIColor.darkGray],
                                      range: NSRange(location: 0, length: labelModel.text.length))

        return labelModel
    }
}
