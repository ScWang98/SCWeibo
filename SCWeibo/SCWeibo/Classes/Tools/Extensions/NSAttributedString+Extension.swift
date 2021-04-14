//
//  NSAttributedString+Extension.swift
//  SCWeibo
//
//  Created by scwang on 2020/4/22.
//

import UIKit

extension NSAttributedString {
    class func mn_imageText(image: UIImage, imageWH: CGFloat, title: String, fontSize: CGFloat, titleColor: UIColor,
                            speacing: CGFloat) -> NSAttributedString {
        // 文本属性
        let titleDict = [NSAttributedString.Key.foregroundColor: titleColor,
                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
        let spacingDict = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: speacing)]

        // 图片属性
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: 0, y: 0, width: imageWH, height: imageWH)
        let imageText = NSAttributedString(attachment: attachment)
        let lineText = NSAttributedString(string: "\n\n", attributes: spacingDict)
        let titleText = NSAttributedString(string: title, attributes: titleDict)

        // 属性合并
        let attrM = NSMutableAttributedString(attributedString: imageText)
        attrM.append(lineText)
        attrM.append(titleText)

        return attrM
    }
}

extension NSAttributedString: UtilitiesWrapperable {}

public extension UtilitiesWrapper where Base: NSAttributedString {
    func height(labelWidth: CGFloat) -> CGFloat {
        let size = CGSize(width: labelWidth, height: 0)
        let rect = base.boundingRect(with: size, options: [.usesLineFragmentOrigin], context: nil)
        return rect.height
    }
}
