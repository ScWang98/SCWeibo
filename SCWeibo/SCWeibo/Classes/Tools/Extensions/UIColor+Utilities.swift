//
//  UIColor+Utilities.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/21.
//

import UIKit

extension UIColor: UtilitiesWrapperable {}

extension UtilitiesWrapper where Base == UIColor {
    public static func color(RGBA: Int) -> Base {
        return color(red: CGFloat((RGBA & 0xFF000000) >> 24),
                     green: CGFloat((RGBA & 0xFF0000) >> 16),
                     blue: CGFloat((RGBA & 0xFF00) >> 8),
                     alpha: CGFloat((RGBA & 0xFF) >> 0) / 255.0)
    }

    public static func color(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> Base {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        assert(alpha >= 0 && alpha <= 1, "Invalid alpha component")

        return Base(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
}
