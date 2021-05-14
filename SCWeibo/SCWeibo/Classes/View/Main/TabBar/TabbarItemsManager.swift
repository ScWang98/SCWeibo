//
//  TabbarItemsManager.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/10.
//

import UIKit

enum TabbarItemType: String {
    case home
    case message
    case favorite
    case profile
}

class TabbarItemsManager: NSObject {
    static var homeItem: TabbarItemModel = {
        let item = TabbarItemModel()
        item.viewController = WeiboNavigationController(rootViewController: StatusHomeViewController())
        item.tabbarImage = UIImage(named: "NewHome_Normal")
        item.selectedTabbarImage = UIImage(named: "NewHomeSelected_Normal")
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
        item.viewController?.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
//        item.viewController?.tabBarItem.title = item.itemType?.rawValue
//        item.viewController?.tabBarItem.setTitleTextAttributes(item.textAttributes, for: .normal)
//        item.viewController?.tabBarItem.setTitleTextAttributes(item.selectedTextAttributes, for: .selected)
        return item
    }()

    static var messageItem: TabbarItemModel = {
        let item = TabbarItemModel()
        item.viewController = WeiboNavigationController(rootViewController: MessageViewController())
        item.tabbarImage = UIImage(named: "NewMessage_Normal")
        item.selectedTabbarImage = UIImage(named: "NewMessageSelected_Normal")
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
        item.viewController?.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
//        item.viewController?.tabBarItem.title = item.itemType?.rawValue
//        item.viewController?.tabBarItem.setTitleTextAttributes(item.textAttributes, for: .normal)
//        item.viewController?.tabBarItem.setTitleTextAttributes(item.selectedTextAttributes, for: .selected)
        return item
    }()

    static var favoriteItem: TabbarItemModel = {
        let item = TabbarItemModel()
        item.viewController = WeiboNavigationController(rootViewController: MNDiscoverViewController())
        item.tabbarImage = UIImage(named: "NewFavorite_Normal")
        item.selectedTabbarImage = UIImage(named: "NewFavoriteSelected_Normal")
        item.itemType = TabbarItemType.favorite
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
        item.viewController?.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
//        item.viewController?.tabBarItem.title = item.itemType?.rawValue
//        item.viewController?.tabBarItem.setTitleTextAttributes(item.textAttributes, for: .normal)
//        item.viewController?.tabBarItem.setTitleTextAttributes(item.selectedTextAttributes, for: .selected)
        return item
    }()

    static var profileItem: TabbarItemModel = {
        let item = TabbarItemModel()
        item.viewController = WeiboNavigationController(rootViewController: UserProfileViewController())
        item.tabbarImage = UIImage(named: "NewProfile_Normal")
        item.selectedTabbarImage = UIImage(named: "NewProfileSelected_Normal")
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
        item.viewController?.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
//        item.viewController?.tabBarItem.title = item.itemType?.rawValue
//        item.viewController?.tabBarItem.setTitleTextAttributes(item.textAttributes, for: .normal)
//        item.viewController?.tabBarItem.setTitleTextAttributes(item.selectedTextAttributes, for: .selected)
        return item
    }()

    static var tabbarItems: [TabbarItemModel] = {
        [homeItem, messageItem, favoriteItem, profileItem]
    }()
}
