//
//  UIView+Extension.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/3.
//

import UIKit

extension UIView: UtilitiesWrapperable {
}

extension UtilitiesWrapper where Base: UIView {
    public var viewController: UIViewController {
        return ResponderHelper.topViewController(for: base)
    }
}
