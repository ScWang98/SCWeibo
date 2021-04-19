//
//  NSAttributedString+Extension.swift
//  SCWeibo
//
//  Created by scwang on 2020/4/22.
//

import UIKit

extension NSAttributedString: UtilitiesWrapperable {}

public extension UtilitiesWrapper where Base: NSAttributedString {
    func height(labelWidth: CGFloat) -> CGFloat {
        let size = CGSize(width: labelWidth, height: 0)
        let rect = base.boundingRect(with: size, options: [.usesLineFragmentOrigin], context: nil)
        return ceil(rect.height)
    }
}
