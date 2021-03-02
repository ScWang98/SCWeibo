//
//  UserProfileViewController.swift
//  MNWeibo
//
//  Created by scwang on 2021/3/1.
//  Copyright © 2021 miniLV. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    let backScrollView = UIScrollView()
    let topToolBar = UserProfileTopToolBar()
    let headerView = UserProfileHeaderView()
    let categoryBar = HorizontalCategoryBar()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

// MARK: UI

private extension UserProfileViewController {
    func setupSubviews() {
        view.backgroundColor = UIColor.white
        backScrollView.backgroundColor = UIColor.blue

        topToolBar.delegate = self
        
        categoryBar.backgroundColor = UIColor.white

        view.addSubview(backScrollView)
        backScrollView.addSubview(headerView)
        view.addSubview(topToolBar)
        view.addSubview(categoryBar)
        
        let safeArea = UIApplication.shared.sc.keyWindow?.safeAreaInsets
        topToolBar.anchorToEdge(.top, padding: 0, width: view.width, height: (safeArea?.top ?? 0) + 44)
        backScrollView.frame = view.bounds
        headerView.anchorToEdge(.top, padding: 100, width: view.width, height: 200)
        categoryBar.align(.underCentered, relativeTo: headerView, padding: 10, width: view.width, height: 100)
        
        var array = [HorizontalCategoryBarItem]()
        var item = HorizontalCategoryBarItem()
        item.name = "微博"
        array.append(item)
        item = HorizontalCategoryBarItem()
        item.name = "视频"
        array.append(item)
        item = HorizontalCategoryBarItem()
        item.name = "相册"
        array.append(item)
        categoryBar.reload(items: array)
    }
}

// MARK: UserProfileTopToolBarDelegate

extension UserProfileViewController: UserProfileTopToolBarDelegate {
    func topToolBarDidClickBack(_ topToolBar: UserProfileTopToolBar) {
        if let viewControllers = self.navigationController?.viewControllers, viewControllers.count > 1 {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    func topToolBarDidClickSetting(_ topToolBar: UserProfileTopToolBar) {
    }
}

// MARK: Action

@objc private extension UserProfileViewController {
    func settingButtonClickedAction(button: UIButton) {
    }
}
