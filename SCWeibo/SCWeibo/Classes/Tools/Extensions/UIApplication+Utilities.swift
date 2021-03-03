//
//  UIApplication+Utilities.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/1.
//

import UIKit

extension UIApplication: UtilitiesWrapperable {
}

extension UtilitiesWrapper where Base == UIApplication {
    public var keyWindow: UIWindow? {
        return Base.shared.windows.first { (window) -> Bool in
            window.isKeyWindow
        }
    }
}
