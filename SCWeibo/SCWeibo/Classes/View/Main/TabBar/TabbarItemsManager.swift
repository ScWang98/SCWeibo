//
//  TabbarItemsManager.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/10.
//

import UIKit

enum TabbarItemType: String {
    case home = "主页"
    case message = "消息"
    case discovery = "发现"
    case profile = "我的"
}

class TabbarItemsManager: NSObject {
    static var homeItem: TabbarItemModel = {
        let item = TabbarItemModel()
        let viewController = StatusHomeViewController()
        item.viewController = WeiboNavigationController(rootViewController: viewController)
        item.tabbarImage = UIImage(named: "tabbar_home")
        item.selectedTabbarImage = UIImage(named: "tabbar_home_selected")
        item.itemType = TabbarItemType.home
        item.textAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.orange,
            NSAttributedString.Key.backgroundColor: UIColor.orange,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13),
        ]
        item.selectedTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.orange,
            NSAttributedString.Key.backgroundColor: UIColor.orange,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13),
        ]
        item.viewController?.tabBarItem.image = item.tabbarImage
        item.viewController?.tabBarItem.selectedImage = item.selectedTabbarImage
        item.viewController?.tabBarItem.title = item.itemType?.rawValue
        item.viewController?.tabBarItem.setTitleTextAttributes(item.textAttributes, for: .normal)
        item.viewController?.tabBarItem.setTitleTextAttributes(item.selectedTextAttributes, for: .selected)
        return item
    }()

    static var messageItem: TabbarItemModel = {
        let item = TabbarItemModel()
        let viewController = MNMessageViewController()
        item.viewController = WeiboNavigationController(rootViewController: viewController)
        item.tabbarImage = UIImage(named: "tabbar_message_center")
        item.selectedTabbarImage = UIImage(named: "tabbar_message_center_selected")
        item.itemType = TabbarItemType.message
        item.textAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.orange,
            NSAttributedString.Key.backgroundColor: UIColor.orange,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13),
        ]
        item.selectedTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.orange,
            NSAttributedString.Key.backgroundColor: UIColor.orange,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13),
        ]
        item.viewController?.tabBarItem.image = item.tabbarImage
        item.viewController?.tabBarItem.selectedImage = item.selectedTabbarImage
        item.viewController?.tabBarItem.title = item.itemType?.rawValue
        item.viewController?.tabBarItem.setTitleTextAttributes(item.textAttributes, for: .normal)
        item.viewController?.tabBarItem.setTitleTextAttributes(item.selectedTextAttributes, for: .selected)
        return item
    }()

    static var discoverItem: TabbarItemModel = {
        let item = TabbarItemModel()
        let viewController = MNDiscoverViewController()
        item.viewController = WeiboNavigationController(rootViewController: viewController)
        item.tabbarImage = UIImage(named: "tabbar_discover")
        item.selectedTabbarImage = UIImage(named: "tabbar_discover_selected")
        item.itemType = TabbarItemType.discovery
        item.textAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.orange,
            NSAttributedString.Key.backgroundColor: UIColor.orange,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13),
        ]
        item.selectedTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.orange,
            NSAttributedString.Key.backgroundColor: UIColor.orange,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13),
        ]
        item.viewController?.tabBarItem.image = item.tabbarImage
        item.viewController?.tabBarItem.selectedImage = item.selectedTabbarImage
        item.viewController?.tabBarItem.title = item.itemType?.rawValue
        item.viewController?.tabBarItem.setTitleTextAttributes(item.textAttributes, for: .normal)
        item.viewController?.tabBarItem.setTitleTextAttributes(item.selectedTextAttributes, for: .selected)
        return item
    }()

    static var profileItem: TabbarItemModel = {
        let item = TabbarItemModel()
        let viewController = UserProfileViewController()
        item.viewController = WeiboNavigationController(rootViewController: viewController)
        item.tabbarImage = UIImage(named: "tabbar_profile")
        item.selectedTabbarImage = UIImage(named: "tabbar_profile_selected")
        item.itemType = TabbarItemType.profile
        item.textAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.orange,
            NSAttributedString.Key.backgroundColor: UIColor.orange,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13),
        ]
        item.selectedTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.orange,
            NSAttributedString.Key.backgroundColor: UIColor.orange,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13),
        ]
        item.viewController?.tabBarItem.image = item.tabbarImage
        item.viewController?.tabBarItem.selectedImage = item.selectedTabbarImage
        item.viewController?.tabBarItem.title = item.itemType?.rawValue
        item.viewController?.tabBarItem.setTitleTextAttributes(item.textAttributes, for: .normal)
        item.viewController?.tabBarItem.setTitleTextAttributes(item.selectedTextAttributes, for: .selected)
        return item
    }()
    
    static var tabbarItems: [TabbarItemModel] = {
        return [homeItem, messageItem, discoverItem, profileItem]
    }()
}
