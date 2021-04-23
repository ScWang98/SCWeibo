//
//  UIViewController+Extension.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/23.
//

import UIKit

extension UIViewController {
    @objc public func dismissViewController() {
        if let viewControllers = navigationController?.viewControllers,
           viewControllers.count > 1 {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
