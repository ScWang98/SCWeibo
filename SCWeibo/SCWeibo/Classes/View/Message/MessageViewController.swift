//
//  MessageViewController.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/24.
//

import UIKit

class MessageViewController: UIViewController {
    let avatarView = NavigationAvatarView()
    let titleView = MessageTitleView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupNavigationButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}

// MARK: - UI

private extension MessageViewController {
    func setupSubviews() {
    }

    func setupNavigationButtons() {
        navigationItem.title = "消息"

        avatarView.clickAction = { [weak self] in
            self?.avatarDidClicked()
        }
        avatarView.avatarURL = AccountManager.shared.user?.avatar
        avatarView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let leftButton = UIBarButtonItem(customView: avatarView)
        navigationItem.leftBarButtonItem = leftButton

        let rightButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(writeButtonDidClicked(sender:)))
        navigationItem.rightBarButtonItem = rightButton

        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 21)
//        titleButton.addTarget(self, action: #selector(titleButtonDidClicked(sender:)), for: .touchUpInside)
        navigationItem.titleView = titleView
    }
}

// MARK: - Actions

@objc private extension MessageViewController {
    func avatarDidClicked() {
        if !AccountManager.shared.isLogin {
            NotificationCenter.default.post(name: NSNotification.Name(MNUserShouldLoginNotification), object: nil)
        }
        print("avatarDidClicked")
    }

    func writeButtonDidClicked(sender: Any) {
        Router.open(url: "pillar://writeStatus")
    }

    func titleButtonDidClicked(sender: Any) {
//        guard let groupModels = groupModels,
//              groupModels.count > 0 else {
//            return
//        }
//        titleButton.isSelected = !titleButton.isSelected
//
//        StatusFriendGroupController.showGroupController(groupList: groupModels) { [weak self] groupModel in
//            self?.titleButton.isSelected = false
//            if let groupModel = groupModel {
//                self?.service.gid = groupModel.gid
//                self?.titleButton.title = groupModel.name
//            }
//        }
    }
}

class MessageTitleView: UISegmentedControl {
}
