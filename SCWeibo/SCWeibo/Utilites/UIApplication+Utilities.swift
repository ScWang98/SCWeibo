//
//  UIApplication+Utilities.swift
//  MNWeibo
//
//  Created by scwang on 2021/3/1.
//  Copyright © 2021 miniLV. All rights reserved.
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
