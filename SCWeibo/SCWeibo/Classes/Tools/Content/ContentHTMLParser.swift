//
//  ContentHTMLParser.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/13.
//

import Foundation

class ContentHTMLParser {
    class func parseContentText(string: String, font: UIFont, html: Bool = true, baseAttributes: [NSAttributedString.Key: Any]? = nil) -> ContentLabelTextModel {
        let attrString = NSMutableAttributedString(string: string)
        let labelModel = ContentLabelTextModel(text: attrString)

        // 替换emoji的H5标签为 [xxx]
        replaceEmojiHTML(labelModel: labelModel)

        // 替换换行符
        replaceWrap(labelModel: labelModel)

        // 替换 @ 如 <a href=xxxx>@xxxxxx</a> 为 @xxxxxx
        replaceUserHref(labelModel: labelModel, html: html)

        // 替换 话题 如 <a href=xxxx>#xxxxxx#</a> 为 @xxxxxx
        replaceTopicHref(labelModel: labelModel, html: html)

        // 替换 全文
        replaceFullTextHref(labelModel: labelModel)

        // 替换 位置
        replaceLocationHref(labelModel: labelModel)

        // 替换 视频
        replaceVideoHref(labelModel: labelModel)

        // 替换 网页链接
        replaceWebHref(labelModel: labelModel)

        // 替换查看图片
        replacePhotoPreview(labelModel: labelModel)

        // 替换 [xxx] 为NSAttachment
        replaceEmojiToAttachment(labelModel: labelModel, font: font)

        // 统一添加字体颜色
        var attributes = [NSAttributedString.Key: Any]()
        attributes[.font] = font
        attributes[.foregroundColor] = UIColor.black
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        attributes[.paragraphStyle] = paragraphStyle

        if let baseAttributes = baseAttributes {
            attributes.merge(baseAttributes) { (_, new) -> Any in
                new
            }
        }

        labelModel.text.addAttributes(attributes, range: NSRange(location: 0, length: labelModel.text.length))

        return labelModel
    }
}

private extension ContentHTMLParser {
    class func replaceEmojiHTML(labelModel: ContentLabelTextModel) {
        let string = labelModel.text
        let pattern = "<span *?class=\"url-icon\"><img *?alt=(\\[.*?\\]).*?</span>"
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

    class func replaceEmojiToAttachment(labelModel: ContentLabelTextModel, font: UIFont) {
        let string = labelModel.text
        let pattern = "\\[.*?\\]"
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return
        }

        let matchs = regx.matches(in: string.string, options: [], range: NSRange(location: 0, length: string.length))

