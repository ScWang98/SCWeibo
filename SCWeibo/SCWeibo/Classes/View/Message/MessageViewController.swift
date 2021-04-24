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

private extension MessageViewController {
    func setupSubviews() {
        let viewControllerClazzs = [MessageMentionsViewController.self,
                                    MessageCommentsViewController.self,
                                    MessageAttitudesViewController.self]
        for clazz in viewControllerClazzs {
            addSubSegmentVC(viewControllerClazz: clazz)
        }
        
        titleView.selectedSegmentIndex = 0
        selectPage(atIndex: 0)
    }
    
    func addSubSegmentVC(viewControllerClazz: UIViewController.Type) {
        let viewController = viewControllerClazz.init()
        viewController.willMove(toParent: self)
        self.addChild(viewController)
        viewController.didMove(toParent: self)
        viewController.view.isHidden = true
        self.view.addSubview(viewController.view)
        self.subPages.append(viewController.view)
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
    
    func titleSegmentDidSelected(segControl: UISegmentedControl) {
        let index = segControl.selectedSegmentIndex
        
        selectPage(atIndex: index)
    }
}

class MessageTitleView: UISegmentedControl {
    
    init() {
        super.init(items: ["@我的", "评论", "赞"])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
