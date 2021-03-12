//
//  UserProfileDefine.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/10.
//

import UIKit

protocol UserProfileTabViewModel {
    var tabName: String { get }
    var tabViewController: UIViewController? { get }
    var tabView: UIView { get }
    var tabScrollView: UIScrollView { get }

    func tabRefresh(with completion: () -> Void)
}
