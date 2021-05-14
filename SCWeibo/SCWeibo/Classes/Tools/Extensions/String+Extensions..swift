//
//  String+Extensions.swift
//  SCWeibo
//
//  Created by scwang on 2020/4/9.
//

import Foundation

extension String {
    func mn_href() -> String {
        // 创建正则表达式，匹配
        let pattern = "<a href=\"(.*?)\".*?\">(.*?)</a>"
        guard let regx = try? NSRegularExpression(pattern: pattern, options: []),
              let result = regx.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) else {
            return self
        }

        let text = (self as NSString).substring(with: result.range(at: 2))
        return text
    }
}

extension String: UtilitiesWrapperableValue {}

extension UtilitiesWrapper where Base == String {
    var stringByURLEncode: String {
        let encodeUrlString = base.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return encodeUrlString ?? ""
    }

    var stringByURLDecode: String {
        return base.removingPercentEncoding ?? ""
    }
}
