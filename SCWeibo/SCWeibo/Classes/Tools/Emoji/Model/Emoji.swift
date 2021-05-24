//
//  Emoji.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/5/25.
//

import Foundation

struct Emoji: Codable {
    let emojiName: String
    let fileName: String

    init(emojiName: String, fileName: String) {
        self.emojiName = emojiName
        self.fileName = fileName
    }

    var image: UIImage? {
        guard let bundlePath = Bundle.main.path(forResource: "Emoji", ofType: "bundle"),
              let emojisBundle = Bundle(path: bundlePath) else {
//            assertionFailure("Bundle加载失败")
            return nil
        }
        
        let fileName: String
        let fileSplit = self.fileName.split(separator: ".")
        if let first = fileSplit.first,
           let last = fileSplit.last {
            fileName = first + "@3x." + last
        } else {
            fileName = self.fileName
        }
        if let path = emojisBundle.path(forResource: fileName, ofType: nil, inDirectory: "Images") {
            return UIImage(contentsOfFile: path)
        } else {
            let fileName: String
            let fileSplit = self.fileName.split(separator: ".")
            if let first = fileSplit.first,
               let last = fileSplit.last {
                fileName = first + "@2x." + last
            } else {
                fileName = self.fileName
            }
            if let path = emojisBundle.path(forResource: fileName, ofType: nil, inDirectory: "Images") {
                return UIImage(contentsOfFile: path)
            }
        }
        
        print("tttttttttt  " + fileName)

        return nil
    }

    func imageText(font: UIFont) -> NSAttributedString {
        guard let image = image else {
            return NSAttributedString(string: "")
        }

        let atta = EmojiAttachment()
        atta.image = image
        atta.emojiName = emojiName
        atta.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)

        let attrStr = NSMutableAttributedString(attributedString: NSAttributedString(attachment: atta))
        attrStr.addAttributes([NSAttributedString.Key.font: font], range: NSRange(location: 0, length: attrStr.length))
        return attrStr
    }
}
