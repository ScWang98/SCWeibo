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
    let topToolBar = MineTopToolBar()
    let headerView = UserProfileHeaderAvatarView()

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
}

// MARK: UI

private extension UserProfileViewController {
    func setupSubviews() {
        view.backgroundColor = UIColor.white
        
        view.addSubview(topToolBar)
        view.addSubview(backScrollView)
        backScrollView.addSubview(headerView)

        topToolBar.anchorToEdge(.top, padding: 0, width: view.width, height: view.safeAreaInsets.top + 44)
        backScrollView.frame = view.bounds
        headerView.anchorToEdge(.top, padding: 100, width: view.width, height: 200)
    }
}

// MARK: Action

@objc private extension UserProfileViewController {
    func settingButtonClickedAction(button: UIButton) {
    }
}