        for result in matchs.reversed() {
            let range = result.range
            let emoji = string.attributedSubstring(from: range).string

            guard let emojiAttr = EmojiManager.shared.getEmoji(byName: emoji)?.imageText(font: font) else {
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

    class func replaceWrap(labelModel: ContentLabelTextModel) {
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

    class func replaceUserHref(labelModel: ContentLabelTextModel, html: Bool) {
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

    class func replacePhotoPreview(labelModel: ContentLabelTextModel) {
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

    class func replaceTopicHref(labelModel: ContentLabelTextModel, html: Bool) {
        let string = labelModel.text
        let pattern = "<a *?href=\".*?\"><span.*?>(#.*?#)</span></a>"
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
            let schema = String(format: "pillar://searchTopic?topic_name=%@", toStr.string.sc.stringByURLEncode)
            let schemaModel = ContentLabelTextModel.SchemaModel(range: newRange, schema: schema)
            labelModel.schemas.append(schemaModel)
        }
    }

    class func replaceFullTextHref(labelModel: ContentLabelTextModel) {
        let string = labelModel.text
        let pattern = "<a *?href=\".*?\">(全文)</a>"
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
            let schema = "pillar://statusDetail"
            let schemaModel = ContentLabelTextModel.SchemaModel(range: newRange, schema: schema)
            schemaModel.disableClick = true
            labelModel.schemas.append(schemaModel)
        }
    }

    class func replaceLocationHref(labelModel: ContentLabelTextModel) {
        let string = labelModel.text
        let pattern = "<a.*?data-url.*?href=\"(.*?)\".*?><img.*?location.*?</span><span.*?>(.*?)</span></a>"
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return
        }

        let matchs = regx.matches(in: string.string, options: [], range: NSRange(location: 0, length: string.length))

        for result in matchs.reversed() {
            let fromRange = result.range
            var toRange = result.range(at: 2)
            var toStr = string.attributedSubstring(from: toRange)

            if let image = UIImage(named: "SmallLocation")?.sc.image(tintColor: UIColor.sc.color(RGBA: 0x0099FFFF)) {
                let mutToStr = NSMutableAttributedString(attributedString: toStr)
                let attachment = NSTextAttachment(image: image)
                attachment.bounds = CGRect(x: 0, y: -1, width: 12, height: 12)
                let imageAttrStr = NSAttributedString(attachment: attachment)
                mutToStr.insert(imageAttrStr, at: 0)
                toRange.length = mutToStr.length
                toStr = mutToStr
            }

            let urlStr = string.attributedSubstring(from: result.range(at: 1))

            string.replaceCharacters(in: fromRange, with: toStr)

            let newRange = NSRange(location: fromRange.location, length: toRange.length)
            let offset = fromRange.length - toRange.length
            for schemaModel in labelModel.schemas {
                if schemaModel.range.location > newRange.location {
                    schemaModel.range.location -= offset
                }
            }
            let schema = String(format: "pillar://webview?url=%@", urlStr.string.sc.stringByURLEncode)
            let schemaModel = ContentLabelTextModel.SchemaModel(range: newRange, schema: schema)
            labelModel.schemas.append(schemaModel)
        }
    }

    class func replaceVideoHref(labelModel: ContentLabelTextModel) {
        let string = labelModel.text
        let pattern = "<a.*?data-url.*?href=\"(.*?)\".*?><img.*?video.*?</span><span.*?>(.*?)</span></a>"
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return
        }

        let matchs = regx.matches(in: string.string, options: [], range: NSRange(location: 0, length: string.length))

        for result in matchs.reversed() {
            let fromRange = result.range
            var toRange = result.range(at: 2)
            var toStr = string.attributedSubstring(from: toRange)

            if let image = UIImage(named: "CardSmallVideo")?.sc.image(tintColor: UIColor.sc.color(RGBA: 0x0099FFFF)) {
                let mutToStr = NSMutableAttributedString(attributedString: toStr)
                let attachment = NSTextAttachment(image: image)
                attachment.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
                let imageAttrStr = NSAttributedString(attachment: attachment)
                mutToStr.insert(imageAttrStr, at: 0)
                toRange.length = mutToStr.length
                toStr = mutToStr
            }

            let urlStr = string.attributedSubstring(from: result.range(at: 1))

            string.replaceCharacters(in: fromRange, with: toStr)

            let newRange = NSRange(location: fromRange.location, length: toRange.length)
            let offset = fromRange.length - toRange.length
            for schemaModel in labelModel.schemas {
                if schemaModel.range.location > newRange.location {
                    schemaModel.range.location -= offset
                }
            }
            let schema = String(format: "pillar://webview?url=%@", urlStr.string.sc.stringByURLEncode)
            let schemaModel = ContentLabelTextModel.SchemaModel(range: newRange, schema: schema)
            labelModel.schemas.append(schemaModel)
        }
    }

    class func replaceWebHref(labelModel: ContentLabelTextModel) {
        let string = labelModel.text
        let pattern = "<a.*?data-url.*?href=\"(.*?)\".*?><img.*?web.*?</span><span.*?>(.*?)</span></a>"
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []) else {
            return
        }

        let matchs = regx.matches(in: string.string, options: [], range: NSRange(location: 0, length: string.length))

        for result in matchs.reversed() {
            let fromRange = result.range
            var toRange = result.range(at: 2)
            var toStr = string.attributedSubstring(from: toRange)

            if let image = UIImage(named: "SmallWebLink")?.sc.image(tintColor: UIColor.sc.color(RGBA: 0x0099FFFF)) {
                let mutToStr = NSMutableAttributedString(attributedString: toStr)
                let attachment = NSTextAttachment(image: image)
                attachment.bounds = CGRect(x: 0, y: -2.5, width: 14, height: 14)
                let imageAttrStr = NSAttributedString(attachment: attachment)
                mutToStr.insert(imageAttrStr, at: 0)
                toRange.length = mutToStr.length
                toStr = mutToStr
            }

            let urlStr = string.attributedSubstring(from: result.range(at: 1))

            string.replaceCharacters(in: fromRange, with: toStr)

            let newRange = NSRange(location: fromRange.location, length: toRange.length)
            let offset = fromRange.length - toRange.length
            for schemaModel in labelModel.schemas {
                if schemaModel.range.location > newRange.location {
                    schemaModel.range.location -= offset
                }
            }
            let schema = String(format: "pillar://webview?url=%@", urlStr.string.sc.stringByURLEncode)
            let schemaModel = ContentLabelTextModel.SchemaModel(range: newRange, schema: schema)
            labelModel.schemas.append(schemaModel)
        }
    }
}
