//
//  TabbarItemModel.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/10.
//

import UIKit

class TabbarItemModel {
    var viewController: UIViewController?
    var tabbarImage: UIImage?
    var selectedTabbarImage: UIImage?
    var itemType: TabbarItemType?
    var textAttributes: [NSAttributedString.Key: Any]?
    var selectedTextAttributes: [NSAttributedString.Key: Any]?
}
