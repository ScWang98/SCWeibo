//
//  UIScreen+Utilities.swift
//  SCWeibo
//
//  Created by scwang on 2020/4/21.
//

import UIKit

extension UIScreen: UtilitiesWrapperable {}

extension UtilitiesWrapper where Base: UIScreen {
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }

    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
}
