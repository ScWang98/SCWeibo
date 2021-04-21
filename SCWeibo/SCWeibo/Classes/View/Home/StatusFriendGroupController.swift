//
//  StatusFriendGroupController.swift
//  SCWeibo
//
//  Created by wangshuchao on 2021/4/21.
//

import UIKit

class GroupModel {
    var gid: String
    var name: String

    init(gid: String, name: String) {
        self.gid = gid
        self.name = name
    }
}

private var groupController: StatusFriendGroupController?
private var groupWindow: UIWindow?

class StatusFriendGroupController: UIViewController {
    private var tableView = UITableView()
    private var maskView = UIView()

    private var lastKeyWindow: UIWindow?

    private var groupList: [GroupModel]

    private var dismissHandler: ((GroupModel?) -> Void)?

    init(groupList: [GroupModel]) {
        self.groupList = groupList
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        groupList = [GroupModel]()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
}

// MARK: - Public Methods

extension StatusFriendGroupController {
    class func showGroupController(groupList: [GroupModel], dismissHandler: ((GroupModel?) -> Void)? = nil) {
        groupWindow = UIWindow(frame: UIApplication.shared.sc.keyWindow?.frame ?? UIScreen.main.bounds)
        groupWindow?.windowLevel = .init(30000)
        groupWindow?.windowScene = UIApplication.shared.sc.keyWindow?.windowScene
        groupWindow?.isHidden = true
        groupController = StatusFriendGroupController(groupList: groupList)
        groupController?.lastKeyWindow = UIApplication.shared.sc.keyWindow
        groupController?.view.alpha = 0
        groupController?.dismissHandler = dismissHandler
        groupWindow?.rootViewController = groupController
        groupWindow?.makeKeyAndVisible()
        UIView.animateKeyframes(withDuration: 0.15, delay: 0) {
            groupController?.view.alpha = 1
        }
    }

    class func dismissGroupController() {
        groupController?.dismissGroupController(groupModel: nil)
    }
}

// MARK: - Private Methods

private extension StatusFriendGroupController {
    func setupSubviews() {
        maskView.backgroundColor = UIColor(white: 0, alpha: 0.54)
        let tap = UITapGestureRecognizer(target: self, action: #selector(backMaskDidTap(tap:)))
        maskView.addGestureRecognizer(tap)
        view.addSubview(maskView)
        maskView.frame = view.bounds

        tableView.backgroundColor = UIColor.white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 0
        tableView.separatorStyle = .singleLine
        tableView.layer.cornerRadius = 6
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        view.addSubview(tableView)
        let height = min(view.height * 3 / 4, 40.0 * CGFloat(groupList.count))
        tableView.anchorToEdge(.top, padding: view.height / 8, width: view.width * 3 / 4, height: height)
    }

    func dismissGroupController(groupModel: GroupModel?) {
        dismissHandler?(groupModel)

        UIView.animate(withDuration: 0.15) {
            self.view.alpha = 0
        } completion: { _ in
            groupWindow?.endEditing(true)
            groupWindow?.isHidden = true
            self.lastKeyWindow?.makeKeyAndVisible()
            groupController = nil
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension StatusFriendGroupController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let groupModel = groupList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        cell.textLabel?.text = groupModel.name
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = groupList[indexPath.row]
        dismissGroupController(groupModel: model)
    }
}

// MARK: - Action

@objc private extension StatusFriendGroupController {
    func backMaskDidTap(tap: UITapGestureRecognizer) {
        dismissGroupController(groupModel: nil)
    }
}
