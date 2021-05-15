//
//  FavoriteViewController.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/24.
//


import UIKit

class FavoriteViewController: StatusListViewController {
    let avatarView = NavigationAvatarView()
    
    let service = StatusHomeService()

    var groupModels: [GroupModel]? {
        didSet {
            groupModels?.insert(GroupModel(gid: nil, name: "主页"), at: 0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupNavigationButtons()
        service.fetchFeedGroup { groupModels in
            self.groupModels = groupModels
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}

// MARK: - UI

private extension FavoriteViewController {
    func setupSubviews() {
        listViewModel.listService = service
//        refreshData(with: true)
    }

    func setupNavigationButtons() {
        avatarView.clickAction = { [weak self] in
            self?.avatarDidClicked()
        }
        avatarView.avatarURL = AccountManager.shared.user?.avatar

        avatarView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let leftButton = UIBarButtonItem(customView: avatarView)
        navigationItem.leftBarButtonItem = leftButton

        let queryButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(queryButtonDidClicked(sender:)))
        navigationItem.rightBarButtonItem = queryButton

        navigationItem.title = "收藏"
    }
}

// MARK: - Actions

@objc private extension FavoriteViewController {
    func avatarDidClicked() {
        if !AccountManager.shared.isLogin {
            NotificationCenter.default.post(name: NSNotification.Name(MNUserShouldLoginNotification), object: nil)
        }
        print("avatarDidClicked")
    }

    func queryButtonDidClicked(sender: Any) {
        print("queryButtonDidClicked")
    }
}
