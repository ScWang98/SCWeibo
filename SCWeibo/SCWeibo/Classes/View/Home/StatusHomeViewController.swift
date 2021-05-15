//
//  StatusHomeViewController.swift
//  SCWeibo
//
//  Created by scwang on 2021/3/14.
//

import UIKit

class StatusHomeViewController: StatusListViewController {
    let avatarView = NavigationAvatarView()
    let titleButton = HomeTitleButton()
    
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

private extension StatusHomeViewController {
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
        let writeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(writeButtonDidClicked(sender:)))
        navigationItem.rightBarButtonItems = [writeButton, queryButton]

        navigationItem.title = "主页"
        titleButton.frame = CGRect(x: 0, y: 0, width: 70, height: 21)
        titleButton.addTarget(self, action: #selector(titleButtonDidClicked(sender:)), for: .touchUpInside)
        navigationItem.titleView = titleButton
    }
}

// MARK: - Actions

@objc private extension StatusHomeViewController {
    func avatarDidClicked() {
        if !AccountManager.shared.isLogin {
            NotificationCenter.default.post(name: NSNotification.Name(MNUserShouldLoginNotification), object: nil)
        }
        print("avatarDidClicked")
    }

    func queryButtonDidClicked(sender: Any) {
        print("queryButtonDidClicked")
    }

    func writeButtonDidClicked(sender: Any) {
        Router.open(url: "pillar://writeStatus")
    }

    func titleButtonDidClicked(sender: Any) {
        guard let groupModels = groupModels,
              groupModels.count > 0 else {
            return
        }
        titleButton.isSelected = !titleButton.isSelected

        StatusFriendGroupController.showGroupController(groupList: groupModels) { [weak self] groupModel in
            self?.titleButton.isSelected = false
            if let groupModel = groupModel {
                self?.service.gid = groupModel.gid
                self?.titleButton.title = groupModel.name
            }
        }
    }
}

class HomeTitleButton: UIButton {
    override var isSelected: Bool {
        didSet {
            let transform = isSelected ? CATransform3DRotate(CATransform3DIdentity, CGFloat.pi, 1, 0, 0) : CATransform3DIdentity
            UIView.animate(withDuration: 0.2) {
                self.imageView?.transform3D = transform
            }
        }
    }
    
    var title: String? {
        set (title) {
            let attrTitle = NSAttributedString(string: title ?? "", attributes: [.font: UIFont.boldSystemFont(ofSize: 17)])
            setAttributedTitle(attrTitle, for: .normal)
            self.sizeToFit()
        }
        get {
            return attributedTitle(for: .normal)?.string
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        title = "主页"
        setImage(UIImage(named: "DownArrow_Normal"), for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.center = center
        imageView?.center = CGPoint(x: (titleLabel?.right ?? 0) + (imageView?.width ?? 0) / 2, y: titleLabel?.centerY ?? 0)
    }
}
