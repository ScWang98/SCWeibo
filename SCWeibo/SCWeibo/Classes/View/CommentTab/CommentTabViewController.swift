//
//  CommentListViewController.swift
//  SCWeibo
//
//  Created by 王书超 on 2021/5/15.
//

import UIKit

class CommentTabViewController: UIViewController {
    let avatarView = NavigationAvatarView()
    let titleView = CommentTitleView()

    var subPages = [UIView]()

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

private extension CommentTabViewController {
    func setupSubviews() {
        addSubSegmentVC(viewController: MessageCommentsViewController.init(type: .received))
        addSubSegmentVC(viewController: MessageCommentsViewController.init(type: .mentioned))
        addSubSegmentVC(viewController: MessageCommentsViewController.init(type: .sended))

        titleView.selectedSegmentIndex = 0
        selectPage(atIndex: 0)
    }

    func addSubSegmentVC(viewController: UIViewController) {
        viewController.willMove(toParent: self)
        addChild(viewController)
        viewController.didMove(toParent: self)
        viewController.view.isHidden = true
        view.addSubview(viewController.view)
        subPages.append(viewController.view)
    }

    func setupNavigationButtons() {
        navigationItem.title = "评论"

        avatarView.clickAction = { [weak self] in
            self?.avatarDidClicked()
        }
        avatarView.avatarURL = AccountManager.shared.user?.avatar
        avatarView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let leftButton = UIBarButtonItem(customView: avatarView)
        navigationItem.leftBarButtonItem = leftButton

//        let rightButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(queryButtonDidClicked(sender:)))
//        navigationItem.rightBarButtonItem = rightButton
        let rightButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(writeButtonDidClicked(sender:)))
        navigationItem.rightBarButtonItem = rightButton

        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 21)
        titleView.addTarget(self, action: #selector(titleSegmentDidSelected(segControl:)), for: .valueChanged)
        navigationItem.titleView = titleView
    }

    func selectPage(atIndex index: Int) {
        guard 0 <= index && index < subPages.count else {
            return
        }

        for (idx, page) in subPages.enumerated() {
            page.isHidden = idx != index
        }
    }
}

// MARK: - Actions

@objc private extension CommentTabViewController {
    func avatarDidClicked() {
        if !AccountManager.shared.isLogin {
            NotificationCenter.default.post(name: NSNotification.Name(MNUserShouldLoginNotification), object: nil)
        }
        print("avatarDidClicked")
    }

    func queryButtonDidClicked(sender: Any) {
//        Router.open(url: "pillar://writeStatus")
    }
    
    func writeButtonDidClicked(sender: Any) {
        Router.open(url: "pillar://writeStatus")
    }

    func titleSegmentDidSelected(segControl: UISegmentedControl) {
        let index = segControl.selectedSegmentIndex

        selectPage(atIndex: index)
    }
}

class CommentTitleView: UISegmentedControl {
    init() {
        super.init(items: ["收到的", "@我的", "发出的"])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
